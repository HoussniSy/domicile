import 'dart:io';

import 'package:domicile/model/fournisseur.dart';
import 'package:domicile/services/db.dart';
import 'package:domicile/utils/getImage.dart';
import 'package:domicile/utils/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UpdateFourni extends StatefulWidget {
  Fourni f;
  UpdateFourni({required this.f});
  @override
  _UpdateFourniState createState() => _UpdateFourniState();
}

class _UpdateFourniState extends State<UpdateFourni> {
  final key = GlobalKey<FormState>();
  late String nom, adresse, code, competence, tel, experience;
  List<dynamic> images = [];

  Fourni prv = Fourni(competence: '', experience: '', images: [], nom: '', adresse: '', code: '', tel: '', id: '', uid: '', dislike: [], like: [], favories: []);
  void initState() {
    // TODO: implement initState
    super.initState();
    nom = widget.f.nom;
    code = widget.f.code;
    adresse = widget.f.adresse;
    tel = widget.f.tel;
    experience = widget.f.experience;
    competence = widget.f.competence;
    images.addAll(widget.f.images);
    prv = widget.f;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Modifier " + widget.f.nom),
          backgroundColor: Colors.lightBlue,
          actions: [Icon(FontAwesomeIcons.motorcycle)],
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(10),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: nom,
                    validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => nom = e,
                    decoration: InputDecoration(
                        hintText: "nom du technicien",
                        labelText: "Nom",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: adresse,
                    validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => adresse = e,
                    decoration: InputDecoration(
                        hintText: "adresse du technicien",
                        labelText: "Adresse",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: code,
                    keyboardType: TextInputType.number,
                    validator: (e) => e!.isEmpty ? "code se champ" : null,
                    onChanged: (e) => code = e,
                    decoration: InputDecoration(
                        hintText: "code_postal du technicien",
                        labelText: "Code Postal",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: tel,
                    keyboardType: TextInputType.number,
                    validator: (e) => e!.isEmpty ? "tel se champ" : null,
                    onChanged: (e) => tel = e,
                    decoration: InputDecoration(
                        hintText: "teléphone du technicien",
                        labelText: "Teléphone",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: competence,
                    validator: (e) => e!.isEmpty ? "Remplir se champ" : null,
                    onChanged: (e) => competence = e,
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: "competenece Aquise",
                        labelText: "Compétence",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    initialValue: experience,
                    keyboardType: TextInputType.number,
                    validator: (e) => e!.isEmpty ? "code se champ" : null,
                    onChanged: (e) => experience = e,
                    maxLines: 3,
                    decoration: InputDecoration(
                        hintText: "expérience du technicien",
                        labelText: "Expérience",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Wrap(
                    children: [
                      for (int i = 0; i < images.length; i++)
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.4)),
                          margin: EdgeInsets.only(right: 5, bottom: 5),
                          height: 70,
                          width: 70,
                          child: Stack(
                            children: [
                              if (images[i] is File)
                                Image.file(
                                  images[i],
                                  fit: BoxFit.fitHeight,
                                ),
                              if (images[i] is String)
                                Image.network(
                                  images[i],
                                  fit: BoxFit.fitHeight,
                                ),
                              Align(
                                alignment: Alignment.center,
                                child: IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.minusCircle,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      images.removeAt(i);
                                    });
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      InkWell(
                        onTap: () async {
                          final data = await showModalBottomSheet(
                              context: context,
                              builder: (ctx) {
                                return GetImage();
                              });
                          if (data != null)
                            setState(() {
                              images.add(data);
                            });
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          color: Colors.lightBlue,
                          child: Icon(
                            FontAwesomeIcons.plusCircle,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (key.currentState!.validate() && images.length > 0) {
                          loading(context);
                          prv.nom = nom;
                          prv.adresse = adresse;
                          prv.code = code;
                          prv.tel = tel;
                          prv.competence = competence;
                          prv.experience = experience;
                          prv.images = [];
                          prv.uid = FirebaseAuth.instance.currentUser!.uid;
                          for (var i = 0; i < images.length; i++) {
                            if (images[i] is File) {
                              String? urlImage = await DBServices()
                                  .uploadImage(images[i], path: "prvs");
                              if (urlImage != null) prv.images.add(urlImage);
                            } else {
                              prv.images.add(images[i]);
                            }
                          }
                          if (images.length == prv.images.length) {
                            bool update =
                            await DBServices().updatefourni(prv);
                            if (update) {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }
                            ;
                          }
                        } else {
                          print("veillez remplir tous les champs");
                        }
                      },
                      child: Text("Modifier",
                          style: TextStyle(color: Colors.white,fontSize: 20)),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}