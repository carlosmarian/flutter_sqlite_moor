import 'package:flutter/material.dart';
import 'package:flutter_database2/src/categoria/CategoriaAddWidget.dart';
import 'package:flutter_database2/src/db/my_database.dart';

class CategoriaWidget extends StatefulWidget {
  @override
  _CategoriaWidgetState createState() => _CategoriaWidgetState();
}

class _CategoriaWidgetState extends State<CategoriaWidget> {
  
  void exibeSnackBar(BuildContext context, String msg){
    final snackBar = SnackBar(
        content: Text(msg),
      );
      Scaffold.of(context).showSnackBar(snackBar);
  }

  Future<String> excluir(int id) async {
    MyDatabase.instance.produtoDAO.findByCategori(id)
    .whenComplete(() => {
      print("whenComplete")
    })
    .then((value){
      print("Then");
      print(value.length);
      if (value.length == 0) {
        print(id);
        MyDatabase.instance.categoriaDAO.deleteCategoria(id);
        return "Removido";
      }else{
        return "Não excluido";
      }
    }).catchError((onError){
      print(onError);
      return "Erro";
    });
  }

  Future<String> createOrderMessage(int id) async {
  var order = await excluir(id);
  return '$order';
}

  showAlertDialog(BuildContext context, int id) {
    // configura o button
    Widget okButton = FlatButton(
      child: Text("Excluir"),
      onPressed: () {
        var ret = createOrderMessage(id);
        exibeSnackBar(context, '$ret');
        Navigator.of(context).pop();
      },
    );
    Widget canButton = FlatButton(
      child: Text("Cancelar"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // configura o  AlertDialog
    AlertDialog alerta = AlertDialog(
      title: Text("Atenção"),
      content: Text("Confirma excluir categoria?"),
      actions: [
        canButton,
        okButton,
      ],
    );

    // exibe o dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alerta;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categorias"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return CategoriaAddWidget();
                }));
              })
        ],
      ),
      body: StreamBuilder<List<Categoria>>(
          stream: MyDatabase.instance.categoriaDAO.listaAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            List<Categoria> categorias = snapshot.data;
            return ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(categorias[index].name),
                        subtitle: Text("${categorias[index].name}"),
                      ),
                      Row(
                        children: <Widget>[
                          Spacer(),
                          IconButton(
                              icon: Icon(Icons.delete_sweep),
                              onPressed: () {
                                showAlertDialog(context, categorias[index].id);
                              })
                        ],
                      )
                    ],
                  ),
                );
                //return ListTile(title: Text(categorias[index].name),);
              },
            );
          }),
    );
  }
}
