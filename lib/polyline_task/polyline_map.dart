import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';



class PolylineMap extends StatefulWidget {
  @override
  _PolylineMapState createState() => _PolylineMapState();
}

class _PolylineMapState extends State<PolylineMap> {
  late GoogleMapController _mapController;
  List<Marker> _markers = [];
  Polyline? _polyline;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _addMarker(LatLng position) {
    if (_markers.length < 2) {
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId(position.toString()),
          position: position,
        ));

        if (_markers.length == 2) {
          _createPolyline();
        }
      });
    }
  }

  void _createPolyline() {
    setState(() {
      _polyline = Polyline(
        polylineId: PolylineId('polyline'),
        points: _markers.map((marker) => marker.position).toList(),
        color: Colors.blue,
        width: 5,
      );
    });
  }

  void _clearMarkersAndPolyline() {
    setState(() {
      _markers.clear();
      _polyline = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polyline Map Example'),
        backgroundColor: Colors.teal,
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(37.77483, -122.41942),
              zoom: 12,
            ),
            markers: Set<Marker>.of(_markers),
            polylines: _polyline != null ? Set<Polyline>.of([_polyline!]) : Set<Polyline>(),
            onTap: _addMarker,
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              onPressed: _clearMarkersAndPolyline,
              backgroundColor: Colors.teal,
              child: Icon(Icons.clear),
            ),
          ),
        ],
      ),
    );
  }
}
