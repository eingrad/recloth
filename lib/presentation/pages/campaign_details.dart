import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recloth_x/data/models/campaign.dart';
import 'package:recloth_x/presentation/pages/donate_request.dart';
import 'package:recloth_x/utils/helpers/helper_functions.dart';

import '../../utils/constants/colors.dart';

class CampaignDetails extends StatelessWidget {
  final Campaign campaign;
  const CampaignDetails({super.key, required this.campaign});

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Iconsax.info_circle),
            Expanded(
              child: Text(
                '  ${campaign.campaignName}',
                style: Theme.of(context).textTheme.headlineSmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///campaign image
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(campaign.imageUrl, fit: BoxFit.cover, height: 200, width: double.infinity),
            ),
            const SizedBox(height: 20),

            ///box
            Container(
              decoration: BoxDecoration(
                color: dark ? RColors.black : RColors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: dark ? RColors.darkerGrey : RColors.grey,
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description:", style: Theme.of(context).textTheme.labelMedium,
                      textAlign: TextAlign.justify),
                  const SizedBox(height: 5),
                  Text(campaign.description, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 10),
                  Text("Item Needed:", style: Theme.of(context).textTheme.labelMedium),
                  const SizedBox(height: 5),
                  Text(campaign.item, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Start Date:", style: Theme.of(context).textTheme.labelMedium),
                            Text(campaign.startDate, style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("End Date:", style: Theme.of(context).textTheme.labelMedium),
                            Text(campaign.endDate, style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.ellipsis,),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DonationRequestScreen(
                          campaignId: campaign.id,
                          uid: user.uid,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("User not logged in.")),
                    );
                  }
                },
                child: const Text("Donate"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
