// import 'dart:ui';

// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';

// import 'coordinates_translator.dart';

// class FaceMeshDetectorPainter extends CustomPainter {
//   FaceMeshDetectorPainter({
//     required this.meshes,
//     required this.imageSize,
//     required this.rotation,
//     required this.cameraLensDirection,
//   });

//   final List<FaceMesh> meshes;
//   final Size imageSize;
//   final InputImageRotation rotation;
//   final CameraLensDirection cameraLensDirection;

//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint1 = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.0
//       ..color = Colors.red;
//     final Paint paint2 = Paint()
//       ..style = PaintingStyle.fill
//       ..strokeWidth = 1.0
//       ..color = Colors.white;

//     for (final FaceMesh mesh in meshes) {
//       final left = translateX(
//         mesh.boundingBox.left,
//         size,
//         imageSize,
//         rotation,
//         cameraLensDirection,
//       );
//       final top = translateY(
//         mesh.boundingBox.top,
//         size,
//         imageSize,
//         rotation,
//         cameraLensDirection,
//       );
//       final right = translateX(
//         mesh.boundingBox.right,
//         size,
//         imageSize,
//         rotation,
//         cameraLensDirection,
//       );
//       final bottom = translateY(
//         mesh.boundingBox.bottom,
//         size,
//         imageSize,
//         rotation,
//         cameraLensDirection,
//       );

//       // canvas.drawRect(
//       //   Rect.fromLTRB(left, top, right, bottom),
//       //   paint1,
//       // );

//       void paintTriangle(FaceMeshTriangle triangle) {
//         final List<Offset> cornerPoints = <Offset>[];

//         for (final point in triangle.points) {
//           final double x = translateX(
//             point.x.toDouble(),
//             size,
//             imageSize,
//             rotation,
//             cameraLensDirection,
//           );
//           final double y = translateY(
//             point.y.toDouble(),
//             size,
//             imageSize,
//             rotation,
//             cameraLensDirection,
//           );

//           cornerPoints.add(Offset(x, y));
//         }
//         // Add the first point to close the polygon
//         cornerPoints.add(cornerPoints.first);
//         canvas.drawPoints(PointMode.polygon, cornerPoints, paint2);
//       }

//       for (int i = 0; i < mesh.triangles.length; i++) {
//         final triangle = mesh.triangles[i];
//         paintTriangle(triangle);
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(FaceMeshDetectorPainter oldDelegate) {
//     return oldDelegate.imageSize != imageSize || oldDelegate.meshes != meshes;
//   }
// }

// class FaceMeshContourPainter extends CustomPainter {
//   FaceMeshContourPainter({
//     required this.meshes,
//     required this.imageSize,
//     required this.rotation,
//     required this.cameraLensDirection,
//   });

//   final List<FaceMesh> meshes;
//   final Size imageSize;
//   final InputImageRotation rotation;
//   final CameraLensDirection cameraLensDirection;

//   @override
//   void paint(Canvas canvas, Size size) {
//     for (final mesh in meshes) {
//       mesh.contours.forEach((type, points) {
//         if (points == null || points.length < 2) return;

//         final paint = _paintForContour(type);
//         _drawContour(type, points, canvas, size, paint);
//       });
//     }
//   }

//   void _drawContour(
//     FaceMeshContourType type,
//     List<FaceMeshPoint> points,
//     Canvas canvas,
//     Size canvasSize,
//     Paint paint,
//   ) {
//     for (int i = 0; i < points.length - 1; i++) {
//       final p1 = points[i];
//       final p2 = points[i + 1];

//       final start = Offset(
//         translateX(
//           p1.x.toDouble(),
//           canvasSize,
//           imageSize,
//           rotation,
//           cameraLensDirection,
//         ),
//         translateY(
//           p1.y.toDouble(),
//           canvasSize,
//           imageSize,
//           rotation,
//           cameraLensDirection,
//         ),
//       );

//       final end = Offset(
//         translateX(
//           p2.x.toDouble(),
//           canvasSize,
//           imageSize,
//           rotation,
//           cameraLensDirection,
//         ),
//         translateY(
//           p2.y.toDouble(),
//           canvasSize,
//           imageSize,
//           rotation,
//           cameraLensDirection,
//         ),
//       );

//       canvas.drawLine(start, end, paint);
//     }

//     // Close closed contours
//     if (_isClosedContour(type)) {
//       final first = points.first;
//       final last = points.last;

//       final start = Offset(
//         translateX(
//           last.x.toDouble(),
//           canvasSize,
//           imageSize,
//           rotation,
//           cameraLensDirection,
//         ),
//         translateY(
//           last.y.toDouble(),
//           canvasSize,
//           imageSize,
//           rotation,
//           cameraLensDirection,
//         ),
//       );

//       final end = Offset(
//         translateX(
//           first.x.toDouble(),
//           canvasSize,
//           imageSize,
//           rotation,
//           cameraLensDirection,
//         ),
//         translateY(
//           first.y.toDouble(),
//           canvasSize,
//           imageSize,
//           rotation,
//           cameraLensDirection,
//         ),
//       );

//       canvas.drawLine(start, end, paint);
//     }
//   }

//   Paint _paintForContour(FaceMeshContourType type) {
//     switch (type) {
//       case FaceMeshContourType.faceOval:
//         return Paint()
//           ..color = Colors.green
//           ..strokeWidth = 2.0
//           ..style = PaintingStyle.stroke;

//       case FaceMeshContourType.leftEye:
//       case FaceMeshContourType.rightEye:
//         return Paint()
//           ..color = Colors.blue
//           ..strokeWidth = 1.5
//           ..style = PaintingStyle.stroke;

//       case FaceMeshContourType.leftEyebrowTop:
//       case FaceMeshContourType.leftEyebrowBottom:
//       case FaceMeshContourType.rightEyebrowTop:
//       case FaceMeshContourType.rightEyebrowBottom:
//         return Paint()
//           ..color = Colors.orange
//           ..strokeWidth = 1.5
//           ..style = PaintingStyle.stroke;

//       case FaceMeshContourType.upperLipTop:
//       case FaceMeshContourType.upperLipBottom:
//       case FaceMeshContourType.lowerLipTop:
//       case FaceMeshContourType.lowerLipBottom:
//         return Paint()
//           ..color = Colors.red
//           ..strokeWidth = 1.5
//           ..style = PaintingStyle.stroke;

//       case FaceMeshContourType.noseBridge:
//         return Paint()
//           ..color = Colors.purple
//           ..strokeWidth = 1.5
//           ..style = PaintingStyle.stroke;

//       default:
//         return Paint()
//           ..color = Colors.white
//           ..strokeWidth = 1.0
//           ..style = PaintingStyle.stroke;
//     }
//   }

//   bool _isClosedContour(FaceMeshContourType type) {
//     return type == FaceMeshContourType.faceOval ||
//         type == FaceMeshContourType.leftEye ||
//         type == FaceMeshContourType.rightEye ||
//         type == FaceMeshContourType.upperLipTop ||
//         type == FaceMeshContourType.upperLipBottom ||
//         type == FaceMeshContourType.lowerLipTop ||
//         type == FaceMeshContourType.lowerLipBottom;
//   }

//   @override
//   bool shouldRepaint(covariant FaceMeshContourPainter oldDelegate) {
//     return oldDelegate.meshes != meshes || oldDelegate.imageSize != imageSize;
//   }
// }
