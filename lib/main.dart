import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json&key=c0edaa70";

void main() async {
  runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white))))));
}

Future<Map> getData() async {
  http.Response response = await http.get(request);
  return json.decode(response.body);
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Controle de entrada do Texto
  final realController = TextEditingController();
  final dollarController = TextEditingController();
  final euroController = TextEditingController();
  final bitconContoller = TextEditingController();

  double dollar;
  double euro;
  double bitcon;

  void _realChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double real = double.parse(text);
    dollarController.text = (real / dollar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
    bitconContoller.text = (real / bitcon).toStringAsFixed(5);
  }

  void _dollarChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double dollar = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar / euro).toStringAsFixed(2);
    bitconContoller.text = (dollar * this.dollar / bitcon).toStringAsFixed(5);
  }

  void _euroChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dollarController.text = (euro * this.euro / dollar).toStringAsFixed(2);
    bitconContoller.text = (euro * this.euro / bitcon).toStringAsFixed(5);
  }

  void _bitconChange(String text) {
    if (text.isEmpty) {
      _clearAll();
      return;
    }
    double bitcon = double.parse(text);
    realController.text = (dollar * this.dollar).toStringAsFixed(2);
    euroController.text = (dollar * this.dollar / euro).toStringAsFixed(2);
    dollarController.text = (dollar * this.dollar / bitcon).toStringAsFixed(5);
  }

  void _clearAll() {
    realController.text = "";
    dollarController.text = "";
    euroController.text = "";
    bitconContoller.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando dados",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                if (snapshot.hasError) {
                  return Center(
                      child: Text(
                    "Não carregou ;(",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                } else {
                  dollar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  bitcon = snapshot.data["results"]["currencies"]["BTC"]["buy"];

                  return SingleChildScrollView(
                      padding: EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Icon(Icons.monetization_on,
                                size: 75.0, color: Colors.amber),
                            Divider(),
                            buildTextField(
                                "Real", "R\$", realController, _realChange),
                            Divider(),
                            buildTextField("Dollar", "US\$", dollarController,
                                _dollarChange),
                            Divider(),
                            buildTextField(
                                "Euro", "€", euroController, _euroChange),
                            Divider(),
                            buildTextField(
                                "BitCoin", "฿", bitconContoller, _bitconChange),
                            Divider(),
                          ]));
                }
            }
          }),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber,
    ),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal: true),
  );
}
