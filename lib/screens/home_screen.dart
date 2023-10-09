import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:places_to_visit/model/place.dart';
import 'package:places_to_visit/screens/cities.dart';
import 'package:places_to_visit/screens/favorites.dart';
import 'package:places_to_visit/screens/home_details_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomePage> {
  List<Place> place = [];
  int page = 1;

  Future<List<Place>> getData() async {
    late List<Place> list;
    String link = "https://acikveri.kayseri.bel.tr/api/kbb/kayseri";
    var res = await http
        .get(Uri.parse(link), headers: {"Accept": "application/json"});
    print(res.body);
    if (res.statusCode == 200) {
      var data = json.decode(res.body);
      var rest = data as List;
      print(rest);
      list = rest.map<Place>((json) => Place.fromJson(json)).toList();
    }
    print("List Size: ${list.length}");
    return list;
  }

  Future<String> getWeatherData() async {
    // Hava durumu verisi
    String weatherLink = "https://api.openweathermap.org/data/2.5/weather?q=Kayseri&appid=YOUR_API_KEY";
    var weatherRes = await http.get(Uri.parse(weatherLink));
    var weatherData = json.decode(weatherRes.body);
    return "Hava Durumu: ${weatherData['main']['temp']}°C";
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(252, 161, 151, 1),
        title: Text("Kayseri"),
      ),
      body: FutureBuilder(
        // Verilerin yüklenmesindeki sürede yükleniyor ibaresi eklentisi
        future: getData(),
        builder: (context, snapshot) {
          return snapshot.data != null
              ? listViewWidget(snapshot.data!)
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromRGBO(252, 161, 151, 1),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Yükleniyor...',
                        style: TextStyle(
                          color: Color.fromRGBO(252, 161, 151, 1),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(252, 161, 151, 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Kayseri'ye Hoş Geldiniz!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 8),
                  FutureBuilder(
                    // hava durumu verisinin alındığı yer
                    future: getWeatherData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                          'Hava durumu bilgisi alınamıyor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        );
                      } else {
                        return Text(
                          snapshot.data.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 16),
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(252, 161, 151, 1)),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Favorilerim'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => FavoritesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.location_city_rounded),
              title: Text('Şehir seç'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => CitiesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.auto_awesome_outlined),
              title: Text('Hakkımızda'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => CitiesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.headset_mic_outlined),
              title: Text('İletişim'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => CitiesPage(),
                  ),
                );
              },
            ),
            SizedBox(
              height: 250,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Bizi sosyal medyadan takip edebilirsiniz...',
                  style: TextStyle(fontSize: 15),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(FontAwesomeIcons.facebook),
                  Icon(FontAwesomeIcons.twitter),
                  Icon(FontAwesomeIcons.instagram),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listViewWidget(List<Place> place) {
    return ListView.builder(
      itemCount: place.length,
      itemBuilder: (context, position) {
        return Card(
          color: Color.fromRGBO(250, 189, 182, 1),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeDetail(place: place[position]),
                ),
              );
            },
            child: Container(
              height: 80,
              child: Center(
                child: ListTile(
                  title: Text(
                    '${place[position].title}',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  leading: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: SizedBox(),
                  ),
                  trailing: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
