import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:estefania_montoya_6_2021_2_p1/components/loader_component.dart';
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
  bool _isFiltered = false;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Category News ${widget.category}'),
          actions: <Widget>[
            _isFiltered
                ? IconButton(
                    onPressed: _removeFilter, icon: Icon(Icons.filter_none))
                : IconButton(
                    onPressed: _showFilter, icon: Icon(Icons.filter_alt))
          ],
        ),
        body: Center(
          child: _showLoader
              ? LoaderComponent(text: 'Por favor espere...')
              : _getContent(),
        ));
  }

  @override
  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getNews,
      child: ListView(
        children: _news.map((e) {
          return Card(
              color: Color(0XFFDCE9F3),
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

  void _removeFilter() {
    setState(() {
      _isFiltered = false;
    });
    _getNews();
  }

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text('Filter news'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Write the first letters of the title of the news'),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: 'Search criteria...',
                      labelText: 'Search',
                      suffixIcon: Icon(Icons.search)),
                  onChanged: (value) {
                    _search = value;
                  },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')),
              TextButton(onPressed: () => _filter(), child: Text('Filter')),
            ],
          );
        });
  }

  void _filter() {
    if (_search.isEmpty) {
      return;
    }

    List<New> filteredList = [];
    for (var new1 in _news) {
      if (new1.title.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(new1);
      }
    }

    setState(() {
      _news = filteredList;
      _isFiltered = true;
    });

    Navigator.of(context).pop();
  }

  Widget _getContent() {
    return _news.length == 0 ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFiltered
              ? 'There is no news with that search criteria.'
              : 'No news registered.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
