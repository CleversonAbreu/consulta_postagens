import 'package:consultapostagens/Etiqueta.dart';
import 'package:consultapostagens/helper/PostagemHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'model/postagem.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _etiquetaController = TextEditingController();
  TextEditingController _produtoController = TextEditingController();
  var _db = PostagemHelper();
  List<Postagem> _postagens =List<Postagem>();


  _exibirTelaCadastro({Postagem postagem}){

    String textSalvarAtualizar ="";
    if(postagem==null){
      _etiquetaController.text="";
      _produtoController.text="";
      textSalvarAtualizar="Salvar";
    }else{
      _etiquetaController.text=postagem.etiqueta;
      _produtoController.text=postagem.produto;
      textSalvarAtualizar="Editar";
    }


    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(textSalvarAtualizar+' Postagem'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  maxLength: 13,
                  autofocus: true,
                  controller: _etiquetaController,
                  decoration: InputDecoration(
                    labelText: 'Número da etiqueta',
                  ),
                ),
                TextField(
                  maxLength: 40,
                  autofocus: true,
                  controller: _produtoController,
                  decoration: InputDecoration(
                    labelText: 'Nome do produto',
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: ()=>Navigator.pop(context),
                child: Text('Cancelar'),
              ),
              FlatButton(
                onPressed: (){
                  _salvarPostagem(postagemSeleciona: postagem);
                  Navigator.pop(context);
                },
                child: Text(textSalvarAtualizar),
              ),
            ],
          );
        }
    );
  }
  _recuperarPostagem() async{
    List postagensRecuperadas =await _db.recuperarPostegem();

    List<Postagem> listaTemporaria =List<Postagem>();
    for (var item in postagensRecuperadas){
      Postagem postagem =Postagem.fromMap(item);
      listaTemporaria.add(postagem);
    }

    setState(() {
      _postagens = listaTemporaria;
    });
    listaTemporaria=null;
  }

  _salvarPostagem({Postagem postagemSeleciona}) async{
    String etiqueta = _etiquetaController.text;
    String produto = _produtoController.text;

    if(postagemSeleciona==null){
      Postagem postagem = Postagem(etiqueta,produto,DateTime.now().toString());
      int resultado =await _db.salvarPostagem(postagem);
    }else{
      postagemSeleciona.etiqueta= etiqueta;
      postagemSeleciona.produto= produto;
      postagemSeleciona.data= DateTime.now().toString();
      int resultado = await _db.atualizarPostagem(postagemSeleciona);

    }

    _etiquetaController.clear;
    _produtoController.clear();
    _recuperarPostagem();

  }

  _formatarData(String data){
    initializeDateFormatting("pt_BR");
    var format = DateFormat('d/M/y');
    DateTime dataConvertida = DateTime.parse(data);
    String dataFormatada = format.format(dataConvertida);
    return dataFormatada;
  }

  _removerPostagem(int id) async{
    await _db.removerPostagem(id);
    _recuperarPostagem();
  }

  @override
  void initState() {
    super.initState();
    _recuperarPostagem();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[650],
       // title: Text('Rastrear Postagens'),
        title: Image.asset('images/correios.png',width: 198,height: 122,
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: _postagens.length,
                  itemBuilder:(context,index){
                    final postagem = _postagens[index];
                    return Card(
                      child: ListTile(
                        title: Text(postagem.etiqueta),
                        subtitle: Text("${_formatarData(postagem.data)} - ${postagem.produto}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                //_exibirTelaCadastro(postagem: postagem);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Etiqueta(postagem.etiqueta)),
                                );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                _exibirTelaCadastro(postagem: postagem);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                _removerPostagem(postagem.id);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.delete_forever,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        )
                      ),
                    );
                  }
              )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow[650],
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: (){
          _exibirTelaCadastro();
        },
      ),
    );
  }
}
