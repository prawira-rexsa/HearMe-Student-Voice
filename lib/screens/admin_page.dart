import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../models/complaint.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  late Future<List<Complaint>> data;

  @override
  void initState() {
    super.initState();
    data = ApiService.getComplaints();
  }

  void loadData() {
    if (!mounted) return;
    setState(() {
      data = ApiService.getComplaints();
    });
  }

  void logout() async {
    await AuthService.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void deleteItem(String id) async {
    bool confirm = await _showConfirmDialog(
      "Hapus",
      "Yakin ingin menghapus keluhan ini?",
    );
    if (confirm) {
      await ApiService.deleteComplaint(id);
      loadData();
      _showSnackBar("Keluhan berhasil dihapus", Colors.redAccent);
    }
  }

  void approveItem(String id) async {
    await ApiService.updateComplaint(id, true);
    loadData();
    _showSnackBar("Keluhan telah disetujui", Colors.green);
  }

  void _showSnackBar(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<bool> _showConfirmDialog(String title, String content) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Batal"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(title, style: const TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan Stack atau memastikan Container utama mengambil seluruh layar
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
          ),
        ),
        child: SafeArea(
          bottom: false, // Agar warna putih mentok ke bawah layar
          child: Column(
            children: [
              // --- HEADER SECTION ---
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                child: Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.18)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.admin_panel_settings,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'HearMe Admin',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${AuthService.currentNpm ?? '-'}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.refresh, color: Colors.white),
                        onPressed: loadData,
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                        ),
                        onPressed: logout,
                      ),
                    ],
                  ),
                ),
              ),

              // --- WHITE CONTENT SECTION ---
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F9FE),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 22, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(
                                Icons.inbox_rounded,
                                color: Color(0xFF764BA2),
                              ),
                              SizedBox(width: 10),
                              Text(
                                'Keluhan Masuk',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          // Bagian list yang ditarik maksimal oleh Expanded
                          Expanded(
                            child: FutureBuilder<List<Complaint>>(
                              future: data,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }

                                // Handle jika data kosong atau error
                                if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return RefreshIndicator(
                                    onRefresh: () async => loadData(),
                                    child: ListView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: [
                                        SizedBox(
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.4,
                                          child: const Center(
                                            child: Text(
                                              'Tidak ada data keluhan masuk',
                                              style: TextStyle(
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }

                                final list = snapshot.data!;
                                return RefreshIndicator(
                                  onRefresh: () async => loadData(),
                                  child: ListView.separated(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    padding: const EdgeInsets.only(bottom: 24),
                                    itemCount: list.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final item = list[index];
                                      final isApproved = item.status;

                                      return _buildComplaintCard(
                                        item,
                                        isApproved,
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget kartu dipisah agar kode utama lebih bersih
  Widget _buildComplaintCard(Complaint item, bool isApproved) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        leading: CircleAvatar(
          backgroundColor: isApproved
              ? Colors.green.withOpacity(0.12)
              : Colors.orange.withOpacity(0.12),
          child: Icon(
            isApproved ? Icons.verified : Icons.pending_actions,
            color: isApproved ? Colors.green : Colors.orange,
          ),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF111827),
          ),
        ),
        subtitle: Text(
          isApproved ? 'Status: Publik' : 'Status: Menunggu Persetujuan',
          style: TextStyle(
            color: isApproved ? Colors.green : Colors.orange,
            fontSize: 13,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pengirim: ${item.npm ?? "Anonim (Data Lama)"}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF764BA2),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Isi Keluhan:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.description,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: item.id != null
                          ? () => deleteItem(item.id!)
                          : null,
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      label: const Text(
                        'Hapus',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (!isApproved)
                      ElevatedButton.icon(
                        onPressed: item.id != null
                            ? () => approveItem(item.id!)
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF764BA2),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: const Icon(Icons.check),
                        label: const Text('Approve'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
