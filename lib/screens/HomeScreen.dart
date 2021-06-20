import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class HomeSceen extends StatefulWidget {
  @override
  _HomeSceenState createState() => _HomeSceenState();
}

class _HomeSceenState extends State<HomeSceen> {
  //Potrzebne nam zmienne
  String value = '';
  String resultString = '';
  String currency = '--';

  //Funkcja odbierająca dane z API
  void getData() async {
    if (value != '' && currency != '--') {
      Response response =
          await get("https://api.exchangeratesapi.io/latest?base=PLN");
      String data = response.body;
      //dekodowanie danych z linku
      var resultJ = jsonDecode(data);
      //Wydobywanie wartości z API
      double selectedCountryValue = resultJ['rates'][currency];
      //Parsowanie danych ze String na double
      double userValue = double.parse(value);
      //setState pozwala na natychmiastową zmianę danych na ekranie(tylko w widgetach Statefull)
      setState(() {
        //Obliczanie finałowego rezultatu
        double resultF = userValue * selectedCountryValue;
        //Zmiana double na String z przycięciem do dwóch miejsc po przecinku
        resultString = resultF.toStringAsFixed(2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: <Widget>[
                TextField(
                  //Określenie typu klawiatury na numeryczną
                  keyboardType: TextInputType.numberWithOptions(),
                  //funkcja wywoływana po każdej zmianie wartości
                  onChanged: (input) {
                    setState(() {
                      value = input;
                    });
                  },
                ),
                Row(
                  children: <Widget>[
                    Text(value),
                    Text(" PLN"),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text(resultString),
                    //Użycie $ w cudzysłowie pozwala na użycie zmiennej
                    Text(" $currency"),
                  ],
                ),
                DropdownButton(
                  items:
                      //Mapowanie listy
                      <String>['EUR', 'USD', 'PLN', 'GBP', 'RUB', 'CZK', 'CHF']
                          .map((String value) {
                    //Każdy element z listy zwróci DropdownMenuItem
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  //Funkcja wywoływana podczas zmiany wartości
                  onChanged: (String newValue) {
                    setState(() {
                      currency = newValue;
                    });
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    getData();
                  },
                  child: Text('Przelicz PLN na wybraną walutę'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
