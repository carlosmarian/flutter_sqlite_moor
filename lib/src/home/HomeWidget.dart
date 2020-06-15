import 'package:flutter/material.dart';
import 'package:flutter_database2/src/categoria/CategoriaWidget.dart';
import 'package:flutter_database2/src/db/dao/ProdutoDAO.dart';
import 'package:flutter_database2/src/db/my_database.dart';
import 'package:flutter_database2/src/home/ProdutoAddWidget.dart';

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  showAlertDialog1(BuildContext context, int id) {
    // configura o button
    Widget okButton = FlatButton(
      child: Text("Excluir"),
      onPressed: () {
        MyDatabase.instance.produtoDAO.deleteProduto(id);
        final snackBar = SnackBar(
          content: Text('Excluido com sucesso!'),
        );
        Scaffold.of(context).showSnackBar(snackBar);
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
      title: Text("Ateção"),
      content: Text("Confirma excluir produto?"),
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
        title: Text("Cadastro de Produtos"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.category),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CategoriaWidget();
              }));
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ProdutoWithNameCategoria>>(
          stream: MyDatabase.instance.produtoDAO.listaAll(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();

            List<ProdutoWithNameCategoria> produtos = snapshot.data;

            return ListView.builder(
              itemCount: produtos.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(produtos[index].produto.description),
                        subtitle: Text("${produtos[index].categoria.name}"),
                      ),
                      Row(
                        children: <Widget>[
                          Text("${produtos[index].produto.price}"),
                          Spacer(),
                          IconButton(
                              icon: Icon(Icons.directions_bike),
                              onPressed: () {
                                print("object");
                              }),
                          IconButton(
                              icon: Icon(Icons.delete_sweep),
                              onPressed: () {
                                print("object");
                                showAlertDialog1(
                                    context, produtos[index].produto.id);
                              })
                        ],
                      )
                    ],
                  ),
                );
                /*
                return ListTile(title: Text(produtos[index].produto.description),
                    subtitle: Text("${produtos[index].categoria.name}"),
                    );
                    */
              },
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ProdutoAddWidget();
          }));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
