class SignFormRequest {
  final int formId;
  final String url;

  SignFormRequest({
    required this.formId,
    required this.url,
  });

  Map<String, dynamic> toJson() => {
        "form_id": formId,
        "url": url,
      };
}
