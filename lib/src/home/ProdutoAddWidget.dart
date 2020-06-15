import 'package:flutter/material.dart';
import 'package:flutter_database2/src/db/my_database.dart';

class ProdutoAddWidget extends StatefulWidget {
  @override
  _ProdutoAddWidgetState createState() => _ProdutoAddWidgetState();
}

class _ProdutoAddWidgetState extends State<ProdutoAddWidget> {
  
  Produto produto = Produto(price: 0, qtde: 10);
  int value = null;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add produto"),
      ),
      body: Form(
        key: _formkey,
        child:ListView(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Título do Produto"
              ),
              onSaved: (valeu){
                produto = produto.copyWith(title : valeu);
              },
            ),
            Container(height: 20,),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Descrição do Produto"
              ),
              onSaved: (valeu){
                produto = produto.copyWith(description : valeu);
              },
            ),
            Container(height: 20,),
            StreamBuilder<List<Categoria>>(
              stream: MyDatabase.instance.categoriaDAO.listaAll(),
              initialData: [],
              builder: (context, snapshot){
                if(!snapshot.hasData) return Container();

                var list = snapshot.data;
                return DropdownButtonFormField(
                  hint: Text("Categoria"),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  value: value,
                  items: list.map((c) => DropdownMenuItem(
                    child: Text(c.name),
                    value: c.id,)
                    ).toList(), 
                  onChanged: (v){
                    print(v);
                    setState(() {                      
                      value = v.id;
                    });
                  }, 
                  onSaved: (id){
                    produto = produto.copyWith(idCategoria : id);
                  },
                  );
              }
              ),
            Container(height: 20,),
            RaisedButton(
              child: Text("Salvar"),
              onPressed: () async{
                _formkey.currentState.save();
                print(produto.toJson());
                //produto.qtde = 0;
                await MyDatabase.instance.produtoDAO.addProduto(produto);
                Navigator.pop(context);
              })

          ],
        ),
      ),
    );
  }
}