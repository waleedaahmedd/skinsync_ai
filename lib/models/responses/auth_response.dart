import 'package:skinsync_ai/models/responses/base_response_model.dart';

class AuthResponse extends BaseResponseModel {
 
  AuthData? data;

  AuthResponse({super.isSuccess, super.message, this.data});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    isSuccess = json['is_success'];
    message = json['message'];
    data = json['data'] != null ? new AuthData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_success'] = this.isSuccess;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class AuthData {
  String? accessToken;
  String? refreshToken;
  int? accessExpiresAt;
  int? refreshExpiresAt;
  User? user;

  AuthData(
      {this.accessToken,
      this.refreshToken,
      this.accessExpiresAt,
      this.refreshExpiresAt,
      this.user});

  AuthData.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
    accessExpiresAt = json['access_expires_at'];
    refreshExpiresAt = json['refresh_expires_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['access_token'] = this.accessToken;
    data['refresh_token'] = this.refreshToken;
    data['access_expires_at'] = this.accessExpiresAt;
    data['refresh_expires_at'] = this.refreshExpiresAt;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? primaryEmail;
  String? primaryPhone;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? authProviders;
  String? authTokens;
  String? roles;

  User(
      {this.id,
      this.primaryEmail,
      this.primaryPhone,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.authProviders,
      this.authTokens,
      this.roles});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    primaryEmail = json['primary_email'];
    primaryPhone = json['primary_phone'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    authProviders = json['AuthProviders'];
    authTokens = json['AuthTokens'];
    roles = json['Roles'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['primary_email'] = this.primaryEmail;
    data['primary_phone'] = this.primaryPhone;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['AuthProviders'] = this.authProviders;
    data['AuthTokens'] = this.authTokens;
    data['Roles'] = this.roles;
    return data;
  }
}





// import 'base_response_model.dart';

// class AuthResponse extends BaseResponseModel {
//   AuthData? data;

//   AuthResponse({super.isSuccess, this.data, super.message});

//   AuthResponse.fromJson(Map<String, dynamic> json) {
//     isSuccess = json['isSuccess'];
//     data = json['data'] != null ? AuthData.fromJson(json['data']) : null;
//     message = json['message'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['isSuccess'] = isSuccess;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     data['message'] = message;
//     return data;
//   }
// }

// class AuthData {
//   String? sId;
//   int? createdOnDate;
//   String? fullName;
//   String? email;
//   String? phoneNumber;
//   bool? isVerified;
//   bool? isGuest;
//   String? refreshToken;
//   String? clientToken;
//   List<Discounts>? discounts;
//   List<Greetings>? greetings;

//   AuthData(
//       {this.sId,
//         this.createdOnDate,
//         this.fullName,
//         this.email,
//         this.phoneNumber,
//         this.isVerified,
//         this.isGuest,
//         this.refreshToken,
//         this.discounts,
//         this.clientToken,
//         this.greetings});

//   AuthData.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     createdOnDate = json['createdOnDate'];
//     fullName = json['fullName'];
//     email = json['email'];
//     phoneNumber = json['phoneNumber'];
//     isVerified = json['isVerified'];
//     isGuest = json['isGuest'];
//     refreshToken = json['refreshToken'];
//     clientToken = json['clientToken'];
//     if (json['discounts'] != null) {
//       discounts = <Discounts>[];
//       json['discounts'].forEach((v) {
//         discounts!.add(Discounts.fromJson(v));
//       });
//     }
//     if (json['greetings'] != null) {
//       greetings = <Greetings>[];
//       json['greetings'].forEach((v) {
//         greetings!.add(Greetings.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['createdOnDate'] = createdOnDate;
//     data['fullName'] = fullName;
//     data['email'] = email;
//     data['isGuest'] = isGuest;
//     data['phoneNumber'] = phoneNumber;
//     data['isVerified'] = isVerified;
//     data['refreshToken'] = refreshToken;
//     data['clientToken'] = clientToken;
//     if (discounts != null) {
//       data['discounts'] = discounts!.map((v) => v.toJson()).toList();
//     }
//     if (greetings != null) {
//       data['greetings'] = greetings!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class Discounts {
//   String? sId;
//   num? createdOnDate;
//   num? aggregate;
//   String? name;

//   Discounts({this.sId, this.createdOnDate, this.aggregate, this.name});

//   Discounts.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     createdOnDate = json['createdOnDate'];
//     aggregate = json['aggregate'];
//     name = json['name'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['createdOnDate'] = createdOnDate;
//     data['aggregate'] = aggregate;
//     data['name'] = name;
//     return data;
//   }
// }

// class Greetings {
//   String? sId;
//   int? createdOnDate;
//   String? title;
//   String? description;
//   String? type;
//   List<String>? media;
//   String? userId;
//   bool? isFeatured;
//   bool? isReplied;

//   Greetings(
//       {this.sId,
//         this.createdOnDate,
//         this.title,
//         this.description,
//         this.type,
//         this.media,
//         this.userId,
//         this.isFeatured,
//         this.isReplied});

//   Greetings.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     createdOnDate = json['createdOnDate'];
//     title = json['title'];
//     description = json['description'];
//     type = json['type'];
//     media = json['media'].cast<String>();
//     userId = json['userId'];
//     isFeatured = json['isFeatured'];
//     isReplied = json['isReplied'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['_id'] = sId;
//     data['createdOnDate'] = createdOnDate;
//     data['title'] = title;
//     data['description'] = description;
//     data['type'] = type;
//     data['media'] = media;
//     data['userId'] = userId;
//     data['isFeatured'] = isFeatured;
//     data['isReplied'] = isReplied;
//     return data;
//   }
// }
