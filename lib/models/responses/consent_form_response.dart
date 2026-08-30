import 'dart:convert';

import 'base_response_model.dart';

class ConsentFormResponse extends BaseResponseModel {
    final ConstentForm? data;
   

    ConsentFormResponse({
        this.data,
        super.isSuccess,
        super.message,
    });

    factory ConsentFormResponse.fromRawJson(String str) => ConsentFormResponse.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ConsentFormResponse.fromJson(Map<String, dynamic> json) => ConsentFormResponse(
        data: json["data"] == null ? null : ConstentForm.fromJson(json["data"]),
        isSuccess: json["is_success"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "is_success": isSuccess,
        "message": message,
    };
}

class ConstentForm {
    final List<Document>? signedDocuments;
    final List<Document>? unSignedDocuments;

    ConstentForm({
        this.signedDocuments,
        this.unSignedDocuments,
    });

    factory ConstentForm.fromRawJson(String str) => ConstentForm.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ConstentForm.fromJson(Map<String, dynamic> json) => ConstentForm(
        signedDocuments: json["signed_documents"] == null ? [] : List<Document>.from(json["signed_documents"]!.map((x) => Document.fromJson(x))),
        unSignedDocuments: json["un_signed_documents"] == null ? [] : List<Document>.from(json["un_signed_documents"]!.map((x) => Document.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "signed_documents": signedDocuments == null ? [] : List<dynamic>.from(signedDocuments!.map((x) => x.toJson())),
        "un_signed_documents": unSignedDocuments == null ? [] : List<dynamic>.from(unSignedDocuments!.map((x) => x.toJson())),
    };
}

class Document {
    final int? id;
    final String? title;
    final String? url;
    final String? type;
    final String? globalSku;
    final String? description;

    Document({
        this.id,
        this.title,
        this.url,
        this.type,
        this.globalSku,
        this.description,
    });

    factory Document.fromRawJson(String str) => Document.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Document.fromJson(Map<String, dynamic> json) => Document(
        id: json["id"],
        title: json["title"],
        url: json["url"],
        type: json["type"],
        globalSku: json["global_sku"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "url": url,
        "type": type,
        "global_sku": globalSku,
        "description": description,
    };
}
