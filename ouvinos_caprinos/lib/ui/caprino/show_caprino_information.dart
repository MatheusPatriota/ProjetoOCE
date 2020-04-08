import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:groovin_widgets/groovin_expansion_tile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:ouvinos_caprinos/animal/class/animal.dart';
import 'package:ouvinos_caprinos/animal/db/animal_database.dart';
import 'package:ouvinos_caprinos/categoria/db/categoria_database.dart';
import 'package:ouvinos_caprinos/observacao/class/observacao.dart';
import 'package:ouvinos_caprinos/observacao/db/observacao_database.dart';
import 'package:ouvinos_caprinos/pesagem/class/pesagem.dart';
import 'package:ouvinos_caprinos/pesagem/db/pesagem_database.dart';
import 'package:ouvinos_caprinos/raca/db/raca_database.dart';
import 'package:ouvinos_caprinos/tratamento/class/tratamento.dart';
import 'package:ouvinos_caprinos/tratamento/db/tratamento_database.dart';
import 'package:ouvinos_caprinos/ui/comum/morte_page.dart';
import 'package:ouvinos_caprinos/ui/comum/observacao_page.dart';
import 'package:ouvinos_caprinos/ui/comum/pesagem_page.dart';
import 'package:ouvinos_caprinos/ui/comum/tratamento_page.dart';
import 'package:ouvinos_caprinos/ui/comum/venda_page.dart';
import 'package:ouvinos_caprinos/ui/comum/visualizar_evento.dart';
import 'package:ouvinos_caprinos/util/funcoes.dart';

class CaprinoInformation extends StatefulWidget {
  final Animal caprino;

  CaprinoInformation({this.caprino});

  @override
  _CaprinoInformationState createState() => _CaprinoInformationState();
}

class _CaprinoInformationState extends State<CaprinoInformation> {
  Animal _caprinoSelecionado;

  AnimalHelper animalHelper = AnimalHelper();
  CategoriaHelper categoriaHelper = CategoriaHelper();
  RacaHelper racaHelper = RacaHelper();

  // variaveis para acessor os dbs dos eventos
  TratamentoHelper tratamentoHelper = TratamentoHelper();
  ObservacaoHelper observacaoHelper = ObservacaoHelper();
  PesagemHelper pesagemHelper = PesagemHelper();

  String categoriaSelecionada = "";
  String racaSelecionada = "";

  //listas de eventos
  List<Tratamento> tratamentos = List();
  List<Observacao> observacoes = List();
  List<Pesagem> pesos = List();

  List<String> _dataComSplit;

  bool isExpanded = false;

  Future<void> _getAllCategorias() async {
    await categoriaHelper.getAllCategorias().then((listaC) {
      print(listaC);
      print(_caprinoSelecionado);
      setState(() {
        categoriaSelecionada =
            listaC[_caprinoSelecionado.idCategoria].descricao;
      });
    });
  }

  Future<void> _getAllRacas() async {
    await racaHelper.getAllRacas().then((listaR) {
      print(listaR);

      setState(() {
        racaSelecionada = listaR[_caprinoSelecionado.idRaca].descricao;
      });
    });
  }

  Future<void> _getAllTratamentos() async {
    List<Tratamento> tratamentosFinal = List();
    await tratamentoHelper.getAllTratamentos().then((listaT) {
      print(listaT);
      if (listaT.isNotEmpty) {
        for (var tratamento in listaT) {
          if (tratamento.animalId == _caprinoSelecionado.idAnimal) {
            tratamentosFinal.add(tratamento);
          }
        }
        setState(() {
          Comparator<Tratamento> tratamentoComparator = (a, b) {
            DateTime dateTimeA =
                DateTime.parse("${a.dataTratamento}" + " 00:00:00");
            DateTime dateTimeB =
                DateTime.parse("${b.dataTratamento}" + " 00:00:00");
            return dateTimeB.compareTo(dateTimeA);
          };
          tratamentosFinal.sort(tratamentoComparator);
          tratamentos = tratamentosFinal;
        });
      }
    });
  }

  Future<void> _getAllObservacoes() async {
    List<Observacao> observacoesFinal = List();
    await observacaoHelper.getAllObservacaos().then((listaO) {
      print(listaO);
      if (listaO.isNotEmpty) {
        for (var observacao in listaO) {
          if (observacao.animalId == _caprinoSelecionado.idAnimal) {
            observacoesFinal.add(observacao);
          }
        }
        setState(() {
          Comparator<Observacao> observacaoComparator = (a, b) {
            DateTime dateTimeA = DateTime.parse("${a.data}" + " 00:00:00");
            DateTime dateTimeB = DateTime.parse("${b.data}" + " 00:00:00");
            return dateTimeB.compareTo(dateTimeA);
          };
          observacoesFinal.sort(observacaoComparator);
          observacoes = observacoesFinal;
        });
      }
    });
  }

  Future<void> _getAllPesagens() async {
    List<Pesagem> pesagemFinal = List();
    await pesagemHelper.getAllPesagems().then((listaP) {
      print(listaP);
      if (listaP.isNotEmpty) {
        for (var peso in listaP) {
          if (peso.animalId == _caprinoSelecionado.idAnimal) {
            pesagemFinal.add(peso);
          }
        }
        setState(() {
          Comparator<Pesagem> pesagemComparator = (a, b) {
            DateTime dateTimeA = DateTime.parse("${a.data}" + " 00:00:00");
            DateTime dateTimeB = DateTime.parse("${b.data}" + " 00:00:00");
            return dateTimeB.compareTo(dateTimeA);
          };
          pesagemFinal.sort(pesagemComparator);
          pesagemFinal.forEach((Pesagem item) {
            print('${item.idPesagem} - ${item.data} - ${item.peso}');
          });
          pesos = pesagemFinal;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _caprinoSelecionado = Animal.fromMap(widget.caprino.toMap());
    _dataComSplit = _caprinoSelecionado.dataNascimento.split("-");
    if (_caprinoSelecionado.idCategoria != null) {
      _getAllCategorias();
    }
    _getAllRacas();
    _getAllTratamentos();
    _getAllObservacoes();
    _getAllPesagens();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text("Informações Sobre Caprino"),
            centerTitle: true,
            bottom: TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: "Informações"),
                Tab(text: "Tratamentos"),
                Tab(text: "Pesagens"),
                Tab(text: "Observações"),
              ],
            ),
          ),
          floatingActionButton: SpeedDial(
            marginRight: 18,
            marginBottom: 20,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            visible: true,
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            onOpen: () => print('OPENING DIAL'),
            onClose: () => print('DIAL CLOSED'),
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 8.0,
            shape: CircleBorder(),
            children: [
              SpeedDialChild(
                child: Icon(MdiIcons.needle),
                backgroundColor: Colors.green,
                label: 'Tratamento',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () async {
                  TratamentoPage novoTratamento = TratamentoPage(
                    tratamento: null,
                    animalId: _caprinoSelecionado.idAnimal,
                  );
                  final recTratamento = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => novoTratamento));
                  if (recTratamento != null) {
                    if (_caprinoSelecionado != null) {
                      tratamentoHelper.saveTratamento(recTratamento);
                      _getAllTratamentos();
                    }
                  }
                },
              ),
              SpeedDialChild(
                child: Icon(MdiIcons.weightKilogram),
                backgroundColor: Colors.green,
                label: 'Pesagem',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () async {
                  PesagemPage novaPesagem = PesagemPage(
                    peso: null,
                    animalId: _caprinoSelecionado.idAnimal,
                  );
                  final recPesagem = await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => novaPesagem));
                  if (recPesagem != null) {
                    if (_caprinoSelecionado != null) {
                      pesagemHelper.savePesagem(recPesagem);
                      _getAllPesagens();
                    }
                  }
                },
              ),
              SpeedDialChild(
                child: Icon(MdiIcons.cashUsd),
                backgroundColor: Colors.green,
                label: 'Venda',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () async {
                  final recEvento = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VendaPage(
                                animalVenda: _caprinoSelecionado,
                              )));
                  if (recEvento != null) {
                    print(recEvento);
                    if (_caprinoSelecionado != null) {
                      await animalHelper.updateAnimal(recEvento);
                    }
                  }
                },
              ),
              SpeedDialChild(
                child: Icon(MdiIcons.skullCrossbones),
                backgroundColor: Colors.green,
                label: 'Morte',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () async {
                  final recEvento = await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MortePage(
                                animalMorte: _caprinoSelecionado,
                              )));
                  if (recEvento != null) {
                    if (_caprinoSelecionado != null) {
                      animalHelper.updateAnimal(recEvento);
                    }
                  }
                },
              ),
              SpeedDialChild(
                child: Icon(MdiIcons.alert),
                backgroundColor: Colors.green,
                label: 'Observações',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () async {
                  ObservacaoPage obs = ObservacaoPage(
                    observacao: null,
                    animalId: _caprinoSelecionado.idAnimal,
                  );
                  final recObservacao = await Navigator.push(
                      context, MaterialPageRoute(builder: (context) => obs));
                  if (recObservacao != null) {
                    if (_caprinoSelecionado != null) {
                      observacaoHelper.saveObservacao(recObservacao);
                      _getAllObservacoes();
                    }
                  }
                },
              ),
            ],
          ),
          body: TabBarView(
            children: [
              Container(
                padding: EdgeInsets.all(13.0),
                child: ListView(
                  children: [
                    Column(
                      children: <Widget>[
                        GestureDetector(
                          child: Container(
                            width: 140.0,
                            height: 140.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: _caprinoSelecionado.img != null
                                      ? FileImage(File(_caprinoSelecionado.img))
                                      : AssetImage("images/caprino.png"),
                                  fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                    _informacoesAnimal(_caprinoSelecionado),
                  ],
                ),
              ),
              ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: tratamentos.length,
                itemBuilder: (context, index) {
                  return exibicaoPadraoDeEvento(
                      context, index, tratamentos, 1, 3);
                },
              ),
              ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: pesos.length,
                itemBuilder: (context, index) {
                  if (index < pesos.length - 1) {
                    if (int.parse(pesos[index].peso) <
                        int.parse(pesos[index + 1].peso)) {
                      return exibicaoPadraoDeEvento(
                          context, index, pesos, 2, 1);
                    } else if (int.parse(pesos[index].peso) >
                        int.parse(pesos[index + 1].peso)) {
                      return exibicaoPadraoDeEvento(
                          context, index, pesos, 2, 0);
                    } else {
                      return exibicaoPadraoDeEvento(
                          context, index, pesos, 2, 2);
                    }
                  } else {
                    return exibicaoPadraoDeEvento(context, index, pesos, 2, 2);
                  }
                },
              ),
              ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: observacoes.length,
                itemBuilder: (context, index) {
                  return exibicaoPadraoDeEvento(
                      context, index, observacoes, 3, 3);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // tipos podem ser 1 - tratamento 3- pesagem  2 Observacao
  //aumentou  1 -  0 -  abaixou  2-   manteve 3- ignora
  Padding exibicaoPadraoDeEvento(
      BuildContext context, int index, List lista, int tipo, int aumentou) {
    bool isExpanded = false;
    Text selected;
    IconData iconeSelecionado;
    dynamic exibeLateral;
    String data = "";
    switch (tipo) {
      case 1:
        List<String> dataEventoComSplit =
            lista[index].dataTratamento.split("-");
        iconeSelecionado = MdiIcons.needle;
        selected = Text(lista[index].medicacao);
        exibeLateral = calculoDiasRestantes(
            dataEventoComSplit[2],
            dataEventoComSplit[1],
            dataEventoComSplit[0],
            lista[index].periodoCarencia);
        data = exibicaoDataPadrao(lista[index].dataTratamento);
        break;
      case 3:
        iconeSelecionado = MdiIcons.alert;
        selected = Text(lista[index].descricao);
        exibeLateral = Icon(Icons.arrow_drop_down);
        data = exibicaoDataPadrao(lista[index].data);
        break;
      case 2:
        iconeSelecionado = MdiIcons.weightKilogram;
        selected = Text(lista[index].peso + " Kg");
        data = exibicaoDataPadrao(lista[index].data);
        switch (aumentou) {
          case 0:
            exibeLateral = Icon(
              Icons.trending_up,
              color: Colors.green,
            );
            break;
          case 1:
            exibeLateral = Icon(
              Icons.trending_down,
              color: Colors.red,
            );
            break;
          case 2:
            exibeLateral = Icon(Icons.trending_flat);
            break;

          default:
        }
        break;
      case 4:
        iconeSelecionado = MdiIcons.cashUsd;
        break;
      case 5:
        iconeSelecionado = MdiIcons.skullCrossbones;
        break;
      default:
    }
    return Padding(
      padding: const EdgeInsets.only(
        top: 5.0,
        left: 16.0,
        right: 70.0,
      ),
      child: Material(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: GroovinExpansionTile(
          defaultTrailingIconColor: Colors.green,
          trailing: exibeLateral,
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Icon(
              iconeSelecionado,
              color: Colors.white,
            ),
          ),
          title: Text(data),
          subtitle: selected,
          onExpansionChanged: (value) {
            setState(() {
              isExpanded = value;
            });
          },
          inkwellRadius: !isExpanded
              ? BorderRadius.all(Radius.circular(8.0))
              : BorderRadius.only(
                  topRight: Radius.circular(8.0),
                  topLeft: Radius.circular(8.0),
                ),
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5.0),
                bottomRight: Radius.circular(5.0),
              ),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () {
                            _excluirEvento(lista[index], tipo, lista, index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showCadastroPage(
                                evento: lista[index],
                                tipo: tipo,
                                idAnimal: lista[index].animalId);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            _showEventoPage(
                              evento: lista[index],
                              tipo: tipo,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _excluirEvento(dynamic evento, int tipo, dynamic lista, int index) {
    dynamic op;
    if (tipo == 1) {
      op = new TratamentoHelper();
    } else if (tipo == 2) {
      op = new PesagemHelper();
    } else {
      op = new ObservacaoHelper();
    }
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Deseja Excluir o Evento?"),
            content: Text(
                "Se excluir todos os dados sobre o evento serão excluídos."),
            actions: <Widget>[
              FlatButton(
                child: Text("Não"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: () {
                  delete(op, tipo, evento, lista, index);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  void delete(
      dynamic helper, int tipo, dynamic evento, dynamic lista, int index) {
    if (tipo == 1) {
      helper.deleteTratamento(evento.idTratamento);
      setState(() {
        lista.removeAt(index);
      });
      _getAllTratamentos();
    } else if (tipo == 2) {
      helper.deletePesagem(evento.idPesagem);
      setState(() {
        lista.removeAt(index);
      });
      _getAllPesagens();
    } else {
      helper.deleteObservacao(evento.idObservacao);
      setState(() {
        lista.removeAt(index);
      });
      _getAllObservacoes();
    }
  }

  void _showEventoPage({dynamic evento, int tipo}) async {
    dynamic op = VisualizarEvento(
      evento: evento,
      tipoEvento: tipo,
    );
    await Navigator.push(context, MaterialPageRoute(builder: (context) => op));
  }

  void _showCadastroPage({dynamic evento, int tipo, int idAnimal}) async {
    dynamic op;
    if (tipo == 1) {
      op = new TratamentoPage(tratamento: evento, animalId: idAnimal);
    } else if (tipo == 2) {
      op = new PesagemPage(peso: evento, animalId: idAnimal);
    } else {
      op = new ObservacaoPage(observacao: evento, animalId: idAnimal);
    }
    final recEvento = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => op));
    if (recEvento != null) {
      if (evento != null && tipo == 1) {
        await tratamentoHelper.updateTratamento(recEvento);
      } else if (evento != null && tipo == 2) {
        await pesagemHelper.updatePesagem(recEvento);
      } else if (evento != null && tipo == 3) {
        await observacaoHelper.updateObservacao(recEvento);
      }

      _getAllTratamentos();
      _getAllObservacoes();
      _getAllPesagens();
    }
  }

  Widget _informacoesAnimal(Animal caprinoSelecionado) {
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(''),
        ),
        DataColumn(
          label: Text(''),
        ),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text("Patrimônio")),
          DataCell(Text(ehvazio(_caprinoSelecionado.patrimonio)))
        ]),
        DataRow(cells: [
          DataCell(Text("Brinco")),
          DataCell(Text(ehvazio(_caprinoSelecionado.brincoControle)))
        ]),
        DataRow(cells: [
          DataCell(Text("ID")),
          DataCell(Text(_caprinoSelecionado.idAnimal.toString()))
        ]),
        DataRow(cells: [
          DataCell(Text("Idade")),
          DataCell(
            Text(
              idadeAnimal(_dataComSplit[0], _dataComSplit[1]),
            ),
          ),
        ]),
        DataRow(cells: [
          DataCell(Text("Nome")),
          DataCell(Text(ehvazio(_caprinoSelecionado.nome)))
        ]),
        DataRow(cells: [
          DataCell(Text("Sexo")),
          DataCell(Text(_caprinoSelecionado.sexo))
        ]),
        DataRow(cells: [
          DataCell(Text("Categoria")),
          DataCell(Text(ehvazio(categoriaSelecionada)))
        ]),
        DataRow(
            cells: [DataCell(Text("Raça")), DataCell(Text(racaSelecionada))]),
        DataRow(cells: [
          DataCell(
              Text(exibicaoDataPadrao(_caprinoSelecionado.dataNascimento))),
          DataCell(Text("Nascimento")),
        ]),
      ],
    );
  }
}
