import 'package:flutter/material.dart';

import '../models/complaint.dart';
import '../services/api_service.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Future<List<Complaint>> _pending;

  @override
  void initState() {
    super.initState();
    _pending = _loadPending();
  }

  Future<List<Complaint>> _loadPending() async {
    final all = await ApiService.getComplaints();
    return all.where((c) => c.status == false).toList();
  }

  Future<void> _refresh() async {
    setState(() => _pending = _loadPending());
    await _pending;
  }

  Future<void> _approve(Complaint c) async {
    if (c.id == null) return;
    try {
      await ApiService.updateComplaint(c.id!, true);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Keluhan di-approve')));
      await _refresh();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal approve: $e')));
    }
  }

  Future<void> _reject(Complaint c) async {
    if (c.id == null) return;
    try {
      await ApiService.deleteComplaint(c.id!);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Keluhan dihapus')));
      await _refresh();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal hapus: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Panel Moderasi')),
      body: FutureBuilder<List<Complaint>>(
        future: _pending,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final list = snapshot.data ?? [];
          if (list.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [SizedBox(height: 150), Center(child: Text('Tidak ada keluhan pending'))],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text(item.description),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () => _reject(item),
                              child: const Text('Reject'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _approve(item),
                              child: const Text('Approve'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}