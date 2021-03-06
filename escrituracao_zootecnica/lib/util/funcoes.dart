import 'package:flutter/material.dart';

//funcao que checa se o atributo vino do db eh vazio
String ehvazio(dynamic a) {
  String stringFinal = a;
  if (a == null || a == "") {
    stringFinal = "Não Informado";
  }
  return stringFinal;
}

//funcao que calcula a idade do animal
String idadeAnimal(String ano, String mes, {int condicao}) {
  DateTime _dataAtual = new DateTime.now();
  String anoAtual = "${_dataAtual.year}";
  String mesAtual = "${_dataAtual.month}";
  String resultado = "";
  int anos = int.parse(anoAtual) - int.parse(ano);
  int meses = (int.parse(mesAtual) - int.parse(mes));

  if (condicao != null) {
    return meses.toString();
  }

  if (meses < 0) {
    meses = meses + 12;
  }
  if (anos >= 1 && int.parse(mes) <= int.parse(mesAtual)) {
    resultado = anos.toString() + " ano(s) e " + meses.toString() + " meses";
  } else {
    resultado = meses.toString() + " meses";
  }

  return resultado;
}

//funcao que retorna o estilo padrao da caixa de entrada de informacoes
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

//funcao para padronizar o espacamento e
Container espacamentoPadrao() {
  return Container(
    padding: EdgeInsets.all(5.0),
  );
}

//funcao para calculo dos dias restantes do periodo de carencia
Widget calculoDiasRestantes(String dia, String mes, String ano, String data) {
  int newData = int.parse(data);
  var berlinWallFell =
      new DateTime.utc(int.parse(ano), int.parse(mes), int.parse(dia));

  DateTime dataAtual = DateTime.now();

  var dDay = new DateTime.utc(dataAtual.year, dataAtual.month, dataAtual.day);

  Duration difference = berlinWallFell.difference(dDay);

  int diferenca = difference.inDays.abs();
  String texto = "";

  if (diferenca > newData) {
    texto = "Ja passou da data";
  } else if (diferenca == newData) {
    texto = "1 dia";
  } else if (diferenca < newData) {
    return Text((newData - diferenca).toString() + " dias",
        style: TextStyle(color: Colors.red));
  }
  return Text(texto, style: TextStyle(color: Colors.red));
}

//funcao para exibir a data no formato brasileiro
String exibicaoDataPadrao(String dataSelecionada) {
  if (dataSelecionada == "Não Informada") {
    return dataSelecionada;
  } else {
    dynamic date = dataSelecionada.split("-");
    String dia = date[2];
    String mes = date[1];
    String ano = date[0];
    return dia + "/" + mes + "/" + ano;
  }
}

// funcao base para formatar data
String dataFormatada(DateTime data) {
  String dia = "${data.day}";
  String nd = "";
  String mes = "${data.month}";
  String nm = "";
  if (dia.length < 2) {
    nd = "0" + dia;
  } else {
    nd = dia;
  }
  if (mes.length < 2) {
    nm = "0" + mes;
  } else {
    nm = mes;
  }
  return "${data.year}-" + nm + "-" + nd;
}

// funcao base para selecao de data (retorno dynamic)
selectDate(BuildContext context, DateTime dataSelecionada) async {
  final DateTime picked = await showDatePicker(
    context: context,
    initialDate: dataSelecionada,
    firstDate: new DateTime(1900),
    lastDate: new DateTime(2100),
  );
  if (picked != null && picked != dataSelecionada) {
    return picked;
  }
  return dataSelecionada;
}

// alerta para caso o usuario tente cadastra uma pesgem futura(nao permitido)
showAlert(BuildContext context, DateTime dataSelecionada, String texto) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Você não pode cadastrar uma $texto futura!"),
          actions: <Widget>[
            FlatButton(
              child: Text("OK"),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
}

int count(lista, elemento) {
  int contador = 0;

  for (var i = 0; i < lista.length; i++) {
    if (lista[i] == elemento) {
      contador++;
    }
  }
  return contador;
}
