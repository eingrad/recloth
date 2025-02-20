import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:recloth_x/utils/theme/widgets/customappBar/appBar.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/constants/text_strings.dart';
import '../../utils/theme/widgets/container/header_container.dart';
import 'donation_history.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _username;
  int _donationsCount = 0;
  String _latestDonation = "No recent donations";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _fetchDonationData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    if (uid != null) {
      final userData =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (mounted) {
        setState(() {
          _username = userData.data()?['username'] as String?;
        });
      }
    }
  }

  Future<void> _fetchDonationData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;

      try {
        final campaignsSnapshot = await FirebaseFirestore.instance
            .collection('campaigns')
            .get();

        String latestCampaignName = "No recent donations";
        DateTime? latestDonationTime;

        for (var campaign in campaignsSnapshot.docs) {
          final campaignId = campaign.id;

          final donationSnapshot = await FirebaseFirestore.instance
              .collection('campaigns')
              .doc(campaignId)
              .collection('donation_requests')
              .where('uid', isEqualTo: uid)
              .orderBy('timestamp', descending: true)
              .limit(1)
              .get();

          if (donationSnapshot.docs.isNotEmpty) {
            final latestDonation = donationSnapshot.docs.first.data();
            final timestamp = (latestDonation['timestamp'] as Timestamp).toDate();

            if (latestDonationTime == null || timestamp.isAfter(latestDonationTime)) {
              latestDonationTime = timestamp;

              final campaignData = campaign.data();
              latestCampaignName = campaignData['campaignName'] ?? "Unknown Campaign";
            }
          }
        }
        if (mounted) {
          setState(() {
            _latestDonation = latestCampaignName;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _latestDonation = "Error fetching donation";
          });
        }
      }
    } else {
      if (mounted) {
        setState(() {
          _latestDonation = "User not logged in";
        });
      }
    }
  }

  Future<List<Map<String, dynamic>>> _fetchDonationHistory() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      List<Map<String, dynamic>> donationHistory = [];

      try {
        final campaignsSnapshot = await FirebaseFirestore.instance
            .collection('campaigns')
            .get();

        for (var campaign in campaignsSnapshot.docs) {
          final campaignId = campaign.id;

          final donationSnapshot = await FirebaseFirestore.instance
              .collection('campaigns')
              .doc(campaignId)
              .collection('donation_requests')
              .where('uid', isEqualTo: user.uid)
              .orderBy('timestamp', descending: true)
              .get();

          for (var donation in donationSnapshot.docs) {
            final donationData = donation.data();
            final campaignName = campaign.data()['campaignName'] ?? "Unknown Campaign";

            // Format pickup date and time
            DateTime pickupDateTime =
            (donationData['pickup_date_time'] as Timestamp).toDate();
            String formattedDate = DateFormat('MMMM d, yyyy').format(pickupDateTime);
            String formattedTime = DateFormat('hh:mm a').format(pickupDateTime);

            // Add donation details to the list
            donationHistory.add({
              'campaignName': campaignName,
              'status': donationData['status'] ?? "Unknown",
              'pickup_date': formattedDate,
              'pickup_time': formattedTime,
            });
          }
        }
      } catch (e) {
        print("Error fetching donation history: $e");
      }

      return donationHistory;
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: HeaderContainer(
              child: Column(
                children: [
                  SizedBox(
                    height: kToolbarHeight +
                        MediaQuery.of(context).padding.top,
                  ),
                ],
              ),
            ),
          ),
          RAppBar(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: RSizes.spaceBtwSections / 2),
                Text(
                  RTexts.homeAppbarTitle,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .apply(color: RColors.grey),
                ),
                Text(
                  _username ?? RTexts.homeAppbarSubTitle,
                  style: Theme.of(context)
                      .textTheme
                      .headlineMedium!
                      .apply(color: RColors.white),
                ),
              ],
            ),
          ),
          /// Content
          Positioned.fill(
            top: kToolbarHeight + MediaQuery.of(context).padding.top,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(RSizes.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Donation Status Section
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(RSizes.cardRadius),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(RSizes.cardPadding),
                        child:

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Row(
                              children: [
                                Icon(Icons.volunteer_activism, color: RColors.orange, size: 28),
                                const SizedBox(width: RSizes.spaceBtwSections),
                                Text(
                                  "Your Donations",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .apply(fontWeightDelta: 2),
                                ),
                              ],
                            ),
                            const SizedBox(height: RSizes.spaceBtwSections),
                            Text(
                              "Total Donations: $_donationsCount",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: RSizes.spaceBtwSections / 2),
                            Text(
                              "Latest Donation: $_latestDonation",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: RSizes.spaceBtwSections/2),
                    const SizedBox(height: RSizes.spaceBtwSections/2),
                    // Donation History Section
                    FutureBuilder(
                      future: _fetchDonationHistory(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return const Center(
                            child: Text("Failed to load donation history."),
                          );
                        } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
                          return Center(
                            child: Text(
                              "No donation history available.",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          );
                        } else {
                          final donationHistory = snapshot.data as List<Map<String, dynamic>>;
                          final displayedHistory = donationHistory.take(2).toList(); // Show only first two

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: RSizes.spaceBtwSections/2),
                              Text(
                                "Donation History",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .apply(fontWeightDelta: 2),
                              ),
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: displayedHistory.length,
                                itemBuilder: (context, index) {
                                  final donation = displayedHistory[index];
                                  return Card(
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(RSizes.cardRadius),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(RSizes.cardPadding),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.history, color: RColors.orange, size: 28),
                                              const SizedBox(width: RSizes.spaceBtwSections),
                                              Text(
                                                donation['campaignName'],
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall!
                                                    .apply(fontWeightDelta: 2),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: RSizes.spaceBtwSections / 2),
                                          Text(
                                            "Status: ${donation['status']}",
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                          const SizedBox(height: RSizes.spaceBtwSections / 2),
                                          Text(
                                            "Pickup Date: ${donation['pickup_date']}",
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                          const SizedBox(height: RSizes.spaceBtwSections / 2),
                                          Text(
                                            "Pickup Time: ${donation['pickup_time']}",
                                            style: Theme.of(context).textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              if (donationHistory.length > 0) // Show "View All" if more than 2 donations
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DonationHistoryScreen(donations: donationHistory),
                                        ),
                                      );
                                    },
                                    child: const Text("View All"),
                                  ),
                                ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
