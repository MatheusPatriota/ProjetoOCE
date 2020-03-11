import 'package:flutter/material.dart';

String ehvazio(dynamic a) {
  String stringFinal = a;
  if (a == null) {
    stringFinal = "Não Informado";
  }
  return stringFinal;
}

String idadeAnimal(String ano, String mes) {
  DateTime _dataAtual = new DateTime.now();
  String anoAtual = "${_dataAtual.year}";
  String mesAtual = "${_dataAtual.month}";
  String resultado = "";
  int anos = int.parse(anoAtual) - int.parse(ano);
  int meses = (int.parse(mesAtual) - int.parse(mes));

  if(meses <0){meses = meses+12;}
  if (anos >= 1 && int.parse(mes) <= int.parse(mesAtual)) {
    resultado = anos.toString() + " ano(s) e " + meses.toString() + " meses";
  } else {
    resultado = meses.toString() + " meses";
  }

  return resultado;
}

// tipo 1 para texto, tipo 2 para valores de compra
InputDecoration estiloPadrao(String texto, int tipo) {
  if (tipo == 1) {
    return InputDecoration(
      border: OutlineInputBorder(),
      labelText: '$texto',
    );
  } else {
    return InputDecoration(
      border: OutlineInputBorder(),
      labelText: '$texto',
      prefixText: "R\$",
    );
  }
}

Container espacamentoPadrao(){
  return Container(
    padding: EdgeInsets.all(5.0),
  );
}


  Widget calculoDiasRestantes(String dia, String mes, String ano, String data){
  int newData = int.parse(data);
  var berlinWallFell = new DateTime.utc(int.parse(ano), int.parse(mes), int.parse(dia));
  DateTime dataAtual = DateTime.now();
  var dDay = new DateTime.utc(dataAtual.year,dataAtual.month, dataAtual.day); 
  Duration difference = berlinWallFell.difference(dDay);
  int diferenca = difference.inDays.abs();
  String texto ="";
   if(diferenca > newData){
    texto = "Ja passou da data";
    
  }else if(diferenca == newData){
   texto = "1 dias";
  }
  else if(diferenca < newData){
   return Text((newData -diferenca).toString() + " dias", style: TextStyle(color: Colors.red));
  }

  return Text(texto, style: TextStyle(color: Colors.red));


}