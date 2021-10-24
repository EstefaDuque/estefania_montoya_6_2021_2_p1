import 'package:estefania_montoya_6_2021_2_p1/models/new.dart';
import 'package:flutter/material.dart';

class NewInfoScreen extends StatefulWidget {
  final New new1;
  NewInfoScreen({required this.new1});

  @override
  _NewInfoScreenState createState() => _NewInfoScreenState();
}

class _NewInfoScreenState extends State<NewInfoScreen> {
  bool _showLoader = false;
  late New _new1;

  @override
  void initState() {
    super.initState();
    _new1 = widget.new1;
  }

  @override
  Widget build(BuildContext context) {
    //Foi adicionado dentro de Container para adicionar margem no item
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        margin: EdgeInsets.all(15),
        elevation: 3,
        child: InkWell(
            child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Column(
            children: <Widget>[
              Container(
                height: 300.0,
                width: 300.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(_new1.imageUrl),
                    fit: BoxFit.fill,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Text('${_new1.date}, ${_new1.time}',
                    style:
                        TextStyle(fontStyle: FontStyle.italic, fontSize: 10)),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(_new1.title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(_new1.content),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text('More information \n ${_new1.readMoreUrl}'),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Origin of the news \n ${_new1.url}',
                ),
              ),
            ],
          ),
        )));
  }

  Widget _getListTile() {
    // Foi adicionado dentro de Container para adicionar altura fixa.
    return new Container(
      height: 95.0,
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new FadeInImage.assetNetwork(
            placeholder: '',
            image: _new1.imageUrl,
            fit: BoxFit.cover,
            width: 95.0,
            height: 95.0,
          ),
          _getColumText(_new1.title, _new1.date, _new1.content),
        ],
      ),
    );
  }

  Widget _getColumText(tittle, date, description) {
    return new Expanded(
        child: new Container(
      margin: new EdgeInsets.all(10.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _getTitleWidget(tittle),
          _getDateWidget(date),
          _getDescriptionWidget(description)
        ],
      ),
    ));
  }

  Widget _getTitleWidget(String curencyName) {
    return new Text(
      curencyName,
      maxLines: 1,
      style: new TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _getDescriptionWidget(String description) {
    return new Container(
      margin: new EdgeInsets.only(top: 5.0),
      child: new Text(
        description,
        maxLines: 2,
      ),
    );
  }

  Widget _getDateWidget(String date) {
    return new Text(
      date,
      style: new TextStyle(color: Colors.grey, fontSize: 10.0),
    );
  }
}
