import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart';

class MapPickerPage extends StatefulWidget {
  const MapPickerPage({super.key});

  @override
  State<MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<MapPickerPage> {
  LatLng _pickedLocation = const LatLng(23.5859, 58.4059); // مسقط
  GoogleMapController? _mapController;
  bool _locationPermissionGranted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _requestLocationPermission();
    });
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

  Future<void> _goToCurrentLocation() async {
    final location = Location();

    bool serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location service')),
        );
        return;
      }
    }

    await location.changeSettings(accuracy: LocationAccuracy.high);

    final current = await location.getLocation();
    final currentLatLng = LatLng(current.latitude!, current.longitude!);

    setState(() {
      _pickedLocation = currentLatLng;
    });

    _mapController?.animateCamera(CameraUpdate.newLatLng(currentLatLng));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,

      ),
      body: _locationPermissionGranted
          ? Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _pickedLocation,
              zoom: 14,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: (LatLng pos) {
              setState(() => _pickedLocation = pos);
            },
            markers: {
              Marker(
                markerId: const MarkerId('picked'),
                position: _pickedLocation,
                draggable: true,
                onDragEnd: (pos) => setState(() => _pickedLocation = pos),
              ),
            },
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const Text(
                "To select your location, either click on the map or top the location button",
                style: TextStyle(fontSize: 14, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      )
          : Center(
        child: ElevatedButton(
          onPressed: _requestLocationPermission,
          child: const Text('Allow access to your location'),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'current_location',
            backgroundColor: Colors.blue,
            child: const Icon(Icons.my_location),
            onPressed: _goToCurrentLocation,
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'confirm',
            backgroundColor: Colors.green,
            child: const Icon(Icons.check),
            onPressed: () {
              if (_locationPermissionGranted) {
                Navigator.pop(context, _pickedLocation);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please allow access to your location')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
