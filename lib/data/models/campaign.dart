import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Campaign {
  final String id;
  final String campaignName;
  final String description;
  final String item;
  final String startDate;
  final String endDate;
  final String imageUrl;

  Campaign({
    required this.id,
    required this.campaignName,
    required this.description,
    required this.item,
    required this.startDate,
    required this.endDate,
    required this.imageUrl,
  });

  /// Factory method to create a Campaign instance from Firestore
  factory Campaign.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    return Campaign(
      id: doc.id,
      campaignName: data['campaignName'] ?? '',
      description: data['description'] ?? '',
      item: data['item'] ?? '',
      startDate: formatter.format((data['startDate'] as Timestamp).toDate()),
      endDate: formatter.format((data['endDate'] as Timestamp).toDate()),
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}