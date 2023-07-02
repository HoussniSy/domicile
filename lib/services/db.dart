import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domicile/model/comment.dart';
import 'package:domicile/model/fournisseur.dart';
import 'package:domicile/model/service.dart';
import 'package:domicile/model/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart' as p;

import 'package:firebase_auth/firebase_auth.dart';


class DBServices {
  final CollectionReference usercol =
      FirebaseFirestore.instance.collection("users");

  final CollectionReference carouselcol =
      FirebaseFirestore.instance.collection("carousel");

  final CollectionReference thumbnailcol =
      FirebaseFirestore.instance.collection("thumbnail");

  final CollectionReference servicecol =
      FirebaseFirestore.instance.collection("services");

  final CollectionReference fournicol =
      FirebaseFirestore.instance.collection("Fournisseur");

  final CollectionReference commentcol =
      FirebaseFirestore.instance.collection("commentaires");


  Future saveUser(UserM user) async{
    try{
      await usercol.doc(user.id).set(user.toMap());
      return true;
    }catch (e) {
      return false;
    }
  }

  Future getUser(String id) async{
    try{
      final data = await usercol.doc(id).get();
      final user = data.data();
      return user;
    } catch (e) {
      return false;
    }
  }

  Future updateUser(UserM user) async {
    try {
      await usercol.doc(user.id).update(user.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<UserM> get getCurrentUser {
    final user = FirebaseAuth.instance.currentUser;
    return user != null
        ? usercol.doc(user.uid).snapshots().map((user) {
      UserM.currentUser = UserM.fromJson(user.data() as Map<String, dynamic>);
      return UserM.fromJson(user.data() as Map<String, dynamic>);
    })
        : Stream<UserM>.empty();
  }

  Future<String?> uploadImage(File file, {required String path}) async {
    var time = DateTime.now().toString();
    var ext = p.basename(file.path).split(".")[1].toString();
    String image = path + "_" + time + "." + ext;
    try {
      final ref =FirebaseStorage.instance.ref().child(path + "/" + image);
      UploadTask upload = ref.putFile(file);
      await upload.whenComplete(() {});
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<List?> get getCarouselImage async {
    try {
      final data = await thumbnailcol.doc("w0s2N3SH4ZVCh9sFCPJB").get();
      return data.get('tmps') ?? '';
    } catch (e) {
      return null;
    }
  }

  Future saveservice(Service service) async {
    try{
      await servicecol.doc().set(service.toMap());
      return true;
    }catch (e) {
      return false;
    }
  }

  Future savefourni(Fourni fourni) async {
    try{
      await fournicol.doc().set(fourni.toMap());
      return true;
    }catch (e) {
      return false;
    }
  }

  Future updateservice(Service service) async {
    try {
      await servicecol.doc(service.id).update(service.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future deleteservice(String id) async {
    try {
      await servicecol.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future updatefourni(Fourni fourni) async {
    try {
      await fournicol.doc(fourni.id).update(fourni.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }

  Future deletefourni(String id) async {
    try {
      await fournicol.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<Service>> get getservice {
    return servicecol.snapshots().map((service) {
      return service.docs
          .map((e) => Service.fromJson(e.data() as Map<String, dynamic>, id: e.id))
          .toList();
    });
  }

  Stream<List<Fourni>> get getprovider {
    return fournicol.snapshots().map((QuerySnapshot snapshot) {
      return snapshot.docs
          .map((DocumentSnapshot doc) => Fourni.fromJson(doc.data() as Map<String, dynamic>, id: doc.id))
          .toList();
    });
  }


  Stream<List<Service>> getservicefav() {
    final user = FirebaseAuth.instance.currentUser;
    return servicecol
        .where("favories", arrayContains: user?.uid)
        .snapshots()
        .map((service) {
      return service.docs
          .map((e) => Service.fromJson(e.data() as Map<String, dynamic>, id: e.id))
          .toList();
    });
  }

  Stream<List<UserM>> get getAllUsers {
    return usercol.snapshots().map((users) {
      return users.docs.map((e) => UserM.fromJson(e.data() as Map<String, dynamic>)).toList();
    });
  }

  Future<bool> add_comment(Comment comment) async {
    try {
      await commentcol.doc().set(
          comment.toMap()..update("date_comment", (value) => Timestamp.now()));
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<int> getCountComment(String id) {
    return commentcol
        .where("id_comment_pub", isEqualTo: id)
        .snapshots()
        .map((comments) {
      return comments.docs
          .map((e) => Comment.fromJson(e.data() as Map<String, dynamic>, e.id))
          .toList()
          .length;
    });
  }

  Stream<List<Comment>> gecomment(String id) {
    return commentcol
        .where("id_comment_pub", isEqualTo: id)
        .snapshots()
        .map((comments) {
      return comments.docs
          .map((e) => Comment.fromJson(e.data() as Map<String, dynamic>, e.id))
          .toList();
    });
  }

  Stream<List<Comment>> gecommentComment(String id) {
    return commentcol
        .where("id_comment", isEqualTo: id)
        .snapshots()
        .map((comments) {
      return comments.docs
          .map((e) => Comment.fromJson(e.data() as Map<String, dynamic>, e.id))
          .toList();
    });
  }

  Stream<int> getCountCommentComment(String id) {
    return commentcol
        .where("id_comment", isEqualTo: id)
        .snapshots()
        .map((comments) {
      return comments.docs
          .map((e) => Comment.fromJson(e.data() as Map<String, dynamic>, e.id))
          .toList()
          .length;
    });
  }

}