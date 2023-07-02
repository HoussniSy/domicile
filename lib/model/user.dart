class UserM{
  String id, emailController, pseudo,image;
  bool admin, enable;
  static UserM? currentUser;
  UserM(
      {required this.id,
        required this.pseudo,
        required this.emailController,
        required this.image,
        this.admin = false,
        this.enable = true
  });
  factory UserM.fromJson(Map<String, dynamic> j) => UserM(
          emailController: j['email'],
          id: j['id'],
          pseudo: j['pseudo'],
          image: j['image'],
          admin: j['admin'],
          enable: j["enable"]
      );
  Map<String, dynamic> toMap() => {
    "id":id,
    "email":emailController,
    "pseudo":pseudo,
    "image":image,
    "admin": admin,
    "enable": enable
  };
}