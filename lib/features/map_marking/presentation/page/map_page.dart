import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safe_campus/features/map_marking/data/model/map_marker_model.dart';
import 'package:safe_campus/features/map_marking/presentation/bloc/map_bloc.dart';
import 'dart:developer' as developer;

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {
//   GoogleMapController? mapController;

//   // Real AASTU campus center (approx)
//   static const LatLng _aastuCenter = LatLng(
//     8.885295403306577,
//     38.80978489329565,
//   );

//   // Rough campus boundary
//   static final List<LatLng> _campusBoundary = [
//     LatLng(8.896353, 38.808),
//     LatLng(8.893893, 38.805257),
//     LatLng(8.891941, 38.802575),
//     LatLng(8.889925, 38.804035),
//     LatLng(8.884972, 38.806631),
//     LatLng(8.883940, 38.808110),
//     LatLng(8.884972, 38.806631),
//     LatLng(8.884972, 38.806631),
//     LatLng(8.881725149990693, 38.81110908333767),
//     LatLng(8.881636897161998, 38.81219124567429),
//     LatLng(8.881580725928576, 38.81415369924875),
//     LatLng(8.882807113439712, 38.81563452906126),
//     LatLng(8.883749594505105, 38.8149910349749),
//     LatLng(8.886994816428823, 38.81353523325033),
//     LatLng(8.891314185794098, 38.8111261724711),
//     LatLng(8.896214947044935, 38.808377579634865),
//   ];

//   BitmapDescriptor? activeIcon;
//   BitmapDescriptor? resolvedIcon;
//   BitmapDescriptor? investigationIcon;

//   @override
//   void initState() {
//     super.initState();
//     _loadMarkerIcons();
//     context.read<MapBloc>().add(MapLoadRequested());
//   }

//   Future<BitmapDescriptor> getResizedMarker(
//     String path,
//     int width,
//     int height,
//   ) async {
//     // Load image bytes
//     final byteData = await rootBundle.load(path);
//     final image = await decodeImageFromList(byteData.buffer.asUint8List());

//     // Resize image using canvas
//     final recorder = ui.PictureRecorder();
//     final canvas = Canvas(recorder);
//     final paint = Paint();
//     canvas.drawImageRect(
//       image,
//       Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
//       Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
//       paint,
//     );

//     final picture = recorder.endRecording();
//     final resizedImage = await picture.toImage(width, height);
//     final pngBytes = await resizedImage.toByteData(
//       format: ui.ImageByteFormat.png,
//     );

//     return BitmapDescriptor.fromBytes(pngBytes!.buffer.asUint8List());
//   }

//   Future<void> _loadMarkerIcons() async {
//     activeIcon = await getResizedMarker(
//       'assets/images/danger_active.png',
//       120,
//       120,
//     );
//     resolvedIcon = await getResizedMarker(
//       'assets/images/danger_resolved.png',
//       120,
//       120,
//     );
//     investigationIcon = await getResizedMarker(
//       'assets/images/danger_investigation.png',
//       80,
//       80,
//     );

//     setState(() {});
//   }

//   BitmapDescriptor getMarkerIcon(String status) {
    
//     switch (status.toLowerCase()) {
//       case 'active':
//         return activeIcon;
//       case 'resolved':
//         return resolvedIcon;
//       case 'under investigation':
//         return investigationIcon;
//       default:
//         return BitmapDescriptor.defaultMarker; // fallback
//     }
//   }

//   Marker dangerToMarker(MapMarkerModel danger) {
//     return Marker(
//       markerId: MarkerId(danger.id),
//       position: LatLng(danger.lat, danger.lng),
//       infoWindow: InfoWindow(
//         title: danger.types.isNotEmpty ? danger.types.first : "Danger",
//         snippet: "Status: ${danger.status}",
//       ),
//       icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//     );
//   }

//   BitmapDescriptor getMarkerColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'active':
//         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
//       case 'resolved':
//         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
//       case 'under investigation':
//         return BitmapDescriptor.defaultMarkerWithHue(
//           BitmapDescriptor.hueOrange,
//         );
//       default:
//         return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (activeIcon == null || resolvedIcon == null || investigationIcon == null) {
//     return const Center(child: CircularProgressIndicator());
//   }
//     return Scaffold(
//       backgroundColor: Color(0xFFF3F3F3),
//       appBar: AppBar(
//         backgroundColor: Color(0xFFF3F3F3),
//         title: const Text("AASTU Campus Map", style: TextStyle(fontWeight: FontWeight.bold),),
//       ),
//       body: BlocBuilder<MapBloc, MapState>(
//         builder: (context, state) {
//           if (state is MapLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is MapError) {
//             return Center(child: Text('Error: ${state.message}'));
//           } else if (state is MapLoaded) {
//             developer.log(
//               'Loaded dangerous areas: ${state.markers[0].lat}, ${state.markers[0].lng}',
//             );
//             return GoogleMap(
//               onMapCreated: (controller) => mapController = controller,
//               initialCameraPosition: const CameraPosition(
//                 target: _aastuCenter,
//                 zoom: 15, // good starting zoom for campus scale
//               ),
//               polygons: {
//                 Polygon(
//                   polygonId: const PolygonId('campus_boundary'),
//                   points: _campusBoundary,
//                   strokeColor: Colors.blue,
//                   strokeWidth: 3,
//                   fillColor: Colors.blue.withOpacity(0.15),
//                 ),
//               },
//               markers:
//                   state.markers
//                       .map(
//                         (danger) => Marker(
//                           markerId: MarkerId(danger.id),
//                           position: LatLng(danger.lat, danger.lng),
//                           infoWindow: InfoWindow(
//                             title:
//                                 danger.types.isNotEmpty
//                                     ? danger.types.first
//                                     : "Dangerous Area",
//                             snippet: "Status: ${danger.status}",
//                           ),
//                           icon: getMarkerIcon(danger.status),
//                         ),
//                       )
//                       .toSet(),
//               myLocationEnabled: false,
//               myLocationButtonEnabled: true,
//               zoomGesturesEnabled: true,
//             );
//           }
//           return Center(child: Text('Someting is happening...'));
//         },
//       ),
//       // floatingActionButton: FloatingActionButton(
//       //   onPressed: () {
//       //     // Use this for future actions if needed
//       //   },
//       //   child: const Icon(Icons.refresh),
//       // ),
//       // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }
// } //it closes by it self what may go wrong

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;

  static const LatLng _aastuCenter = LatLng(
    8.885295403306577,
    38.80978489329565,
  );

  static final List<LatLng> _campusBoundary = [
    LatLng(8.896353, 38.808),
    LatLng(8.893893, 38.805257),
    LatLng(8.891941, 38.802575),
    LatLng(8.889925, 38.804035),
    LatLng(8.884972, 38.806631),
    LatLng(8.883940, 38.808110),
    LatLng(8.884972, 38.806631),
    LatLng(8.884972, 38.806631),
    LatLng(8.881725149990693, 38.81110908333767),
    LatLng(8.881636897161998, 38.81219124567429),
    LatLng(8.881580725928576, 38.81415369924875),
    LatLng(8.882807113439712, 38.81563452906126),
    LatLng(8.883749594505105, 38.8149910349749),
    LatLng(8.886994816428823, 38.81353523325033),
    LatLng(8.891314185794098, 38.8111261724711),
    LatLng(8.896214947044935, 38.808377579634865),
  ];

  // BitmapDescriptor? activeIcon;
  // BitmapDescriptor? resolvedIcon;
  // BitmapDescriptor? investigationIcon;

  // @override
  // void initState() {
  //   super.initState();
  //   _loadMarkerIcons();
  //   context.read<MapBloc>().add(MapLoadRequested());
  // }

  BitmapDescriptor? activeIcon;
  BitmapDescriptor? resolvedIcon;
  BitmapDescriptor? investigationIcon;

  @override
  void initState() {
    super.initState();
    _loadIcons();
    context.read<MapBloc>().add(MapLoadRequested());
  }

  Future<void> _loadIcons() async {
    activeIcon = await createBitmapDescriptorFromIcon(Icons.report_problem_rounded,  Colors.red);
    resolvedIcon = await createBitmapDescriptorFromIcon(Icons.check_circle, Colors.green);
    investigationIcon = await createBitmapDescriptorFromIcon(Icons.help, Colors.orange);

    if (mounted) setState(() {});
  }


  Future<BitmapDescriptor> createBitmapDescriptorFromIcon(IconData iconData, Color color, {double size = 100}) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Draw the icon as text
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: size,
        fontFamily: iconData.fontFamily,
        color: color,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }



  Future<BitmapDescriptor> getResizedMarker(
    String path, int width, int height) async {
    final byteData = await rootBundle.load(path);
    final image = await decodeImageFromList(byteData.buffer.asUint8List());

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()),
      paint,
    );

    final picture = recorder.endRecording();
    final resizedImage = await picture.toImage(width, height);
    final pngBytes =
        await resizedImage.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(pngBytes!.buffer.asUint8List());
  }

  // Future<void> _loadMarkerIcons() async {
  //   activeIcon = await getResizedMarker('assets/images/danger_active.png', 120, 120);
  //   resolvedIcon =
  //       await getResizedMarker('assets/images/danger_resolved.png', 120, 120);
  //   investigationIcon =
  //       await getResizedMarker('assets/images/danger_investigation.png', 80, 80);

  //   // triggers rebuild with icons ready
  //   if (mounted) setState(() {});
  // }

  // BitmapDescriptor getMarkerIcon(String status) {
  //   if (activeIcon == null || resolvedIcon == null || investigationIcon == null) {
  //     // fallback if icons not ready yet
  //     return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
  //   }
  //   switch (status.toLowerCase()) {
  //     case 'active':
  //       return activeIcon!;
  //     case 'resolved':
  //       return resolvedIcon!;
  //     case 'under investigation':
  //       return investigationIcon!;
  //     default:
  //       return BitmapDescriptor.defaultMarker;
  //   }
  // }

//   BitmapDescriptor getMarkerIcon(String status) {
//   switch (status.toLowerCase()) {
//     case 'active':
//       return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
//     case 'resolved':
//       return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
//     case 'under investigation':
//       return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
//     default:
//       return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure);
//   }
// }


  Future<BitmapDescriptor> createIconFromWidget(IconData iconData, Color color) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final size = 100.0;

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: 100,
        fontFamily: iconData.fontFamily,
        color: color,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final picture = recorder.endRecording();
    final image = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  Marker dangerToMarker(MapMarkerModel danger) {
    return Marker(
      markerId: MarkerId(danger.id),
      position: LatLng(danger.lat, danger.lng),
      infoWindow: InfoWindow(
        title: danger.types.isNotEmpty ? danger.types.first : "Danger",
        snippet: "Status: ${danger.status}",
      ),
      icon: getMarkerIcon(danger.status), // uses the Material icon BitmapDescriptor
    );
  }

  BitmapDescriptor getMarkerIcon(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return activeIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'resolved':
        return resolvedIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'under investigation':
        return investigationIcon ?? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }



  @override
  Widget build(BuildContext context) {
    // Show loading spinner until icons are ready
    if (activeIcon == null || resolvedIcon == null || investigationIcon == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF3F3F3),
        title: const Text(
          "AASTU Campus Map",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state is MapLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MapError) {
            return Center(child: Text('Error: ${state.message}'));
          } else if (state is MapLoaded) {
            return GoogleMap(
              onMapCreated: (controller) => mapController = controller,
              initialCameraPosition: const CameraPosition(
                target: _aastuCenter,
                zoom: 15,
              ),
              polygons: {
                Polygon(
                  polygonId: const PolygonId('campus_boundary'),
                  points: _campusBoundary,
                  strokeColor: Colors.blue,
                  strokeWidth: 3,
                  fillColor: Colors.blue.withOpacity(0.15),
                ),
              },
              markers: state.markers
                .map(
                  (danger) => Marker(
                    markerId: MarkerId(danger.id),
                    position: LatLng(danger.lat, danger.lng),
                    infoWindow: InfoWindow(
                      title: danger.types.isNotEmpty ? danger.types.first : "Dangerous Area",
                      snippet: "Status: ${danger.status}",
                    ),
                    icon: getMarkerIcon(danger.status), // just uses color
                  ),
                )
                .toSet(),
              myLocationEnabled: false,
              myLocationButtonEnabled: true,
              zoomGesturesEnabled: true,
            );
          }
          return const Center(child: Text('Something is happening...'));
        },
      ),
    );
  }
}
