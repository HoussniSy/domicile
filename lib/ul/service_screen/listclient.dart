import 'package:domicile/model/service.dart';
import 'package:domicile/ul/service_screen/addService.dart';
import 'package:domicile/utils/serviceCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ClientList extends StatefulWidget {

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  @override
  Widget build(BuildContext context) {
    final List<Service> srvs = Provider.of<List<Service>>(context);
    print(srvs);
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste de service"), backgroundColor: Colors.green),
      body: ListView.builder(
        itemCount: srvs.length,
          itemBuilder: (ctx,i) {
          final srv = srvs[i];
        return srvs == null
            ? CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        )
            :SCard(srv: srv);
      },),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) => AddService()));
        },
      ),
    );
  }
}
