
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:waste_sort_ai/theme/theme_provider.dart';
import 'package:waste_sort_ai/utils/app_colors.dart';
import 'package:waste_sort_ai/utils/app_routes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final supabase = Supabase.instance.client;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionHeader('Appearance'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.grey.shade200)),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined, color: AppColors.primary),
                  title: const Text('Dark Mode'),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (val) => themeProvider.toggleTheme(val),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader('Account'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.grey.shade200)),
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.lock_reset_rounded,
                  title: 'Change Password',
                  onTap: () async {
                    final email = supabase.auth.currentUser?.email;
                    if (email != null) {
                      await supabase.auth.resetPasswordForEmail(email);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset link sent!')));
                    }
                  },
                ),
                const Divider(height: 1, indent: 56),
                _buildSettingsTile(
                  icon: Icons.logout_rounded,
                  title: 'Sign Out',
                  color: Colors.red,
                  onTap: () async {
                    await supabase.auth.signOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader('Support'),
          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.grey.shade200)),
            child: Column(
              children: [
                _buildSettingsTile(
                  icon: Icons.verified_user_outlined,
                  title: 'Safety & Usage Guidelines',
                  onTap: () => Navigator.pushNamed(context, AppRoutes.disclaimer),
                ),
                const Divider(height: 1, indent: 56),
                const ListTile(
                  leading: Icon(Icons.info_outline_rounded, color: Colors.grey),
                  title: Text('Version'),
                  trailing: Text('1.0.0', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary, letterSpacing: 1.2),
      ),
    );
  }

  Widget _buildSettingsTile({required IconData icon, required String title, required VoidCallback onTap, Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? AppColors.primary),
      title: Text(title, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.grey),
      onTap: onTap,
    );
  }
}
