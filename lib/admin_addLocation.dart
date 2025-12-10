import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminAddLocationPage extends StatefulWidget {
  const AdminAddLocationPage({super.key});

  @override
  State<AdminAddLocationPage> createState() => _AdminAddLocationPageState();
}

class _AdminAddLocationPageState extends State<AdminAddLocationPage> {
  LatLng _pickedLocation = const LatLng(23.5859, 58.4059);
  GoogleMapController? _mapController;
  bool _locationPermissionGranted = false;

  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.status;
    if (status.isGranted) {
      setState(() => _locationPermissionGranted = true);
    } else {
      final result = await Permission.location.request();
      if (result.isGranted) {
        setState(() => _locationPermissionGranted = true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please allow access to your location')),
        );
      }
    }
  }

  Future<void> _saveLocation() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final address = _addressController.text.trim();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    final currentUser = FirebaseAuth.instance.currentUser;
    print("Current user email: ${currentUser?.email}");

    if (currentUser == null || currentUser.email != "admin@gmail.com") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Access denied: Only admin can add locations'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('locations').add({
        'address': address,
        'name': name,
        'phone': phone,
        'latitude': double.parse(_latController.text.trim()),
        'longitude': double.parse(_lngController.text.trim()),
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location added successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Location"),
        backgroundColor: Colors.green,
      ),
      body: _locationPermissionGranted
          ? Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedLocation,
              zoom: 13,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: (LatLng pos) => setState(() => _pickedLocation = pos),
            markers: {
              Marker(
                markerId: const MarkerId('selected'),
                position: _pickedLocation,
              ),
            },
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: "Enter Address",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an address';
                        }
                        if (!RegExp(r'^[a-zA-Z0-9\s,.-]+$').hasMatch(value)) {
                          return 'Address can only contain letters, numbers, spaces, commas and dots';
                        }
                        if (value.trim().length < 5) {
                          return 'Address must be at least 5 characters long';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: "Enter Name",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                          return 'Name should contain only letters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Enter Phone Number",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a phone number';
                        }
                        if (!RegExp(r'^[0-9]{8,15}$').hasMatch(value)) {
                          return 'Phone number must be 8–15 digits';
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      controller: _latController,
                      decoration: const InputDecoration(labelText: "Latitude"),
                      validator :(value){
                        if (value == null || value.trim().isEmpty) return "Enter latitude";
                           double? lat = double.tryParse(value);
                        if (lat == null) return "Latitude must be a number";
                        if (lat < -90 || lat > 90) return "Latitude must be between -90 and 90";
                        return null;
                        }
                    ),

                    TextFormField(
                      controller: _lngController,
                      decoration: const InputDecoration(labelText: "Longitude"),
                      validator: (value){
                      if (value == null || value.trim().isEmpty) return "Enter longitude";
                         double? lng = double.tryParse(value);
                      if (lng == null) return "Longitude must be a number";
                      if (lng < -180 || lng > 180) return "Longitude must be between -180 and 180";
                      return null;
                      },
                    ),

                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _saveLocation,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text("Submit"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
