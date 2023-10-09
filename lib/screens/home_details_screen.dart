import 'package:flutter/material.dart';
import 'package:places_to_visit/model/place.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart' as map;

class HomeDetail extends StatelessWidget {
  final Place place;

  HomeDetail({required this.place});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageWidth = screenWidth * 1.0; // Resim, ekran genişliğinin tamamı
    double imageHeight = imageWidth * 0.7; // Yüksekliği, genişliğinin %70'i

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${place.title}',
          style: const TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Image.network(
                  place.bannerImage ?? "",
                  width: imageWidth,
                  height: imageHeight,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Html(data: place.content),
              SizedBox(
                height: 20,
              ),
              Text(
                'Haritadaki Konumu :',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                height: 400,
                alignment: Alignment.centerLeft,
                child: map.FlutterMap(
                  options: map.MapOptions(
                    center: LatLng(
                      double.parse(place.latitude!),
                      double.parse(place.longitude!),
                    ),
                    zoom: 10,
                  ),
                  children: [
                    map.TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                    map.MarkerLayer(
                      rotate: false,
                      anchorPos: map.AnchorPos.align(map.AnchorAlign.topLeft),
                      markers: [
                        map.Marker(
                          point: LatLng(
                            double.parse(place.latitude!),
                            double.parse(place.longitude!),
                          ),
                          width: 64,
                          height: 64,
                          anchorPos:
                              map.AnchorPos.align(map.AnchorAlign.center),
                          builder: (context) => Icon(
                            Icons.location_pin,
                            color: Colors.red[600],
                            size: 64.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
