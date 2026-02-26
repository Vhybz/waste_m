
import 'package:cjt_scan/data/mock_data.dart';
import 'package:cjt_scan/models/scan_result.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final Set<AnemiaStatus> _filters = {};

  List<ScanResult> get _filteredResults {
    if (_filters.isEmpty) {
      return mockHistory;
    }
    return mockHistory.where((result) => _filters.contains(result.status)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan History')),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _filteredResults.isEmpty
                ? const Center(
                    child: Text('No scan history found.', style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredResults.length,
                    itemBuilder: (context, index) {
                      final result = _filteredResults[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(Icons.image_not_supported, color: Colors.grey),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${result.confidence.toStringAsFixed(1)}% Confidence',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${result.date.day}/${result.date.month}/${result.date.year}',
                                      style: TextStyle(color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: result.statusColor,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  result.statusText.split(' ').first,
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FilterChip(
            label: const Text('Normal'),
            selected: _filters.contains(AnemiaStatus.normal),
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  _filters.add(AnemiaStatus.normal);
                } else {
                  _filters.remove(AnemiaStatus.normal);
                }
              });
            },
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Flagged'),
            selected: _filters.contains(AnemiaStatus.mild) || _filters.contains(AnemiaStatus.moderate) || _filters.contains(AnemiaStatus.severe),
            onSelected: (selected) {
               setState(() {
                if (selected) {
                  _filters.add(AnemiaStatus.mild);
                  _filters.add(AnemiaStatus.moderate);
                  _filters.add(AnemiaStatus.severe);
                } else {
                  _filters.remove(AnemiaStatus.mild);
                  _filters.remove(AnemiaStatus.moderate);
                  _filters.remove(AnemiaStatus.severe);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}
