class CreateGroupRequest {
  final String name;

  CreateGroupRequest({required this.name});

  Map<String, dynamic> toJson() => {
        "name": name,
      };
}
