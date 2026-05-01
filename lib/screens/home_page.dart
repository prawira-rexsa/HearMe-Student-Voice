import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Public Board"),
      ),
      body: FutureBuilder<List<Complaint>>(
        future: complaints,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!
              .where((item) => item.status == true)
              .toList();

          if (data.isEmpty) {
            return const Center(child: Text("Belum ada keluhan"));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];

              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.description),
                  trailing: const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
    );
  }
}