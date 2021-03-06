import 'package:cine/src/pages/home_page.dart';
import 'package:cine/src/pages/pelicula_detalle.dart';
import 'package:flutter/material.dart';

 
void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peliculas',
      initialRoute: '/',
      routes: {
        '/'       : ( BuildContext context ) => HomePage(),
        'detalle' : (BuildContext context) => PeliculaDetalle(),
      },
    );
  }
}


