class SignFormRequest {
  final String title;
  final String url;
  final String type;
  final String globalSku;

  SignFormRequest({
    required this.title,
    required this.url,
    required this.type,
    required this.globalSku,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "url": url,
        "type": type,
        "global_sku": globalSku,
      };
}
