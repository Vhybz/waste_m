
import 'package:cjt_scan/models/scan_result.dart';
import 'package:cjt_scan/utils/app_colors.dart';
import 'package:cjt_scan/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  ScanResult? _lastScan;
  String _userName = 'User';
  String _userTitle = '';
  String? _profileImageUrl;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await Future.wait([
      _fetchProfileData(),
      _fetchLastScan(),
    ]);
  }

  Future<void> _fetchProfileData() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final data = await supabase
          .from('profiles')
          .select('firstname, profile_pic, gender')
          .eq('id', user.id)
          .maybeSingle();

      if (data != null && mounted) {
        final String rawGender = (data['gender'] ?? '').toString().toLowerCase();
        
        setState(() {
          _userName = data['firstname'] ?? 'User';
          _profileImageUrl = data['profile_pic'];
          
          if (rawGender == 'male') {
            _userTitle = 'Mr. ';
          } else if (rawGender == 'female') {
            _userTitle = 'Miss ';
          } else {
            _userTitle = '';
          }
        });
      }
    } catch (e) {
      debugPrint('Error fetching profile data: $e');
    }
  }

  Future<void> _fetchLastScan() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final data = await supabase
          .from('scans')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (mounted) {
        setState(() {
          if (data != null) {
            _lastScan = ScanResult.fromJson(data);
          }
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching last scan: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;
    final bool isEmailVerified = user?.emailConfirmedAt != null;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFE),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7E57C2), Color(0xFF9575CD)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7E57C2).withValues(alpha: 0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 26),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome back,',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withValues(alpha: 0.8),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          '$_userTitle$_userName',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildTopProfileAvatar(),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: AppDrawer(userName: '$_userTitle$_userName', profileImageUrl: _profileImageUrl),
      body: RefreshIndicator(
        onRefresh: _fetchInitialData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isEmailVerified) _buildVerificationBanner(user?.email),
              
              const Text(
                'Health Overview',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 16),
              
              _HeroScanButton(onTap: () {
                Navigator.pushNamed(context, AppRoutes.capture);
              }),
              
              const SizedBox(height: 32),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Recent Screening',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  if (_lastScan != null)
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, AppRoutes.history),
                      child: const Text('View All'),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              
              _isLoading 
                ? const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
                : _LastScanCard(scanResult: _lastScan),
              
              const SizedBox(height: 32),
              const _InfoBanner(),
              const SizedBox(height: 80), 
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.chat),
        backgroundColor: AppColors.primary,
        elevation: 4,
        child: const Icon(Icons.support_agent_rounded, size: 32, color: Colors.white),
      ),
    );
  }

  Widget _buildTopProfileAvatar() {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.profile),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5),
        ),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.white.withValues(alpha: 0.2),
          backgroundImage: (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) 
              ? NetworkImage(_profileImageUrl!) 
              : null,
          child: (_profileImageUrl == null || _profileImageUrl!.isEmpty)
              ? const Icon(Icons.person_rounded, color: Colors.white, size: 22)
              : null,
        ),
      ),
    );
  }

  Widget _buildVerificationBanner(String? email) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded, color: Colors.orange),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Verify Email',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                ),
                Text(
                  'Protect your screening history.',
                  style: TextStyle(fontSize: 12, color: Colors.orange.shade800),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () async {
              await supabase.auth.resend(type: OtpType.signup, email: email);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Confirmation link sent!')),
                );
              }
            },
            child: const Text('Resend', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class _HeroScanButton extends StatelessWidget {
  final VoidCallback onTap;
  const _HeroScanButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 160),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF5E35B1), Color(0xFF7E57C2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF5E35B1).withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(28),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  bottom: -20,
                  child: Icon(Icons.camera_alt, size: 120, color: Colors.white.withValues(alpha: 0.1)),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Instant Screening',
                        style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'AI conjunctiva scan analysis',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Text(
                          'Start Screening',
                          style: TextStyle(color: Color(0xFF5E35B1), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LastScanCard extends StatelessWidget {
  final ScanResult? scanResult;
  const _LastScanCard({this.scanResult});

  @override
  Widget build(BuildContext context) {
    if (scanResult == null) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(Icons.analytics_outlined, size: 48, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(
              'No screenings yet',
              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            Text(
              'Your scan results will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade400, fontSize: 13),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: scanResult!.statusColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(Icons.assignment_turned_in_rounded, color: scanResult!.statusColor, size: 28),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  scanResult!.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        '${scanResult!.date.day}/${scanResult!.date.month}/${scanResult!.date.year}',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${scanResult!.confidence.toInt()}%',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF5E35B1)),
                ),
                const Text('Accuracy', style: TextStyle(color: Colors.grey, fontSize: 10)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF3E5F5),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.tips_and_updates_rounded, color: Color(0xFF5E35B1), size: 32),
          const SizedBox(height: 12),
          const Text(
            'Clinical Health Tip',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Text(
            'Regular screening helps detect potential iron deficiency early. Maintain a diet rich in iron and vitamin C.',
            style: TextStyle(color: Colors.grey.shade800, height: 1.5),
          ),
        ],
      ),
    );
  }
}

class AppDrawer extends StatelessWidget {
  final String userName;
  final String? profileImageUrl;

  const AppDrawer({super.key, required this.userName, this.profileImageUrl});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    
    return Drawer(
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.horizontal(right: Radius.circular(24))),
      child: Column(
        children: [
          // Sidebar header with gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7E57C2), Color(0xFF9575CD)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.white.withValues(alpha: 0.2),
                  backgroundImage: (profileImageUrl != null && profileImageUrl!.isNotEmpty) ? NetworkImage(profileImageUrl!) : null,
                  child: (profileImageUrl == null || profileImageUrl!.isEmpty)
                    ? const Icon(Icons.person, color: Colors.white, size: 35)
                    : null,
                ),
                const SizedBox(height: 16),
                Text(
                  userName,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Text(
                  user?.email ?? 'Guest User',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // 1. PRIMARY TOOLS (High Importance)
                _buildDrawerItem(context, Icons.support_agent_rounded, 'AI Health Assistant', AppRoutes.chat),
                _buildDrawerItem(context, Icons.analytics_rounded, 'Health Analytics', AppRoutes.analytics),
                _buildDrawerItem(context, Icons.history_rounded, 'Scan History', AppRoutes.history),
                const Divider(indent: 20, endIndent: 20),
                
                // 2. CONFIGURATION (Medium Importance)
                _buildDrawerItem(context, Icons.settings_rounded, 'Account Settings', AppRoutes.settings),
                const Divider(indent: 20, endIndent: 20),
                
                // 3. INFORMATION (Last before Sign Out)
                _buildDrawerItem(context, Icons.info_outline_rounded, 'About App & Author', AppRoutes.aboutApp),
                _buildDrawerItem(context, Icons.verified_user_outlined, 'Safety Guidelines', AppRoutes.disclaimer),
                
                // 4. SESSION
                const Divider(indent: 20, endIndent: 20),
                ListTile(
                  leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                  title: const Text('Sign Out', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  onTap: () async {
                    await Supabase.instance.client.auth.signOut();
                    if (context.mounted) {
                      Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                    }
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              'AnemiaScan AI v1.0.0',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade700),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      onTap: () {
        Navigator.pop(context);
        if (ModalRoute.of(context)?.settings.name != route) {
          Navigator.pushNamed(context, route);
        }
      },
    );
  }
}
