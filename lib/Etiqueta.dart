import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;
import 'model/objetoPostagem.dart';

class Etiqueta extends StatefulWidget {
  String etiqueta;
  Etiqueta(this.etiqueta);

  @override
  _EtiquetaState createState() => _EtiquetaState();
}

class _EtiquetaState extends State<Etiqueta> {
  String resposta="";
  void _buscarSro() async {
    String envelope =
        "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" "
            +"xmlns:res=\"http://resource.webservice.correios.com.br/\"> "
            +"   <soapenv:Header/> "
            +"   <soapenv:Body>  "
            +"      <res:buscaEventosLista> "
            +"         <usuario>ECT</usuario> "
            +"         <senha>SRO</senha>  "
            +"         <tipo>L</tipo>  "
            +"         <resultado>U</resultado>  "
            +"         <lingua>101</lingua> "
            +"         <objetos>"+this.widget.etiqueta+"</objetos> "
            +"      </res:buscaEventosLista>  "
            +"   </soapenv:Body> "
            +"</soapenv:Envelope>";

    final response =
    await http.post("http://webservice.correios.com.br:80/service/rastro",
      headers: {"Content-Type": "text/xml",
      },body: envelope,);

    ObjetoPostagem objeto = ObjetoPostagem(xml.parse(response.body).findAllElements("objeto"));

    setState(() {
      if(objeto.erro!=null){
        resposta =objeto.erro;
      }else{
        resposta =
            "Etiqueta: "+objeto.numero+"\n"
            +"Serviço: "+objeto.categoria+"\n"
            +"Situação: "+objeto.descricao+"\n"
            +"Data: "+objeto.data+"\n"
            +"Hora: "+objeto.hora+"\n";
      }
    });
  }

  @override
  initState() {
    super.initState();
    _buscarSro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[650],
        title: Text(this.widget.etiqueta),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.all(45),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset("images/correios_logo.jpg"),
                Text('RASTREAMENTO DA POSTAGEM',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    color: Colors.blue[900]
                  ),),
                Padding(
                  padding: EdgeInsets.only(top: 20,bottom: 30),
                  child: Text(resposta,
                    style: TextStyle(
                        fontSize: 18
                    ),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

