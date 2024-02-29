import 'package:flutter/material.dart';
import 'main.dart';

void main() {
  runApp(const Compare());
}

class Compare extends StatelessWidget {
  const Compare({Key? key}) : super(key: key);

  static Future<Map<String, dynamic>> getWeather(String city) async {
    WeatherHomePage weather = WeatherHomePage();
    return weather.fetchWeather(city);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Comparatif de Température',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          backgroundColor: const Color(0xFF64C0D4), // Background color
          cardColor: const Color(0xFFFFFFFF), // Card color
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const ComparatifPage(),
    );
  }
}

class ComparatifPage extends StatefulWidget {
  const ComparatifPage({Key? key}) : super(key: key);

  @override
  _ComparatifPageState createState() => _ComparatifPageState();
}

class _ComparatifPageState extends State<ComparatifPage> {
  String villeA = '';
  String villeB = '';
  String tempVilleA = 'Ville A';

  String tempVilleB = 'Ville B';
  double temperatureA = 0.0;
  double temperatureB = 0.0;
  String differenceTemperature = "0";
  String previsions = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Comparatif de Température',
          style: TextStyle(color: Colors.black),
        ), // Set text color to black
      ),
      body: Center(
        child: Card(
          elevation: 4,
          margin: EdgeInsets.all(16),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  onChanged: (value) {
                    setState(() {
                      villeA = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Ville A',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      villeB = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Ville B',
                    labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // Utilisez async/await pour attendre que les données météo soient récupérées
                      final weatherDataA = await Compare.getWeather(villeA);
                      final weatherDataB = await Compare.getWeather(villeB);

                      // Mettez à jour les variables temperatureA et temperatureB avec les données météo
                      setState(() {
                        temperatureA = weatherDataA['main']['temp'];
                        temperatureB = weatherDataB['main']['temp'];
                        // ... Autres mises à jour nécessaires
                        tempVilleA = villeA.isNotEmpty ? villeA : tempVilleA;
                        tempVilleB = villeB.isNotEmpty ? villeB : tempVilleB;
                        differenceTemperature = (temperatureA - temperatureB)
                            .abs()
                            .toStringAsFixed(2);
                        previsions = 'Ensoleillé';
                      });
                    } catch (e) {
                      print(
                          'Erreur lors de la récupération des données météo : $e');
                    }
                  },
                  // Remplacer les noms des villes dans le tableau

                  child: Text('Comparer'),
                  style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).colorScheme.primary,
                    onPrimary: Colors.black,
                  ),
                ),
                SizedBox(height: 20.0),
                Table(
                  border: TableBorder.symmetric(
                    inside: BorderSide(color: Colors.black),
                    outside: BorderSide(color: Colors.black),
                  ),
                  children: [
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            color: Color(0xFF668E97),
                            padding: EdgeInsets.all(8.0),
                            child: Text('$tempVilleA',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            color: Color(0xFF668E97),
                            padding: EdgeInsets.all(8.0),
                            child: Text('$tempVilleB',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            color: Color(0xFF668E97),
                            padding: EdgeInsets.all(8.0),
                            child: Text('$temperatureA °C',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            color: Color(0xFF668E97),
                            padding: EdgeInsets.all(8.0),
                            child: Text('$temperatureB °C',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            color: Color(0xFF668E97),
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                'Différence de température:',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            alignment: Alignment.center,
                            color: Color(0xFF668E97),
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                '$differenceTemperature °C',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Action à effectuer lors du clic sur le bouton
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    MyApp()), // Remplacez YourNextPage() par le fichier Dart que vous souhaitez ouvrir
          );
        },
        child: Icon(Icons.arrow_back),
        backgroundColor: Colors.deepPurple, // Couleur de fond du bouton
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endDocked, // Ajustez la position du bouton si nécessaire
    );
  }
}
