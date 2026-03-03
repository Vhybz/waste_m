
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:waste_sort_ai/models/scan_result.dart';
import 'package:waste_sort_ai/utils/app_colors.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final supabase = Supabase.instance.client;
  List<ScanResult> _scans = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchScans();
  }

  Future<void> _fetchScans() async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      final List<dynamic> data = await supabase
          .from('scans')
          .select()
          .eq('user_id', user.id)
          .order('created_at', ascending: true);

      if (mounted) {
        setState(() {
          _scans = data.map((json) => ScanResult.fromJson(json)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error fetching analytics data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Sorting Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _scans.isEmpty
              ? _buildEmptyState()
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSummaryStats(),
                      const SizedBox(height: 32),
                      const Text('Waste Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 16),
                      _buildPieChartCard(),
                      const SizedBox(height: 32),
                      const Text('Confidence Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 16),
                      _buildLineChartCard(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSummaryStats() {
    final avgConfidence = _scans.isEmpty 
        ? 0.0 
        : _scans.map((s) => s.confidence).reduce((a, b) => a + b) / _scans.length;

    return Row(
      children: [
        _StatCard(title: 'Total Classified', value: '${_scans.length}', icon: Icons.recycling_rounded, color: AppColors.primary),
        const SizedBox(width: 16),
        _StatCard(title: 'Avg. Confidence', value: '${avgConfidence.toInt()}%', icon: Icons.auto_awesome_rounded, color: Colors.orange),
      ],
    );
  }

  Widget _buildPieChartCard() {
    final counts = <WasteStatus, int>{};
    for (var s in _scans) {
      counts[s.status] = (counts[s.status] ?? 0) + 1;
    }

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: counts.entries.map((entry) {
                return PieChartSectionData(
                  color: entry.key.color,
                  value: entry.value.toDouble(),
                  title: '',
                  radius: 50,
                );
              }).toList(),
              centerSpaceRadius: 40,
              sectionsSpace: 4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLineChartCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 32, 16),
        child: SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: const FlGridData(show: false),
              titlesData: const FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: _scans.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.confidence)).toList(),
                  isCurved: true,
                  color: AppColors.primary,
                  barWidth: 4,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(show: true, color: AppColors.primary.withValues(alpha: 0.1)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.analytics_outlined, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text('No data recorded for analysis yet.', style: TextStyle(color: Colors.grey.shade500, fontSize: 16)),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
