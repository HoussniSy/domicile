import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:domicile/model/fournisseur.dart';
import 'package:domicile/model/service.dart';
import 'package:domicile/services/auth.dart';
import 'package:domicile/services/db.dart';
import 'package:domicile/ul/auth/login_screen.dart';
import 'package:domicile/ul/auth/menu.dart';
import 'package:domicile/ul/service_screen/listfourni.dart';
import 'package:domicile/utils/slider.dart';
import 'package:domicile/utils/utils.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../service_screen/addFourni.dart';
import '../service_screen/addService.dart';
import '../service_screen/listclient.dart';


class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with SingleTickerProviderStateMixin{

  late Stream<QuerySnapshot> imageStream;
  final key = GlobalKey<ScaffoldState>();
  AuthServices auth = AuthServices();
  CarouselController carouselController = CarouselController();
  late Animation<double> _animation;
  List tmps = [];
  late AnimationController _animationController;


  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(microseconds: 250)
    );
    final curve = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animation = Tween<double>(begin: 0, end: 1).animate(curve);

    super.initState();
  }

  get getCarouselImage async{
    final img = await DBServices().getCarouselImage;
    setState(() {
      tmps =img!;
    });
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
      backgroundColor: Colors.yellowAccent,
      key: key,
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text('Service Dépannage'),
        actions: [
            InkWell(
              onTap: () {
                key.currentState?.openDrawer();
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          IconButton(
            onPressed: () {
            auth.signOut().then((value){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            }).onError((error, stackTrace){
              Utils().toastMessage(error.toString());
            });
          }, icon: Icon(Icons.logout_outlined),),
          SizedBox(width: 10,)
        ],

      ),

      body: Column(
        children: [
          Sliders(imgs: tmps),
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
            border: Border.all(color: Colors.lightBlue),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                        builder: (ctx)=> StreamProvider<List<Service>>.value(
                          value: DBServices().getservice,
                          initialData: [],
                          child: ClientList(),
                        )));
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.lightGreen,
                    child: Icon(FontAwesomeIcons.peopleGroup,
                        size: 50,color: Colors.white),
                  ),
                ),
                SizedBox(width: 10,),
                InkWell(
                  onTap: (){
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                        builder: (ctx)=> StreamProvider<List<Fourni>>.value(
                          value: DBServices().getprovider,
                          initialData: [],
                          child: FourniListe(),
                        )));
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.lightBlue,
                    child: Icon(FontAwesomeIcons.person,
                        size: 50,color: Colors.white),
                  ),
                ),
              ],
            ),
          )],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      floatingActionButton: FloatingActionBubble(
        backGroundColor: Colors.black,
        items:[
          Bubble(
              icon: FontAwesomeIcons.peopleGroup,
              iconColor: Colors.white,
              title: "Client",
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              bubbleColor: Colors.green,
              onPress: (){
                _animationController.reverse();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => AddService()));
              }),

          Bubble(
              icon: FontAwesomeIcons.person,
              iconColor: Colors.white,
              title: "Fournisseur",
              titleStyle: TextStyle(fontSize: 16, color: Colors.white),
              bubbleColor: Colors.lightBlue,
              onPress: (){
                _animationController.reverse();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => AddFourni()));
              }),
        ],
        onPress: _animationController.isCompleted
            ? _animationController.reverse
            :_animationController.forward,
        animation: _animation,
        iconColor:Colors.white,
        animatedIconData: AnimatedIcons.add_event,
      ),
    );
  }
}