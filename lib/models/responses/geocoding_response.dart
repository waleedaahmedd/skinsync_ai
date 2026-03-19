class GeocodingResponse {
  final PlusCode? plusCode;
  final List<Result>? results;
  final String? status;

  GeocodingResponse({this.plusCode, this.results, this.status});

  factory GeocodingResponse.fromJson(Map<String, dynamic> json) =>
      GeocodingResponse(
        plusCode: json["plus_code"] == null
            ? null
            : PlusCode.fromJson(json["plus_code"]),
        results: json["results"] == null
            ? []
            : List<Result>.from(
                json["results"]!.map((x) => Result.fromJson(x)),
              ),
        status: json["status"],
      );
}

class PlusCode {
  final String? compoundCode;
  final String? globalCode;

  PlusCode({this.compoundCode, this.globalCode});

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
    compoundCode: json["compound_code"],
    globalCode: json["global_code"],
  );
}

class Result {
  final List<AddressComponent>? addressComponents;
  final String? formattedAddress;
  final String? placeId;
  final List<String>? types;
  final PlusCode? plusCode;

  Result({
    this.addressComponents,
    this.formattedAddress,
    this.placeId,
    this.types,
    this.plusCode,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    addressComponents: json["address_components"] == null
        ? []
        : List<AddressComponent>.from(
            json["address_components"]!.map(
              (x) => AddressComponent.fromJson(x),
            ),
          ),
    formattedAddress: json["formatted_address"],
    placeId: json["place_id"],
    types: json["types"] == null
        ? []
        : List<String>.from(json["types"]!.map((x) => x)),
    plusCode: json["plus_code"] == null
        ? null
        : PlusCode.fromJson(json["plus_code"]),
  );
}

class AddressComponent {
  final String? longName;
  final String? shortName;
  final List<String>? types;

  AddressComponent({this.longName, this.shortName, this.types});

  factory AddressComponent.fromJson(Map<String, dynamic> json) =>
      AddressComponent(
        longName: json["long_name"],
        shortName: json["short_name"],
        types: json["types"] == null
            ? []
            : List<String>.from(json["types"]!.map((x) => x)),
      );
}
