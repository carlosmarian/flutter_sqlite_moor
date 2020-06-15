import 'package:flutter/material.dart';
import 'package:flutter_database2/src/db/my_database.dart';

class CategoriaAddWidget extends StatefulWidget {
  @override
  _CategoriaAddWidgetState createState() => _CategoriaAddWidgetState();
}

class _CategoriaAddWidgetState extends State<CategoriaAddWidget> {
  String categoriaName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Categioria"),

      ),
      body: Column(
        children: <Widget>[
          TextField(
            onChanged: (text){
              categoriaName = text;
            },
          ),
          RaisedButton(onPressed: (){
              MyDatabase.instance.categoriaDAO
                .addCategoria(Categoria(name: categoriaName));
              Navigator.pop(context);
            }, 
            child: Text("Adicionar"),
          )
        ],
      ),
    );
  }
}