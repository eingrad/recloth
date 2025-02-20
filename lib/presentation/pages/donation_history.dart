import 'package:flutter/material.dart';

class DonationHistoryScreen extends StatelessWidget {
  final List<Map<String, dynamic>> donations;

  const DonationHistoryScreen({Key? key, required this.donations}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Donation History"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: donations.length,
        itemBuilder: (context, index) {
          final donation = donations[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.all(8),
            child: ListTile(
              title: Text(donation['campaignName']),
              subtitle: Text("Pickup: ${donation['pickup_date']} at ${donation['pickup_time']}"),
              trailing: Text(donation['status']),
            ),
          );
        },
      ),
    );
  }
}
