// import 'dart:async';
// import 'dart:io';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_cropper/image_cropper.dart';

// import '../models/base_response_model.dart';

// class FirebaseService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   String? _verificationId;
//   int? _resendToken;

//   double _uploadProgress = 0.0;

//   double get uploadProgress => _uploadProgress;

//   Future<void> initializeAnonymousUser() async {
//     try {
//       if (_auth.currentUser == null) {
//         await _auth.signInAnonymously();
//         print('Anonymous user created: ${_auth.currentUser?.uid}');
//       }
//     } catch (e) {
//       print('Error creating anonymous user: $e');
//     }
//   }

//   Future<String> upLoadImageFile({
//     required File mFileImage,
//     required String fileName,
//     Function(double progress)? onProgress,
//   }) async {

//     await initializeAnonymousUser();

//     final Reference storageReference = FirebaseStorage.instance.ref().child(
//         'profile');
//     // Create a reference to "mountains.jpg"
//     final imageRef = storageReference.child("$fileName.jpg");
    
//     // Reset progress
//     _uploadProgress = 0.0;
//     onProgress?.call(0.0);
    
//     // Upload file with progress tracking
//     final UploadTask uploadTask = imageRef.putFile(mFileImage);
    
//     // Listen to upload progress
//     uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//       _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
//       onProgress?.call(_uploadProgress);
//       print('Upload progress: ${(_uploadProgress * 100).toStringAsFixed(1)}%');
//     });
    
//     // Wait for upload to complete
//     await uploadTask;
    
//     // Get download URL
//     String url = await imageRef.getDownloadURL();
    
//     // Set progress to 100% when complete
//     _uploadProgress = 1.0;
//     onProgress?.call(1.0);
    
//     return url;
//   }

//   Future<BaseResponseModel> verifyPhoneNumber(String phoneNumber) async {
//     final completer = Completer<BaseResponseModel>();
//     try {
//       await _auth.verifyPhoneNumber(
//         phoneNumber: phoneNumber,
//         verificationCompleted: (phoneAuthCredential) {
//           completer.complete(
//             BaseResponseModel(
//               isSuccess: true,
//               message: phoneAuthCredential.toString(),
//             ),
//           );
//         },
//         verificationFailed: (authException) {
//           completer.complete(
//             BaseResponseModel(
//               isSuccess: false,
//               message: authException.toString(),
//             ),
//           );
//         },
//         codeSent: (verificationId, resendCode) {
//           _verificationId = verificationId;
//           _resendToken = resendCode;
//         },
//         codeAutoRetrievalTimeout: (verificationId) {
//           _verificationId = verificationId;
//           completer.complete(
//             BaseResponseModel(
//               isSuccess: true,
//               message: verificationId.toString(),
//             ),
//           );
//         },
//         forceResendingToken: _resendToken,
//       );

//       return await completer.future;
//     } on FirebaseAuthException catch (e) {
//       return BaseResponseModel(
//         isSuccess: false,
//         message: e.message ?? 'Unknown error',
//       );
//     } catch (e) {
//       return BaseResponseModel(
//         isSuccess: false,
//         message: 'Unexpected error: $e',
//       );
//     }
//   }

//   Future<BaseResponseModel> verifySmsCode(String smsCode) async {
//     try {
//       if (_verificationId == null) {
//         return BaseResponseModel(
//           isSuccess: false,
//           message: 'No verification in progress',
//         );
//       }

//       // Create a PhoneAuthCredential with the code
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//         verificationId: _verificationId!,
//         smsCode: smsCode,
//       );

//       // Sign in the user with the credential
//       UserCredential userCredential = await _auth.signInWithCredential(
//         credential,
//       );
//       return BaseResponseModel(
//         isSuccess: true,
//         message: userCredential.toString(),
//       );
//     } on FirebaseAuthException catch (e) {
//       return BaseResponseModel(
//         isSuccess: false,
//         message: 'Verification failed',
//       );
//     } catch (e) {
//       return BaseResponseModel(
//         isSuccess: false,
//         message: 'Unexpected error: $e',
//       );
//     }
//   }
// }
