class Fourni {
  late List<String> images;
  List<String> like;
  List<String> dislike;
  List<String> favories;
  late String nom;
  late String adresse;
  late String code;
  late String tel;
  late String competence;
  late String experience;
  late String uid;
  String id;

  Fourni({
    required this.competence,
    required this.experience,
    required this.images,
    required this.nom,
    required this.adresse,
    required this.code,
    required this.tel,
    required this.id,
    required uid,
    required this.dislike,
    required this.like,
    required this.favories
});

  factory Fourni.fromJson(Map<String, dynamic> map, {required String id}) => Fourni(
      id: id,
      nom: map["nom"],
      adresse: map["adresse"],
      code: map["code"],
      tel: map["tel"],
      competence: map["competence"],
      experience: map["experience"],
      uid: map["uid"],
      images: map["images"].map<String>((i) => i as String).toList(),
      like: map["like"] == null
          ? []
          : map["like"].map<String>((i) => i as String).toList(),
      favories: map["favories"] == null
          ? []
          : map["favories"].map<String>((i) => i as String).toList(),
      dislike: map["dislike"] == null
          ? []
          : map["dislike"].map<String>((i) => i as String).toList(),
  );


  Map<String, dynamic> toMap() {
    return {
      "images": images,
      "nom": nom,
      "adresse": adresse,
      "competence": competence,
      "experience": experience,
      "code": code,
      "tel": tel,
      "uid": uid,
      "like": like,
      "dislike": dislike,
      "favories": favories
    };
  }
}
