
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waste_sort_ai/utils/app_colors.dart';
import 'package:waste_sort_ai/utils/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();
  
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;
  bool _isUploading = false;
  bool _isEditing = false;

  final _firstNameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _otherProfessionController = TextEditingController();
  
  String? _selectedGender;
  String? _selectedProfession;

  final List<String> _professions = [
    'Environmental Engineer', 
    'Sustainability Consultant', 
    'Waste Management Officer', 
    'Recycling Coordinator', 
    'Data Scientist', 
    'Student', 
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _surnameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _otherProfessionController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final response = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (!mounted) return;

      if (response == null) {
        final newProfile = {
          'id': user.id,
          'email': user.email,
          'firstname': 'User',
          'surname': '',
          'created_at': DateTime.now().toIso8601String(),
        };
        await supabase.from('profiles').insert(newProfile);
        setState(() {
          _profileData = newProfile;
          _isLoading = false;
          _syncControllers();
        });
      } else {
        setState(() {
          _profileData = response;
          _isLoading = false;
          _syncControllers();
        });
      }
    } catch (e) {
      debugPrint('Error fetching profile: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _syncControllers() {
    if (_profileData == null) return;
    _firstNameController.text = _profileData!['firstname'] ?? '';
    _surnameController.text = _profileData!['surname'] ?? '';
    _phoneController.text = _profileData!['phone']?.toString() ?? '';
    _dobController.text = _profileData!['dob'] ?? '';
    
    final savedProff = _profileData!['proff'];
    if (_professions.contains(savedProff)) {
      _selectedProfession = savedProff;
    } else if (savedProff != null && savedProff.isNotEmpty) {
      _selectedProfession = 'Other';
      _otherProfessionController.text = savedProff;
    }

    _selectedGender = _profileData!['gender'];
  }

  Future<void> _updateProfilePhoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (image == null) return;

    setState(() => _isUploading = true);

    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final String fileExtension = image.path.split('.').last;
      final fileName = '${user.id}_profile.${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final filePath = 'avatars/$fileName';

      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        await supabase.storage.from('profiles').uploadBinary(filePath, bytes, fileOptions: const FileOptions(upsert: true));
      } else {
        await supabase.storage.from('profiles').upload(filePath, File(image.path), fileOptions: const FileOptions(upsert: true));
      }

      final String publicUrl = supabase.storage.from('profiles').getPublicUrl(filePath);
      await supabase.from('profiles').update({'profile_pic': publicUrl}).eq('id', user.id);
      await _fetchProfile();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo updated successfully!'), behavior: SnackBarBehavior.floating));
      }
    } catch (e) {
      debugPrint('Upload Error: $e');
      _showError('Upload failed: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw 'User not found';

      final updatedData = {
        'firstname': _firstNameController.text.trim(),
        'surname': _surnameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'dob': _dobController.text.trim(),
        'gender': _selectedGender,
        'proff': _selectedProfession == 'Other' 
            ? _otherProfessionController.text.trim() 
            : _selectedProfession,
      };

      await supabase.from('profiles').update(updatedData).eq('id', user.id);
      
      if (!mounted) return;

      setState(() {
        _profileData = {..._profileData!, ...updatedData};
        _isEditing = false;
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully!'), behavior: SnackBarBehavior.floating),
      );
    } on PostgrestException catch (e) {
      debugPrint('Supabase Database Error: ${e.message}');
      _showError('Database Error: ${e.message}');
    } catch (e) {
      debugPrint('Unexpected Save Error: $e');
      _showError('Update failed. Please check your connection.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message), 
          backgroundColor: Colors.redAccent, 
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('My Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (!_isLoading)
            IconButton(
              icon: Icon(_isEditing ? Icons.close_rounded : Icons.edit_rounded),
              onPressed: () => setState(() {
                _isEditing = !_isEditing;
                if (!_isEditing) _syncControllers();
              }),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildAvatarSection(),
                    const SizedBox(height: 32),
                    if (_isEditing) _buildEditForm() else _buildViewSection(),
                    const SizedBox(height: 48),
                    if (_isEditing)
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: _saveProfile,
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          icon: const Icon(Icons.check_circle_outline_rounded),
                          label: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      )
                    else
                      _buildSignOutButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildAvatarSection() {
    final String? avatarUrl = _profileData?['profile_pic'];
    return Center(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2)),
            child: CircleAvatar(
              radius: 65,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty) ? NetworkImage(avatarUrl) : null,
              child: (avatarUrl == null || avatarUrl.isEmpty) ? const Icon(Icons.person_rounded, size: 65, color: AppColors.primary) : null,
            ),
          ),
          if (_isUploading)
            const Positioned.fill(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ),
          Positioned(
            bottom: 4,
            right: 4,
            child: GestureDetector(
              onTap: _updateProfilePhoto,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewSection() {
    final profession = _profileData?['proff'] ?? 'Not set';
    return Column(
      children: [
        Text('${_profileData?['firstname'] ?? ''} ${_profileData?['surname'] ?? ''}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
        const SizedBox(height: 32),
        _buildSectionHeader('Personal Information'),
        _buildInfoTile(Icons.person_outline_rounded, 'Full Name', '${_profileData?['firstname'] ?? ''} ${_profileData?['surname'] ?? ''}'),
        _buildInfoTile(Icons.calendar_month_rounded, 'Date of Birth', _profileData?['dob'] ?? 'Not set'),
        _buildInfoTile(Icons.wc_rounded, 'Gender', _profileData?['gender'] ?? 'Not set'),
        const SizedBox(height: 24),
        _buildSectionHeader('Professional & Contact'),
        _buildInfoTile(Icons.work_outline_rounded, 'Profession', profession),
        _buildInfoTile(Icons.phone_iphone_rounded, 'Phone', _profileData?['phone']?.toString() ?? 'Not set'),
        _buildInfoTile(Icons.alternate_email_rounded, 'Email', _profileData?['email'] ?? 'Not set'),
      ],
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        _buildEditableField(_firstNameController, 'First Name', Icons.person),
        _buildEditableField(_surnameController, 'Surname', Icons.person_outline),
        _buildEditableField(_phoneController, 'Phone Number', Icons.phone, keyboard: TextInputType.phone),
        _buildEditableField(_dobController, 'DOB (YYYY-MM-DD)', Icons.calendar_today, isReadOnly: true, onTap: () async {
          final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now());
          if (date != null) setState(() => _dobController.text = date.toString().split(' ')[0]);
        }),
        _buildDropdown('Gender', ['Male', 'Female', 'Other'], _selectedGender, (val) => setState(() => _selectedGender = val)),
        _buildDropdown('Profession', _professions, _selectedProfession, (val) => setState(() => _selectedProfession = val)),
        if (_selectedProfession == 'Other')
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _buildEditableField(_otherProfessionController, 'Specify Profession', Icons.work_history),
          ),
      ],
    );
  }

  Widget _buildEditableField(TextEditingController controller, String label, IconData icon, {bool isReadOnly = false, VoidCallback? onTap, TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        readOnly: isReadOnly,
        onTap: onTap,
        keyboardType: keyboard,
        decoration: InputDecoration(
          labelText: label, 
          prefixIcon: Icon(icon, size: 20), 
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        validator: (value) => (value == null || value.isEmpty) ? 'Required' : null,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String? value, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField<String>(
        value: value,
        isExpanded: true,
        items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label, 
          prefixIcon: const Icon(Icons.list_rounded, size: 20), 
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        validator: (val) => val == null ? 'Required' : null,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(alignment: Alignment.centerLeft, child: Padding(padding: const EdgeInsets.only(left: 4, bottom: 12), child: Text(title.toUpperCase(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.2))));
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6), 
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), 
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)), 
      child: Row(children: [Icon(icon, color: AppColors.primary, size: 22), const SizedBox(width: 16), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 11, fontWeight: FontWeight.bold)), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black87))]))])
    );
  }

  Widget _buildSignOutButton() {
    return SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () async { await supabase.auth.signOut(); if (mounted) Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false); }, icon: const Icon(Icons.logout_rounded), label: const Text('Sign Out'), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), foregroundColor: Colors.red, side: const BorderSide(color: Colors.red), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)))));
  }
}
