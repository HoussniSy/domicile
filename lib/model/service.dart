class Service {
  late List<String> images;
  List<String> like;
  List<String> dislike;
  List<String> favories;
  late String nom;
  late String slogan;
  late String prix;
  late String detailSup;
  late String uid;
  late String tel;
  late String statut;
  String id;

  Service(
  {required this.detailSup,
    required this.images,
    required this.nom,
    required this.slogan,
    required this.prix,
    required this.id,
    required uid,
    required tel,
    required statut,
    required this.dislike,
    required this.like,
    required this.favories
    });

  factory Service.fromJson(Map<String, dynamic> map, {required String id}) => Service(
      id: id,
      nom: map["nom"],
      slogan: map["slogan"],
      prix: map["prix"],
      detailSup: map["detailSup"],
      statut: map["statut"],
      uid: map["uid"],
      tel: map["tel"],
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
      "slogan": slogan,
      "detailSup": detailSup,
      "prix": prix,
      "uid": uid,
      "tel": tel,
      "statut":statut,
      "like": like,
      "dislike": dislike,
      "favories": favories
    };
  }
}