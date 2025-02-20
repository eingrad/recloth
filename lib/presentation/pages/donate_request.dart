import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:recloth_x/presentation/pages/campaign_list.dart';
import 'package:uuid/uuid.dart';

class DonationRequestScreen extends StatefulWidget {
  final String campaignId;
  final String uid;

  const DonationRequestScreen({super.key, required this.campaignId, required this.uid});

  @override
  State<DonationRequestScreen> createState() => _DonationRequestScreenState();
}

class _DonationRequestScreenState extends State<DonationRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _mobilePhoneController = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();

  String? country = "Choose one";
  String? state = "Choose one";
  LatLng? _selectedLocation;
  LatLng? _userLocation;
  GoogleMapController? _mapController;
  LatLng _initialPosition = const LatLng(3.1390, 101.6869);
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    _determinePosition();
  }

  Future<void> _fetchUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();

      if (userDoc.exists) {
        final userData = userDoc.data();
        setState(() {
          // Pre-fill the fields with user data
          _firstNameController.text = userData?['firstName'] ?? '';
          _lastNameController.text = userData?['lastName'] ?? '';
          _addressLineController.text = userData?['address'] ?? '';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error fetching user data: $e")),
        );
      }
    }
  }

  Future<void> _selectDate(String campaignId) async {
    try {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Loading campaign details...")),
        );
      }
      final campaignSnapshot = await FirebaseFirestore.instance
          .collection('campaigns')
          .doc(widget.campaignId)
          .get();

      if (!campaignSnapshot.exists) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Campaign not found.")),
          );
        }
        return;
      }

      DateTime startDate = (campaignSnapshot['startDate'] as Timestamp).toDate();
      DateTime endDate = (campaignSnapshot['endDate'] as Timestamp).toDate();
      DateTime today = DateTime.now();

      DateTime minSelectableDate = today.isAfter(startDate) ? today : startDate;

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
      }

      final pickedDate = await showDatePicker(
        context: context,
        initialDate: minSelectableDate,
        firstDate: minSelectableDate,
        lastDate: endDate,
        selectableDayPredicate: (DateTime date) {
          return date.weekday != DateTime.sunday;
        },
      );

      if (pickedDate != null) {
        setState(() {
          _selectedDate = pickedDate;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to load campaign dates.")),
        );
      }
    }
  }

  Future<void> _selectTime() async {
    final pickedTime = await showTimePicker(
        context: context,
        initialTime: const TimeOfDay(hour: 9, minute: 0),
    );

    if (pickedTime != null && pickedTime.hour >= 9 && pickedTime.hour <= 18){
      setState(() {
        _selectedTime = pickedTime;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a time within working hours")),
      );
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Location Services Disabled"),
            content: const Text(
                "Location services are disabled. Please enable them in your device settings."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Geolocator.openLocationSettings();
                },
                child: const Text("Open Settings"),
              ),
            ],
          ),
        );
      }
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Location permission is required to use this feature."),
            ),
          );
          return;
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Permission Required"),
            content: const Text(
                "Location permissions are permanently denied. Please enable them in your device settings."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await Geolocator.openAppSettings();
                },
                child: const Text("Open Settings"),
              ),
            ],
          ),
        );
      }
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
        _initialPosition = _userLocation!;
        _selectedLocation = _userLocation!;
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_userLocation!, 14.0),
      );
    }
  }

  Future<void> _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (_selectedLocation == null || _selectedDate == null || _selectedTime == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Please complete all fields, including date and time")),
            );
          }
          return;
        }

        if (_selectedDate!.weekday == DateTime.sunday) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Requests cannot be made for Sundays. Please select another date.")),
          );
          return;
        }

  final selectDateTime = DateTime(
    _selectedDate!.year,
    _selectedDate!.month,
    _selectedDate!.day,
    _selectedTime!.hour,
    _selectedTime!.minute,
  );

        final requestId = const Uuid().v4();

        await FirebaseFirestore.instance
            .collection('campaigns')
            .doc(widget.campaignId) // Store under the selected campaign ID
            .collection('donation_requests')
            .doc(requestId)
            .set({
          'uid' : widget.uid,
          'request_id' : requestId,
          'campaignId' : widget.campaignId,
          'status' : 'pending',
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'mobile_phone': _mobilePhoneController.text,
          'address_line': _addressLineController.text,
          'latitude': _selectedLocation!.latitude,
          'longitude': _selectedLocation!.longitude,
          'country': country,
          'state': state,
          'city': _cityController.text,
          'zip_code': _zipCodeController.text,
          'pickup_date_time' : Timestamp.fromDate(selectDateTime),
          'timestamp': Timestamp.now(),
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Donation request sent successfully!")),
          );
          _formKey.currentState!.reset();
          _firstNameController.clear();
          _lastNameController.clear();
          _mobilePhoneController.clear();
          _addressLineController.clear();
          _cityController.clear();
          _zipCodeController.clear();
          setState(() {
            _selectedLocation = null;
            _selectedDate = null;
            _selectedTime = null;
            country = "Choose one";
            state = "Choose one";
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Failed to send donation request: $e")),
          );
        }
      }
    }
  }

  void _onMapTapped(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Donation Pickup Request",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameController,
                        decoration: const InputDecoration(
                          labelText: "First name *",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value!.isEmpty ? "Please enter your first name" : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameController,
                        decoration: const InputDecoration(
                          labelText: "Last name *",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value!.isEmpty ? "Please enter your last name" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _mobilePhoneController,
                  decoration: const InputDecoration(
                    labelText: "Mobile phone *",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                  value!.isEmpty ? "Please enter your mobile phone number" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressLineController,
                  decoration: const InputDecoration(
                    labelText: "Address line *",
                    border: OutlineInputBorder(),
                  ),
                  maxLines: null,
                  validator: (value) =>
                  value!.isEmpty ? "Please enter your address" : null,
                ),
                const SizedBox(height: 16),

                ///---------Map-------///
                const Text("Pin point"),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox(
                    height: 250,
                    child: Stack(
                      children: [
                        GoogleMap(
                          onMapCreated: (GoogleMapController controller) {
                            _mapController = controller;
                          },
                          initialCameraPosition: CameraPosition(
                            target: _initialPosition,
                            zoom: 14.0,
                          ),
                          onTap: _onMapTapped,
                          markers: {
                            if (_selectedLocation != null)
                              Marker(
                                markerId: const MarkerId('selected-location'),
                                position: _selectedLocation!,
                                draggable: true,
                                zIndex: 0.0,
                                onDragEnd: (newPosition){
                                  setState(() {
                                    _selectedLocation = newPosition;
                                  });
                                },
                              ),
                          },
                          gestureRecognizers: {},
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              if (_userLocation != null) {
                                _mapController?.animateCamera(
                                  CameraUpdate.newLatLngZoom(
                                      _userLocation!, 14.0),
                                );
                              }
                            },

                            child: const Text(
                              "My Location",
                              style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    DropdownButtonFormField<String>(
                      value: country,
                      items: ["Choose one", "Malaysia"].map((country) {
                        return DropdownMenuItem(
                          value: country,
                          child: Text(country),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          country = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "Country *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == "Choose one" ? "Please select a country" : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: state,
                      items: ["Choose one", "Selangor"].map((state) {
                        return DropdownMenuItem(
                          value: state,
                          child: Text(state),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          state = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: "State *",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                      value == "Choose one" ? "Please select a state" : null,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: "City *",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value!.isEmpty ? "Please enter your city" : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _zipCodeController,
                        decoration: const InputDecoration(
                          labelText: "Zip code *",
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) =>
                        value!.isEmpty ? "Please enter your zip code" : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text("Select Pickup Time and Date"),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: () => _selectDate(widget.campaignId),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, color: Colors.black54),
                        const SizedBox(width: 8),
                        Text(
                          _selectedDate == null
                              ? "Select Date"
                              : DateFormat('yMMMd').format(_selectedDate!),
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _selectTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time, color: Colors.black54),
                        const SizedBox(width: 8),
                        Text(
                          _selectedTime == null
                              ? "Select Time"
                              : _selectedTime!.format(context),
                          style: const TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OutlinedButton(
                      onPressed: () {Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CampaignScreen()));
                      },
                      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(
                        horizontal: 54,
                        vertical: 14,
                      )),
                      child: const Text("Cancel"),
                    ),

                    ElevatedButton(
                      onPressed: _submitRequest,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                      ),
                      child: const Text("Send Request"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
