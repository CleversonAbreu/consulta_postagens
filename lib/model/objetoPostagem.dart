import 'package:xml/xml.dart' as xml;

class ObjetoPostagem{

  String erro;
  String numero;
  String nome;
  String categoria;
  String data;
  String hora;
  String descricao;
  String local;
  String codigo;
  String cidade;
  String uf;

  ObjetoPostagem(Iterable<xml.XmlElement> obj){
    try{
      erro=obj.last.findElements("erro").last.text;
    }catch(e){
      numero=obj.last.findElements("numero").last.text;
      nome=obj.last.findElements("nome").first.text;
      categoria=obj.last.findElements("categoria").last.text;
      data=obj.last.findAllElements("evento").toList()[0].findElements("data").last.text;
      hora=obj.last.findAllElements("evento").toList()[0].findElements("hora").last.text;
      descricao=obj.last.findAllElements("evento").toList()[0].findElements("descricao").last.text;
      local=obj.last.findAllElements("evento").toList()[0].findElements("local").last.text;
      codigo=obj.last.findAllElements("evento").toList()[0].findElements("codigo").last.text;
      cidade=obj.last.findAllElements("evento").toList()[0].findElements("cidade").last.text;
      uf=obj.last.findAllElements("evento").toList()[0].findElements("uf").last.text;

    }
  }
}