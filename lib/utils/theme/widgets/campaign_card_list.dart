import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recloth_x/data/models/campaign.dart';
import 'package:recloth_x/presentation/pages/campaign_details.dart';
import 'package:recloth_x/utils/constants/colors.dart';
import '../../helpers/helper_functions.dart';

class CampaignCard extends StatelessWidget {
  const CampaignCard({super.key, required this.campaign});
  final Campaign campaign;

  @override
  Widget build(BuildContext context) {
    final dark = RHelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CampaignDetails(campaign: campaign),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: dark ? RColors.black: RColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: dark ? RColors.darkerGrey: RColors.grey,
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(campaign.imageUrl, height: 120, fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            Text(
              campaign.campaignName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Iconsax.calendar_1, size: 16,),
                Text(
                  "  ${campaign.startDate} to ${campaign.endDate}",
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ]
            ),
          ],
        ),
      ),
    );
  }
}
