import 'package:domicile/model/user.dart';
import 'package:domicile/services/db.dart';
import 'package:domicile/ul/auth/admin/pub_list.dart';
import 'package:domicile/ul/auth/admin/user_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Espace administrateur"),
            backgroundColor: Colors.red,
            bottom: TabBar(
              indicatorColor: Colors.white,
              tabs: [
                Tab(icon: Icon(Icons.person)),
                Tab(icon: Icon(Icons.folder)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              StreamProvider<List<UserM>>.value(
                  value: DBServices().getAllUsers, initialData: [],
                  child: UserListPage()),
              PubListPage()
            ],
          ),
        ));
  }
}