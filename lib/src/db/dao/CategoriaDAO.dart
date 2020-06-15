import 'package:flutter_database2/src/db/my_database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'CategoriaDAO.g.dart';

@UseDao(tables: [Categorias])
class CategoriaDAO extends DatabaseAccessor<MyDatabase> with _$CategoriaDAOMixin{

  CategoriaDAO(MyDatabase db): super (db);
  
  Stream<List<Categoria>> listaAll(){
    return (select(categorias)).watch();
  }

  Future addCategoria(Categoria entity){
    return into(categorias).insert(entity);
  }

  Future deleteCategoria(id){
    return (delete(categorias)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future updateCategoria(Categoria entity){
    return update(categorias).replace(entity);
  }

}
