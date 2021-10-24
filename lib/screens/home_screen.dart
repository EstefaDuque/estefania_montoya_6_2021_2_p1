import 'package:estefania_montoya_6_2021_2_p1/screens/news_screen.dart';
import 'package:estefania_montoya_6_2021_2_p1/helpers/constans.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final title = 'News categories';

    return Scaffold(
      appBar: AppBar(
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
          backgroundColor: Color(0XFF41A5F0)),
      body: GridView.count(
        // Crea una grid con 2 columnas. Si cambias el scrollDirection a
        // horizontal, esto produciría 2 filas.
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,

        // Genera 100 Widgets que muestran su índice en la lista
        children: Constans.categoryList.map(
          (item) {
            return GestureDetector(
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.all(5),
                  width: 5.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    color: Color(0XFFC2E4FD),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Text(item,
                      style: TextStyle(
                          fontSize: 20, fontStyle: FontStyle.italic))),
              onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryScreen(category: item)))
              },
            );
          },
        ).toList(),
      ),
    );
  }
}
