import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'compare.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  // Effectuez d'autres opérations asynchrones si nécessaire

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Météo app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.deepPurple,
          backgroundColor: const Color(0xFF64C0D4),
          cardColor: const Color(0xFF64C0D4),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({Key? key});

  @override
  _WeatherHomePageState createState() => _WeatherHomePageState();

  Future<Map<String, dynamic>> fetchCoordinates(
      String cityName, String apiKey) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      var latitude = data['coord']['lat'];
      var longitude = data['coord']['lon'];

      return {
        'latitude': latitude.toString(),
        'longitude': longitude.toString()
      };
    } else {
      throw Exception('Failed to load city coordinates');
    }
  }

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    var apiKey = dotenv.env['OPENWEATHERMAP_API_KEY'];
    if (apiKey == null) apiKey = '8ff6f329fea23ce9dac43c09be14db60';
    final coords = await fetchCoordinates(city, apiKey);
    final requestUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=${coords['latitude']}&lon=${coords['longitude']}&exclude=hourly,minutely,current&appid=$apiKey&units=metric';
    print("LA REQUETE :" +
        requestUrl +
        " latitude :" +
        coords['latitude'] +
        " longitute : " +
        coords['longitude']);
    final response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  late String city = 'Paris'; // La valeur initiale
  int? temperature;
  List<Map<String, dynamic>> forecast = [];
  TextEditingController cityController = TextEditingController(
      text: "Paris"); // Contrôleur avec "Paris" par défaut

  @override
  void initState() {
    super.initState();
    updateWeatherData(city);
  }

  Future<void> updateWeatherData(String city) async {
    try {
      final weatherData = await fetchWeather(city);
      final weatherData2 = await fetchWeather("Arras");
      final weatherData3 = await fetchWeather("Lille");

      setState(() {
        this.city = city;
        this.temperature = weatherData['main']['temp'].round();
        this.forecast = [
          {
            'ville': '${weatherData['name']}',
            'min_temperature': '${weatherData['main']['temp_min']}',
            'max_temperature': '${weatherData['main']['temp_max']}',
            'meteo': '${weatherData['weather'][0]['main']}'
          },
          {
            'ville': '${weatherData2['name']}',
            'min_temperature': '${weatherData2['main']['temp']}',
            'max_temperature': '${weatherData2['main']['temp']}',
            'meteo': '${weatherData2['weather'][0]['main']}'
          },
          {
            'ville': '${weatherData3['name']}',
            'min_temperature': '${weatherData3['main']['temp']}',
            'max_temperature': '${weatherData3['main']['temp']}',
            'meteo': '${weatherData3['weather'][0]['main']}'
          },
          // Add more forecast data as needed
        ];
      });
    } catch (e) {
      print(e);
      // Gérer l'erreur ou afficher un message à l'utilisateur
    }
  }

  Future<Map<String, dynamic>> fetchCoordinates(
      String cityName, String apiKey) async {
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      var latitude = data['coord']['lat'];
      var longitude = data['coord']['lon'];

      return {
        'latitude': latitude.toString(),
        'longitude': longitude.toString()
      };
    } else {
      throw Exception('Failed to load city coordinates');
    }
  }

  Future<Map<String, dynamic>> fetchWeather(String city) async {
    var apiKey = dotenv.env['OPENWEATHERMAP_API_KEY'];
    if (apiKey == null) apiKey = '8ff6f329fea23ce9dac43c09be14db60';
    final coords = await fetchCoordinates(city, apiKey);
    final requestUrl =
        'https://api.openweathermap.org/data/2.5/weather?lat=${coords['latitude']}&lon=${coords['longitude']}&exclude=hourly,minutely,current&appid=$apiKey&units=metric';
    print("LA REQUETE :" +
        requestUrl +
        " latitude :" +
        coords['latitude'] +
        " longitute : " +
        coords['longitude']);
    final response = await http.get(Uri.parse(requestUrl));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text('Météo à $city', style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Container(
          width: 400,
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller:
                        cityController, // Utilisez le même TextEditingController que pour l'exemple AppBar
                    decoration: InputDecoration(
                      hintText: "Entrez le nom d'une ville",
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      // Centre le texte
                    ),
                    textAlign: TextAlign.center,
                    onSubmitted: (value) {
                      setState(() {
                        city =
                            value; // Met à jour la ville avec la valeur entrée
                        updateWeatherData(
                            city); // Met à jour les données météo pour la nouvelle ville
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  SizedBox(height: 16),
                  DataTable(
                    dataRowHeight:
                        60, // Set the desired height for each DataRow
                    columns: const [
                      DataColumn(
                          label: Text('Ville', style: TextStyle(fontSize: 20))),
                      DataColumn(
                          label: Text('Température',
                              style: TextStyle(fontSize: 20))),
                      DataColumn(
                          label: Text('Météo', style: TextStyle(fontSize: 20))),
                    ],
                    rows: forecast
                        .map(
                          (day) => DataRow(
                            cells: [
                              DataCell(
                                Center(
                                  child: Text(
                                    day['ville'].toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${day['min_temperature']}°C - ${day['max_temperature']}°C',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DataCell(
                                Center(
                                  child: Text(
                                    day['meteo'].toString(),
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
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
                    Compare()), // Remplacez YourNextPage() par le fichier Dart que vous souhaitez ouvrir
          );
        },
        child: Icon(Icons.arrow_forward),
        backgroundColor: Colors.deepPurple, // Couleur de fond du bouton
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation
          .endDocked, // Ajustez la position du bouton si nécessaire
    );
  }
}
