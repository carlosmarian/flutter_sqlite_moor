import 'package:flutter_database2/src/db/dao/ProdutoDAO.dart';
import 'package:moor_flutter/moor_flutter.dart';

import 'dao/CategoriaDAO.dart';

part 'my_database.g.dart';

class Produtos extends Table{
  IntColumn get id => integer().autoIncrement()();
  IntColumn get idCategoria => integer()();
  TextColumn get title => text()();
  TextColumn get description => text()();
  IntColumn get qtde => integer()();
  // 1,00 => 100 ou 10,00 => 1000
  IntColumn get price => integer()();

}

class Categorias extends Table{
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
}


@UseMoor(tables: [Produtos, Categorias])
class MyDatabase  extends _$MyDatabase{
  //O _$Mydatabase foi criado pelo build_runner, comando
  // flutter packages pub run build_runner build

  static MyDatabase instance = MyDatabase._internal();

  ProdutoDAO produtoDAO;// = ProdutoDAO(instance);
  CategoriaDAO categoriaDAO; //= CategoriaDAO(instance);

  //MyDatabase(): super(FlutterQueryExecutor.inDatabaseFolder(path: 'db1.sqlite'));
  MyDatabase._internal(): super(FlutterQueryExecutor.inDatabaseFolder(path: 'db1.sqlite')){    
   produtoDAO = ProdutoDAO(this);
   categoriaDAO = CategoriaDAO(this);
  }

  @override
  int get schemaVersion => 1;

}