import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/theme/widgets/MapActionButtons.dart';
import '../../utils/theme/widgets/marker_details_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng myCurrentLocation = const LatLng(3.073281, 101.518461);
  GoogleMapController? googleMapController;
  Set<Marker> markers = {};
  bool _isLocationEnabled = false;

  /// marker location here!!
  final List<Map<String, dynamic>> predefinedLocations = [
    {
      'id': 'marker1',
      'position': LatLng(3.067361732049961, 101.50174092991136),
      'title': 'Drop-off Box 1',
      'snippet': 'Near Shell Seksyen 7, Shah Alam',
      'item': [
        {'icon': Iconsax.box, 'label': 'Top', 'detail': 'Accept top item'},
        {'icon': Iconsax.box, 'label': 'Shoes', 'detail': 'Accept shoe donations'},
        {'icon': Iconsax.box, 'label': 'Accessories', 'detail': 'Accept accessories'},
      ],
    },
    {
      'id': 'marker2',
      'position': LatLng(3.077281, 101.528461),
      'title': 'Drop-off Box 2',
      'snippet': 'Near Masjid UiTM, Shah Alam',
      'item': [
        {'icon': Iconsax.box, 'label': 'Top', 'detail': 'Accept top item'},
        {'icon': Iconsax.box, 'label': 'Bottom', 'detail': 'Accept top item'},
        {'icon': Iconsax.box, 'label': 'Shoes', 'detail': 'Accept shoe donations'},
      ],
    },
    {
      'id': 'marker3',
      'position': LatLng(3.083281, 101.538461),
      'title': 'Drop-off Box 3',
      'snippet': 'Near Shell Seksyen 7, Shah Alam',
      'item': [
        {'icon': Iconsax.box, 'label': 'Top', 'detail': 'Accept top item'},
        {'icon': Iconsax.box, 'label': 'Bottom', 'detail': 'Accept bottom item'},
        {'icon': Iconsax.box, 'label': 'Accessories', 'detail': 'Accept accessories'},
      ],
    },
  ];

  @override
  void initState() {
    _initializePredefinedMarkers();
    _requestLocationPermission();
    super.initState();
  }

  Future<void> _requestLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled. Please enable them.');
    }
    
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied. Please enable them in settings.',
      );
    }
    
    setState(() {
      _isLocationEnabled = true;
    });
  }

  /// predefined markers
  void _initializePredefinedMarkers() {
    for (var location in predefinedLocations) {
      markers.add(
        Marker(
          markerId: MarkerId(location['id']),
          position: location['position'],
          onTap: () => _showMarkerDetails(location),
        ),
      );
    }
  }

  void _showMarkerDetails(Map<String, dynamic> markerData) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) => MarkerDetailsCard(markerData: markerData),
    );
  }
  
  Future<Position> currentPosition() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  ///MAPS
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.map),
            Text(
              'Maps',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          ///Google Map
          GoogleMap(
            key: ValueKey(_isLocationEnabled),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
              setState(() {});
            },
            initialCameraPosition: CameraPosition(
              target: myCurrentLocation,
              zoom: 14,
            ),
          ),
          if (googleMapController != null)
            MapActionButtons(
              controller: googleMapController!,
              getCurrentPosition: currentPosition,
              markers: markers,
              updateMarkers: () => setState(() {}),
            ),
        ],
      ),
    );
  }
}