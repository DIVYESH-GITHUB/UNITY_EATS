import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DonationHistoryScreen extends StatefulWidget {
  const DonationHistoryScreen({super.key});

  @override
  State<DonationHistoryScreen> createState() => _DonationHistoryScreenState();
}

class _DonationHistoryScreenState extends State<DonationHistoryScreen> {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final donationCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser?.email)
        .collection('donations');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donation History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: donationCollection.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final donationDocs = snapshot.data!.docs;

          if (donationDocs.isEmpty) {
            return const Center(
              child: Text('No donations yet.'),
            );
          }

          return ListView.builder(
            itemCount: donationDocs.length,
            itemBuilder: (context, index) {
              final donationData =
                  donationDocs[index].data() as Map<String, dynamic>;
              final foodDescription = donationData['foodDescription'];
              final date = donationData['date'];
              final time = donationData['time'];
              final address = donationData['address'];
              final imageUrl = donationData['imageUrl'];
              final totalPersonCanFeed = donationData['totalPersonCanFeed'];
              final weight = donationData['weight'];
              final foodSource = donationData['foodSource'];
              final status = donationData['status'];
              return DonationCard(
                totalPersonCanFeed: totalPersonCanFeed,
                foodDescription: foodDescription,
                date: date,
                time: time,
                address: address,
                imageUrl: imageUrl,
                weight: weight,
                foodSource: foodSource,
                status: status,
              );
            },
          );
        },
      ),
    );
  }
}

class DonationCard extends StatelessWidget {
  final String foodDescription;
  final String date;
  final String time;
  final String address;
  final String imageUrl;
  final String totalPersonCanFeed;
  final String weight;
  final String foodSource;
  final String status;
  const DonationCard({
    super.key,
    required this.status,
    required this.weight,
    required this.foodDescription,
    required this.date,
    required this.time,
    required this.address,
    required this.imageUrl,
    required this.totalPersonCanFeed,
    required this.foodSource,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          Stack(
            children: [
              Image.network(
                imageUrl,
                width: double.infinity,
                height: 200.0,
                fit: BoxFit.cover,
              ),
              const Positioned(
                top: 12,
                left: 347,
                child: Icon(
                  Icons.info,
                  size: 27,
                ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: status == 'new'
                        ? Colors.yellow
                        : status == 'requested'
                            ? Colors.orange
                            : Colors.green,
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.black,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 7,
          ),
          ListTile(
            title: Text(
              'Food Description : $foodDescription',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  thickness: 1,
                  color: Colors.white,
                ),
                Text(
                  'Date : $date',
                  style: const TextStyle(
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Time : $time',
                  style: const TextStyle(
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Total person can feed : $totalPersonCanFeed',
                  style: const TextStyle(
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Weight : $weight Kg',
                  style: const TextStyle(
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Food source : $foodSource',
                  style: const TextStyle(
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  'Address : $address ',
                  style: const TextStyle(
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
