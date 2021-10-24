import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:estefania_montoya_6_2021_2_p1/screens/new_info_screen.dart';
import 'package:estefania_montoya_6_2021_2_p1/helpers/api_helper.dart';
import 'package:estefania_montoya_6_2021_2_p1/models/new.dart';
import 'package:estefania_montoya_6_2021_2_p1/models/response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CategoryScreen extends StatefulWidget {
  final String category;

  CategoryScreen({required this.category});

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<CategoryScreen> {
  List<New> _news = [];

  bool _showLoader = false;

  @override
  void initState() {
    print(widget.category);
    super.initState();
    _getNews();
  }

  @override
  Widget build(BuildContext context) {
    print('ke${_news.length}');
    return RefreshIndicator(
      onRefresh: _getNews,
      child: ListView(
        children: _news.map((e) {
          return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
              margin: EdgeInsets.all(15),
              elevation: 3,
              child: InkWell(
                  onTap: () => _goInfoNew(e),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: Column(
                      children: <Widget>[
                        Image(
                          image: NetworkImage(e.imageUrl),
                          height: 100.0,
                          width: 100.0,
                        ),
                        Container(
                          padding: EdgeInsets.all(10),
                          child: Text(e.title),
                        ),
                      ],
                    ),
                  )));
        }).toList(),
      ),
    );
  }

  Future<Null> _getNews() async {
    setState(() {
      _showLoader = true;
    });

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        _showLoader = false;
      });
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica que estes conectado a internet.',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    Response response = await ApiHelper.getNews(widget.category);

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }

    setState(() {
      _news = response.result;
    });
  }

  void _goInfoNew(New new1) async {
    String? result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => NewInfoScreen(
                  new1: new1,
                )));
    if (result == 'yes') {
      _getNews();
    }
  }
}
