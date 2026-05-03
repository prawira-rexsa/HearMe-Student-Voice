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
    loadData();
  }

  void loadData() {
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
    // Tambahkan dialog konfirmasi agar UX lebih aman
    bool confirm = await _showConfirmDialog("Hapus", "Yakin ingin menghapus keluhan ini?");
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
      SnackBar(content: Text(msg), backgroundColor: color, behavior: SnackBarBehavior.floating),
    );
  }

  Future<bool> _showConfirmDialog(String title, String content) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(title, style: const TextStyle(color: Colors.red))),
        ],
      ),
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // Warna background abu-abu soft
      appBar: AppBar(
        title: const Text("HearMe Admin", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.1)),
        backgroundColor: const Color(0xFF1E293B), // Navy Dark
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: loadData),
          IconButton(icon: const Icon(Icons.logout_rounded), onPressed: logout),
        ],
      ),
      body: Column(
        children: [
          // Statatistik Singkat (UX: Memberi informasi cepat ke admin)
          Container(
            padding: const EdgeInsets.all(20),
            color: const Color(0xFF1E293B),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Colors.white24,
                  child: Icon(Icons.admin_panel_settings, color: Colors.white),
                ),
                const SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Halo, Admin", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                    Text("NPM: ${AuthService.currentNpm ?? '-'}", style: const TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: FutureBuilder<List<Complaint>>(
              future: data,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("Tidak ada data keluhan masuk"));
                }

                final list = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final item = list[index];
                    bool isApproved = item.status;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))
                        ],
                      ),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: isApproved ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                          child: Icon(
                            isApproved ? Icons.verified : Icons.pending_actions,
                            color: isApproved ? Colors.green : Colors.orange,
                          ),
                        ),
                        title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        subtitle: Text(isApproved ? "Status: Publik" : "Status: Menunggu Persetujuan", 
                          style: TextStyle(color: isApproved ? Colors.green : Colors.orange, fontSize: 13)),
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                const Text("Isi Keluhan:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 5),
                                Text(item.description, style: const TextStyle(fontSize: 15, height: 1.4)),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Tombol Hapus
                                    TextButton.icon(
                                      onPressed: item.id != null ? () => deleteItem(item.id!) : null,
                                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                                      label: const Text("Hapus", style: TextStyle(color: Colors.red)),
                                    ),
                                    const SizedBox(width: 10),
                                    // Tombol Approve
                                    if (!isApproved)
                                      ElevatedButton.icon(
                                        onPressed: item.id != null ? () => approveItem(item.id!) : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        icon: const Icon(Icons.check),
                                        label: const Text("Approve"),
                                      ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}