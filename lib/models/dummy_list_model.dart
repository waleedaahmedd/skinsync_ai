import '../utills/assets.dart';

class Treatments {
  final String svg;
  final String title;
  Treatments({required this.title, required this.svg});
}

final List<Treatments> treatments = [
  Treatments(title: "DERMAL FILLERS", svg: SvgAssets.treatment),
  Treatments(title: "BOTOX", svg: SvgAssets.treatment),
];

final List<Treatments> sections = [
  Treatments(title: "Upper Face", svg: PngAssets.splashLogo),
  Treatments(title: "Midface", svg: PngAssets.splashLogo),
  Treatments(title: "Lower Face", svg: PngAssets.splashLogo),
  Treatments(title: "Jawline", svg: PngAssets.splashLogo),
];

final List<Treatments> subSections = [
  Treatments(title: "Tear Trough", svg: SvgAssets.treatment),
  Treatments(title: "Cheeks/ Midface", svg: SvgAssets.treatment),
  Treatments(title: "Nasolabial Folds", svg: SvgAssets.treatment),
  Treatments(title: "Preauricular Area", svg: SvgAssets.treatment),
];
