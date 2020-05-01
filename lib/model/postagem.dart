class Postagem{
  int id;
  String etiqueta;
  String produto;
  String data;

  Postagem(this.etiqueta,this.produto,this.data);

  Postagem.fromMap(Map map){
    this.id=map['id'];
    this.etiqueta=map['etiqueta'];
    this.produto=map['produto'];
    this.data=map['data'];
  }

  Map toMap(){
    Map <String,dynamic> map ={
      "etiqueta":this.etiqueta,
      "produto":this.produto,
      "data":this.data
    };
    if(this.id!=null)
      map['id']=this.id;

    return map;
  }
}