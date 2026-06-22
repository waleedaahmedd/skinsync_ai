import 'package:intl/intl.dart';

import 'geocoding_response.dart';

class MapClinicsResponse {
  final List<Place>? places;

  MapClinicsResponse({this.places});

  factory MapClinicsResponse.fromJson(Map<String, dynamic> json) =>
      MapClinicsResponse(
        places: json["places"] == null
            ? null
            : List<Place>.from(json["places"].map((x) => Place.fromJson(x))),
      );
}

class Photo {
  final String? name;
  final int? widthPx;
  final int? heightPx;
  final String? flagContentUri;
  final String? googleMapsUri;

  Photo({
    this.name,
    this.widthPx,
    this.heightPx,
    this.flagContentUri,
    this.googleMapsUri,
  });

  factory Photo.fromJson(Map<String, dynamic> json) => Photo(
    name:
        'https://places.googleapis.com/v1/${json['name']}/media?max_height_px=${json['heightPx']}&key=AIzaSyDCkkGnM5MsciCvDYI7A_70Px-UiM3Ir8Q',
    widthPx: json["widthPx"],
    heightPx: json["heightPx"],
    flagContentUri: json["flagContentUri"],
    googleMapsUri: json["googleMapsUri"],
  );
}

class Place {
  final String? name;
  final String? id;
  final List<String>? types;
  final String? nationalPhoneNumber;
  final String? internationalPhoneNumber;
  final String? formattedAddress;
  final List<AddressComponent>? addressComponents;
  final PlusCode? plusCode;
  final Location? location;
  final Viewport? viewport;
  final double? rating;
  final String? googleMapsUri;
  final OpeningHours? regularOpeningHours;
  final int? utcOffsetMinutes;
  final String? adrFormatAddress;
  final String? businessStatus;
  final int? userRatingCount;
  final String? iconMaskBaseUri;
  final String? iconBackgroundColor;
  final DisplayName? displayName;
  final DisplayName? primaryTypeDisplayName;
  final OpeningHours? currentOpeningHours;
  final String? primaryType;
  final String? shortFormattedAddress;
  final List<Review>? reviews;
  final List<Photo>? photos;
  final AddressDescriptor? addressDescriptor;
  final GoogleMapsLinks? googleMapsLinks;
  final TimeZone? timeZone;
  final PostalAddress? postalAddress;
  final DisplayName? googleMapsTypeLabel;
  final String? websiteUri;
  final bool? goodForChildren;
  final bool? restroom;
  final PaymentOptions? paymentOptions;
  final ParkingOptions? parkingOptions;
  final List<ContainingPlace>? containingPlaces;
  final List<CurrentSecondaryOpeningHour>? currentSecondaryOpeningHours;
  final List<RegularSecondaryOpeningHour>? regularSecondaryOpeningHours;

  Place({
    this.name,
    this.id,
    this.types,
    this.nationalPhoneNumber,
    this.internationalPhoneNumber,
    this.formattedAddress,
    this.addressComponents,
    this.plusCode,
    this.location,
    this.viewport,
    this.rating,
    this.googleMapsUri,
    this.regularOpeningHours,
    this.utcOffsetMinutes,
    this.adrFormatAddress,
    this.businessStatus,
    this.userRatingCount,
    this.iconMaskBaseUri,
    this.iconBackgroundColor,
    this.displayName,
    this.primaryTypeDisplayName,
    this.currentOpeningHours,
    this.primaryType,
    this.shortFormattedAddress,
    this.reviews,
    this.photos,
    this.addressDescriptor,
    this.googleMapsLinks,
    this.timeZone,
    this.postalAddress,
    this.googleMapsTypeLabel,
    this.websiteUri,
    this.goodForChildren,
    this.restroom,
    this.paymentOptions,
    this.parkingOptions,
    this.containingPlaces,
    this.currentSecondaryOpeningHours,
    this.regularSecondaryOpeningHours,
  });

  factory Place.fromJson(Map<String, dynamic> json) => Place(
    name: json["name"],
    id: json["id"],
    types: json["types"] == null
        ? null
        : List<String>.from(json["types"].map((x) => x)),
    nationalPhoneNumber: json["nationalPhoneNumber"],
    internationalPhoneNumber: json["internationalPhoneNumber"],
    formattedAddress: json["formattedAddress"],
    addressComponents: json["addressComponents"] == null
        ? null
        : List<AddressComponent>.from(
            json["addressComponents"].map((x) => AddressComponent.fromJson(x)),
          ),
    plusCode: json["plusCode"] == null
        ? null
        : PlusCode.fromJson(json["plusCode"]),
    location: json["location"] == null
        ? null
        : Location.fromJson(json["location"]),
    viewport: json["viewport"] == null
        ? null
        : Viewport.fromJson(json["viewport"]),
    rating: json["rating"]?.toDouble(),
    googleMapsUri: json["googleMapsUri"],
    regularOpeningHours: json["regularOpeningHours"] == null
        ? null
        : OpeningHours.fromJson(json["regularOpeningHours"]),
    utcOffsetMinutes: json["utcOffsetMinutes"],
    adrFormatAddress: json["adrFormatAddress"],
    businessStatus: json["businessStatus"],
    userRatingCount: json["userRatingCount"],
    iconMaskBaseUri: json["iconMaskBaseUri"],
    iconBackgroundColor: json["iconBackgroundColor"],
    displayName: json["displayName"] == null
        ? null
        : DisplayName.fromJson(json["displayName"]),
    primaryTypeDisplayName: json["primaryTypeDisplayName"] == null
        ? null
        : DisplayName.fromJson(json["primaryTypeDisplayName"]),
    currentOpeningHours: json["currentOpeningHours"] == null
        ? null
        : OpeningHours.fromJson(json["currentOpeningHours"]),
    primaryType: json["primaryType"],
    shortFormattedAddress: json["shortFormattedAddress"],
    reviews: json["reviews"] == null
        ? null
        : List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
    photos: json["photos"] == null
        ? null
        : List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
    addressDescriptor: json["addressDescriptor"] == null
        ? null
        : AddressDescriptor.fromJson(json["addressDescriptor"]),
    googleMapsLinks: json["googleMapsLinks"] == null
        ? null
        : GoogleMapsLinks.fromJson(json["googleMapsLinks"]),
    timeZone: json["timeZone"] == null
        ? null
        : TimeZone.fromJson(json["timeZone"]),
    postalAddress: json["postalAddress"] == null
        ? null
        : PostalAddress.fromJson(json["postalAddress"]),
    googleMapsTypeLabel: json["googleMapsTypeLabel"] == null
        ? null
        : DisplayName.fromJson(json["googleMapsTypeLabel"]),
    websiteUri: json["websiteUri"],
    goodForChildren: json["goodForChildren"],
    restroom: json["restroom"],
    paymentOptions: json["paymentOptions"] == null
        ? null
        : PaymentOptions.fromJson(json["paymentOptions"]),
    parkingOptions: json["parkingOptions"] == null
        ? null
        : ParkingOptions.fromJson(json["parkingOptions"]),
    containingPlaces: json["containingPlaces"] == null
        ? null
        : List<ContainingPlace>.from(
            json["containingPlaces"].map((x) => ContainingPlace.fromJson(x)),
          ),
    currentSecondaryOpeningHours: json["currentSecondaryOpeningHours"] == null
        ? null
        : List<CurrentSecondaryOpeningHour>.from(
            json["currentSecondaryOpeningHours"].map(
              (x) => CurrentSecondaryOpeningHour.fromJson(x),
            ),
          ),
    regularSecondaryOpeningHours: json["regularSecondaryOpeningHours"] == null
        ? null
        : List<RegularSecondaryOpeningHour>.from(
            json["regularSecondaryOpeningHours"].map(
              (x) => RegularSecondaryOpeningHour.fromJson(x),
            ),
          ),
  );
}

class AddressDescriptor {
  final List<Landmark>? landmarks;
  final List<Area>? areas;

  AddressDescriptor({this.landmarks, this.areas});

  factory AddressDescriptor.fromJson(Map<String, dynamic> json) =>
      AddressDescriptor(
        landmarks: json["landmarks"] == null
            ? null
            : List<Landmark>.from(
                json["landmarks"].map((x) => Landmark.fromJson(x)),
              ),
        areas: json["areas"] == null
            ? null
            : List<Area>.from(json["areas"].map((x) => Area.fromJson(x))),
      );
}

class Area {
  final String? name;
  final String? placeId;
  final DisplayName? displayName;
  final String? containment;

  Area({this.name, this.placeId, this.displayName, this.containment});

  factory Area.fromJson(Map<String, dynamic> json) => Area(
    name: json["name"],
    placeId: json["placeId"],
    displayName: json["displayName"] == null
        ? null
        : DisplayName.fromJson(json["displayName"]),
    containment: json["containment"],
  );
}

class DisplayName {
  final String? text;
  final String? languageCode;

  DisplayName({this.text, this.languageCode});

  factory DisplayName.fromJson(Map<String, dynamic> json) =>
      DisplayName(text: json["text"], languageCode: json["languageCode"]);
}

class Landmark {
  final String? name;
  final String? placeId;
  final DisplayName? displayName;
  final List<String>? types;
  final double? straightLineDistanceMeters;
  final double? travelDistanceMeters;
  final String? spatialRelationship;

  Landmark({
    this.name,
    this.placeId,
    this.displayName,
    this.types,
    this.straightLineDistanceMeters,
    this.travelDistanceMeters,
    this.spatialRelationship,
  });

  factory Landmark.fromJson(Map<String, dynamic> json) => Landmark(
    name: json["name"],
    placeId: json["placeId"],
    displayName: json["displayName"] == null
        ? null
        : DisplayName.fromJson(json["displayName"]),
    types: json["types"] == null
        ? null
        : List<String>.from(json["types"].map((x) => x)),
    straightLineDistanceMeters: json["straightLineDistanceMeters"]?.toDouble(),
    travelDistanceMeters: json["travelDistanceMeters"]?.toDouble(),
    spatialRelationship: json["spatialRelationship"],
  );
}

class ContainingPlace {
  final String? name;
  final String? id;

  ContainingPlace({this.name, this.id});

  factory ContainingPlace.fromJson(Map<String, dynamic> json) =>
      ContainingPlace(name: json["name"], id: json["id"]);
}

class OpeningHours {
  final bool? openNow;
  final List<CurrentOpeningHoursPeriod>? periods;
  final List<String>? weekdayDescriptions;
  final DateTime? nextCloseTime;

  OpeningHours({
    this.openNow,
    this.periods,
    this.weekdayDescriptions,
    this.nextCloseTime,
  });

  factory OpeningHours.fromJson(Map<String, dynamic> json) => OpeningHours(
    openNow: json["openNow"],
    periods: json["periods"] == null
        ? null
        : List<CurrentOpeningHoursPeriod>.from(
            json["periods"].map((x) => CurrentOpeningHoursPeriod.fromJson(x)),
          ),
    weekdayDescriptions: json["weekdayDescriptions"] == null
        ? null
        : List<String>.from(json["weekdayDescriptions"].map((x) => x)),
    nextCloseTime: json["nextCloseTime"] == null
        ? null
        : DateTime.parse(json["nextCloseTime"]),
  );

  static final DateFormat _format = DateFormat('hh:mm a');

  String get todayOpeningHours {
    final today = DateTime.now().weekday;
    for (final day in periods ?? <CurrentOpeningHoursPeriod>[]) {
      if (today == day.open?.day) {
        if (day.open != null && day.close != null) {
          final openTime = _convertToFormattedTime(
            day.open!.hour,
            day.open!.minute,
          );
          final closeTime = _convertToFormattedTime(
            day.close!.hour,
            day.close!.minute,
          );
          return '$openTime - $closeTime';
        }
      }
    }
    return 'Closed now';
  }

  String _convertToFormattedTime(int? hours, int? minutes) {
    if (hours == null || minutes == null) {
      return 'Closed now';
    }
    final dateTime = DateTime(0, 0, 0, hours, minutes);
    return _format.format(dateTime);
  }
}

class CurrentOpeningHoursPeriod {
  final Close? open;
  final Close? close;

  CurrentOpeningHoursPeriod({this.open, this.close});

  factory CurrentOpeningHoursPeriod.fromJson(Map<String, dynamic> json) =>
      CurrentOpeningHoursPeriod(
        open: json["open"] == null ? null : Close.fromJson(json["open"]),
        close: json["close"] == null ? null : Close.fromJson(json["close"]),
      );
}

class Close {
  final int? day;
  final int? hour;
  final int? minute;
  final Date? date;
  final bool? truncated;

  Close({this.day, this.hour, this.minute, this.date, this.truncated});

  factory Close.fromJson(Map<String, dynamic> json) => Close(
    day: json["day"],
    hour: json["hour"],
    minute: json["minute"],
    date: json["date"] == null ? null : Date.fromJson(json["date"]),
    truncated: json["truncated"],
  );
}

class Date {
  final int? year;
  final int? month;
  final int? day;

  Date({this.year, this.month, this.day});

  factory Date.fromJson(Map<String, dynamic> json) =>
      Date(year: json["year"], month: json["month"], day: json["day"]);
}

class CurrentSecondaryOpeningHour {
  final bool? openNow;
  final List<CurrentOpeningHoursPeriod>? periods;
  final List<String>? weekdayDescriptions;
  final String? secondaryHoursType;

  CurrentSecondaryOpeningHour({
    this.openNow,
    this.periods,
    this.weekdayDescriptions,
    this.secondaryHoursType,
  });

  factory CurrentSecondaryOpeningHour.fromJson(Map<String, dynamic> json) =>
      CurrentSecondaryOpeningHour(
        openNow: json["openNow"],
        periods: json["periods"] == null
            ? null
            : List<CurrentOpeningHoursPeriod>.from(
                json["periods"].map(
                  (x) => CurrentOpeningHoursPeriod.fromJson(x),
                ),
              ),
        weekdayDescriptions: json["weekdayDescriptions"] == null
            ? null
            : List<String>.from(json["weekdayDescriptions"].map((x) => x)),
        secondaryHoursType: json["secondaryHoursType"],
      );
}

class GoogleMapsLinks {
  final String? directionsUri;
  final String? placeUri;
  final String? writeAReviewUri;
  final String? reviewsUri;
  final String? photosUri;

  GoogleMapsLinks({
    this.directionsUri,
    this.placeUri,
    this.writeAReviewUri,
    this.reviewsUri,
    this.photosUri,
  });

  factory GoogleMapsLinks.fromJson(Map<String, dynamic> json) =>
      GoogleMapsLinks(
        directionsUri: json["directionsUri"],
        placeUri: json["placeUri"],
        writeAReviewUri: json["writeAReviewUri"],
        reviewsUri: json["reviewsUri"],
        photosUri: json["photosUri"],
      );
}

class Location {
  final double? latitude;
  final double? longitude;

  Location({this.latitude, this.longitude});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );
}

class ParkingOptions {
  final bool? freeParkingLot;
  final bool? freeStreetParking;
  final bool? valetParking;
  final bool? paidParkingLot;
  final bool? paidStreetParking;
  final bool? freeGarageParking;
  final bool? paidGarageParking;

  ParkingOptions({
    this.freeParkingLot,
    this.freeStreetParking,
    this.valetParking,
    this.paidParkingLot,
    this.paidStreetParking,
    this.freeGarageParking,
    this.paidGarageParking,
  });

  factory ParkingOptions.fromJson(Map<String, dynamic> json) => ParkingOptions(
    freeParkingLot: json["freeParkingLot"],
    freeStreetParking: json["freeStreetParking"],
    valetParking: json["valetParking"],
    paidParkingLot: json["paidParkingLot"],
    paidStreetParking: json["paidStreetParking"],
    freeGarageParking: json["freeGarageParking"],
    paidGarageParking: json["paidGarageParking"],
  );
}

class PaymentOptions {
  final bool? acceptsCreditCards;
  final bool? acceptsDebitCards;
  final bool? acceptsCashOnly;
  final bool? acceptsNfc;

  PaymentOptions({
    this.acceptsCreditCards,
    this.acceptsDebitCards,
    this.acceptsCashOnly,
    this.acceptsNfc,
  });

  factory PaymentOptions.fromJson(Map<String, dynamic> json) => PaymentOptions(
    acceptsCreditCards: json["acceptsCreditCards"],
    acceptsDebitCards: json["acceptsDebitCards"],
    acceptsCashOnly: json["acceptsCashOnly"],
    acceptsNfc: json["acceptsNfc"],
  );
}

class PlusCode {
  final String? globalCode;
  final String? compoundCode;

  PlusCode({this.globalCode, this.compoundCode});

  factory PlusCode.fromJson(Map<String, dynamic> json) => PlusCode(
    globalCode: json["globalCode"],
    compoundCode: json["compoundCode"],
  );
}

class PostalAddress {
  final String? regionCode;
  final String? languageCode;
  final String? locality;
  final List<String>? addressLines;
  final String? postalCode;

  PostalAddress({
    this.regionCode,
    this.languageCode,
    this.locality,
    this.addressLines,
    this.postalCode,
  });

  factory PostalAddress.fromJson(Map<String, dynamic> json) => PostalAddress(
    regionCode: json["regionCode"],
    languageCode: json["languageCode"],
    locality: json["locality"],
    addressLines: json["addressLines"] == null
        ? null
        : List<String>.from(json["addressLines"].map((x) => x)),
    postalCode: json["postalCode"],
  );
}

class RegularSecondaryOpeningHour {
  final bool? openNow;
  final List<RegularSecondaryOpeningHourPeriod>? periods;
  final List<String>? weekdayDescriptions;
  final String? secondaryHoursType;

  RegularSecondaryOpeningHour({
    this.openNow,
    this.periods,
    this.weekdayDescriptions,
    this.secondaryHoursType,
  });

  factory RegularSecondaryOpeningHour.fromJson(Map<String, dynamic> json) =>
      RegularSecondaryOpeningHour(
        openNow: json["openNow"],
        periods: json["periods"] == null
            ? null
            : List<RegularSecondaryOpeningHourPeriod>.from(
                json["periods"].map(
                  (x) => RegularSecondaryOpeningHourPeriod.fromJson(x),
                ),
              ),
        weekdayDescriptions: json["weekdayDescriptions"] == null
            ? null
            : List<String>.from(json["weekdayDescriptions"].map((x) => x)),
        secondaryHoursType: json["secondaryHoursType"],
      );
}

class RegularSecondaryOpeningHourPeriod {
  final Close? open;

  RegularSecondaryOpeningHourPeriod({this.open});

  factory RegularSecondaryOpeningHourPeriod.fromJson(
    Map<String, dynamic> json,
  ) => RegularSecondaryOpeningHourPeriod(
    open: json["open"] == null ? null : Close.fromJson(json["open"]),
  );
}

class Review {
  final String? name;
  final String? relativePublishTimeDescription;
  final int? rating;
  final DisplayName? text;
  final DisplayName? originalText;
  final DateTime? publishTime;
  final String? flagContentUri;
  final String? googleMapsUri;

  Review({
    this.name,
    this.relativePublishTimeDescription,
    this.rating,
    this.text,
    this.originalText,
    this.publishTime,
    this.flagContentUri,
    this.googleMapsUri,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    name: json["name"],
    relativePublishTimeDescription: json["relativePublishTimeDescription"],
    rating: json["rating"],
    text: json["text"] == null ? null : DisplayName.fromJson(json["text"]),
    originalText: json["originalText"] == null
        ? null
        : DisplayName.fromJson(json["originalText"]),
    publishTime: json["publishTime"] == null
        ? null
        : DateTime.parse(json["publishTime"]),
    flagContentUri: json["flagContentUri"],
    googleMapsUri: json["googleMapsUri"],
  );
}

class TimeZone {
  final String? id;

  TimeZone({this.id});

  factory TimeZone.fromJson(Map<String, dynamic> json) =>
      TimeZone(id: json["id"]);
}

class Viewport {
  final Location? low;
  final Location? high;

  Viewport({this.low, this.high});

  factory Viewport.fromJson(Map<String, dynamic> json) => Viewport(
    low: json["low"] == null ? null : Location.fromJson(json["low"]),
    high: json["high"] == null ? null : Location.fromJson(json["high"]),
  );
}
