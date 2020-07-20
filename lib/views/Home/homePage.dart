import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socail_network_flutter/services/Database.dart';
import 'package:socail_network_flutter/services/constant.dart';
import 'package:socail_network_flutter/views/Home/widgets/widgetsHome.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DatabaseMethods _databaseMethods = DatabaseMethods();
  Future<void> _refresh() async {
    if (!mounted) return;
    setState(() {
      Constants.data = _databaseMethods.getPosts();
    });
  }

  @override
  void initState() {
    super.initState();
    if (Constants.data == null) {
      Constants.data = _databaseMethods.getPosts();
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: buildRefreshIndicator(context),
    ));
  }

  RefreshIndicator buildRefreshIndicator(BuildContext context) {
    return RefreshIndicator(
      child: buildFutureBuilder(context),
      onRefresh: _refresh,
    );
  }

  FutureBuilder buildFutureBuilder(BuildContext context) {
    return FutureBuilder(
      future: Constants.data,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: Text('Loading....'));
        } else if (snapshot.hasData) {
          return listbuidler(context, snapshot);
        } else {
          return Center(child: Text('No Posts Available'));
        }
      },
    );
  }
}
