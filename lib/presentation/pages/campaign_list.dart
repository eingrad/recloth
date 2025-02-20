import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recloth_x/data/models/campaign.dart';
import 'package:recloth_x/utils/constants/text_strings.dart';
import 'package:recloth_x/utils/theme/widgets/campaign_card_list.dart';

class CampaignScreen extends StatelessWidget {
  const CampaignScreen({super.key});

  Stream<List<Campaign>> fetchCampaigns() {
    return FirebaseFirestore.instance.collection('campaigns').snapshots().map(
          (snapshot) {
        return snapshot.docs.map((doc) {
          return Campaign.fromFirestore(doc);
        }).toList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            RTexts.campaign,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ),
      body: StreamBuilder<List<Campaign>>(
        stream: fetchCampaigns(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No campaigns available.'));
          } else {
            final campaigns = snapshot.data!;
            return ListView.separated(
              itemCount: campaigns.length,
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, index) {
                return CampaignCard(
                  campaign: campaigns[index],
                );
              },
              separatorBuilder: (context, index) => const SizedBox(height: 8),
            );
          }
        },
      ),
    );
  }
}
