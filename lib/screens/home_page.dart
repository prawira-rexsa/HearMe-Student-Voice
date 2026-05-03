  import 'package:flutter/material.dart';
  import '../services/auth_service.dart';
  import '../services/api_service.dart';
  import '../models/complaint.dart';

  class HomePage extends StatefulWidget {
    const HomePage({super.key});

    @override
    State<HomePage> createState() => _HomePageState();
  }

  class _HomePageState extends State<HomePage> {
    late Future<List<Complaint>> complaints;

    @override
    void initState() {
      super.initState();
      complaints = ApiService.getComplaints();
    }

    void handleLogout() async {
      await AuthService.logout();
      if (mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    }

    // Fungsi sederhana untuk memunculkan modal tambah keluhan
    void _showAddComplaintDialog() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        builder: (context) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20, left: 20, right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Buat Keluhan Baru", 
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextField(decoration: InputDecoration(
                labelText: "Judul Keluhan",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
              )),
              const SizedBox(height: 15),
              TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
              )),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF764BA2)),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Kirim Keluhan", style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        body: CustomScrollView(
          slivers: [
            // APP BAR MODERN DENGAN NPM USER
            SliverAppBar(
              expandedHeight: 150.0,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF764BA2),
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("HearMe", style: TextStyle(fontSize: 14, color: Colors.white70)),
                    Text("User: ${AuthService.currentNpm ?? 'Mahasiswa'}", 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed: handleLogout,
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                )
              ],
            ),

            // LIST KELUHAN
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Row(
                  children: const [
                    Icon(Icons.list_alt_rounded, color: Color(0xFF764BA2)),
                    SizedBox(width: 10),
                    Text("Keluhan Publik", 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ],
                ),
              ),
            ),

            SliverFillRemaining(
              child: FutureBuilder<List<Complaint>>(
                future: complaints,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Belum ada keluhan publik"));
                  }

                  final data = snapshot.data!.where((e) => e.status == true).toList();

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF764BA2).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.campaign_rounded, color: Color(0xFF764BA2)),
                          ),
                          title: Text(item.title, 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(item.description, 
                              maxLines: 2, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
        
        // FLOATING ACTION BUTTON UNTUK TAMBAH KELUHAN
        floatingActionButton: FloatingActionButton.extended(
          onPressed: _showAddComplaintDialog,
          backgroundColor: const Color(0xFF764BA2),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Buat Keluhan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      );
    }
  }