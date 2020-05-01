import 'package:consultapostagens/model/postagem.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class PostagemHelper{
  static final String nomeTabela ='postagem';
  static final PostagemHelper _postagemHelper = PostagemHelper._internal();
  Database _db;

  factory PostagemHelper(){
    return _postagemHelper;
  }
  PostagemHelper._internal(){
  }

  get db async{
    if(_db!=null){
      return _db;
    }else{
      _db = await inicializarDB();
      return _db;
    }
  }

  _onCreate(Database db,int version) async{
    String sql="CREATE TABLE $nomeTabela (id INTEGER PRIMARY KEY AUTOINCREMENT, etiqueta VARCHAR, produto VARCHAR, data DATETIME)";
    await db.execute(sql);

  }
  inicializarDB() async{
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados   = join(caminhoBancoDados,'postagens.db');

    var db = await openDatabase(localBancoDados,version: 1,onCreate:_onCreate);
    return db;
  }

  Future<int>salvarPostagem(Postagem postagem)async{
    var bancoDados = await db;

    int id = await bancoDados.insert(nomeTabela,postagem.toMap());
    return id;

  }

  recuperarPostegem()async{
    var bancoDados = await db;
    String sql="SELECT * FROM $nomeTabela ORDER BY data DESC";
    List postagens = await bancoDados.rawQuery(sql);
    return postagens;

  }

  Future<int>atualizarPostagem(Postagem postagem)async{
    var bancoDados = await db;

    return await bancoDados.update(
        nomeTabela,
        postagem.toMap(),
      where:"id=?",
      whereArgs:[postagem.id]
    );
  }

  Future<int>removerPostagem(int id)async{
    var bancoDados = await db;

    return await bancoDados.delete(
        nomeTabela,
        where:"id=?",
        whereArgs:[id]
    );
  }

}