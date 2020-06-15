
import 'package:flutter_database2/src/db/my_database.dart';
import 'package:moor_flutter/moor_flutter.dart';

part 'ProdutoDAO.g.dart';

//Classe para join
class ProdutoWithNameCategoria{
  final Produto produto;
  final Categoria categoria;

  ProdutoWithNameCategoria(this.produto, this.categoria) ;
}

@UseDao(tables: [Produtos, Categorias])
class ProdutoDAO extends DatabaseAccessor<MyDatabase> with _$ProdutoDAOMixin{

  ProdutoDAO(MyDatabase db): super (db);

  Stream<List<ProdutoWithNameCategoria>> listaAll(){
  // Wrap the whole select statement in parenthesis
    return (select(produtos)
          // Statements like orderBy and where return void => the need to use a cascading ".." operator
          ..orderBy(
            ([
              // Primary sorting by due date
              (t) =>
                  OrderingTerm(expression: t.description, mode: OrderingMode.asc),
            ]),
          ))
        // As opposed to orderBy or where, join returns a value. This is what we want to watch/get.
        .join(
          [
            // Join all the produtos with their tags.
            // It's important that we use equalsExp and not just equals.
            // This way, we can join using all tag names in the produtos table, not just a specific one.
            leftOuterJoin(categorias, categorias.id.equalsExp(produtos.idCategoria)),
          ],
        )
        // watch the whole select statement including the join
        .watch()
        // Watching a join gets us a Stream of List<TypedResult>
        // Mapping each List<TypedResult> emitted by the Stream to a List<TaskWithTag>
        .map(
          (rows) => rows.map(
            (row) {
              return ProdutoWithNameCategoria(
                row.readTable(produtos),
                row.readTable(categorias),
              );
            },
          ).toList(),
        );
  }

  Future addProduto(Produto entity){
    return into(produtos).insert(entity);
  }  

  Future deleteProduto(id){
    return (delete(produtos)..where((tbl) => tbl.id.equals(id))).go();
  }

Stream<List<Produto>> findByCategori2(int idCategori) {
return (select(produtos)..where((tbl) => tbl.idCategoria.equals(idCategori))).watch();
}

  Future<List<Produto>> findByCategori(int idCategori) async{
    print("object");

    return (select(produtos)..where((tbl) => tbl.idCategoria.equals(idCategori))).get();
  }

  Future updateProduto(Produto entity){
    return update(produtos).replace(entity);
  }
}
