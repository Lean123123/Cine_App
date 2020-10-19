import 'dart:async';
import 'dart:convert';
import 'package:cine/src/models/actores_model.dart';
import 'package:cine/src/models/pelicula_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProvider {
  
  String _apikey = 'b0b242a2b558f884427ec86802c6db9e';
  String _url = 'api.themoviedb.org';
  String _lenguage = 'es-ES';

  int _popularesPage = 0;
  bool _cargando = false;

  List<Pelicula> _populares = new List();

  final _popularesStreamControler = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamControler.sink.add;

  Stream<List<Pelicula>> get popularesStream => _popularesStreamControler.stream;
 

  void disposeStreams(){
    _popularesStreamControler?.close();
  }


  Future<List<Pelicula>> _procesarRespuesta(Uri url) async{

    final resp =  await http.get( url );
     final decodedData = json.decode(resp.body);


      final peliculas = new Peliculas.fromJsonList(decodedData['results']);


     return peliculas.items;

  }


    Future <List<Pelicula>> getEnCines() async{

     final url = Uri.https(_url, '3/movie/now_playing', {
       'api_key' : _apikey,
       'lenguage' : _lenguage,
     });

     return await _procesarRespuesta(url);

  }

    Future <List<Pelicula>> getPopulares() async{

    if (_cargando) return [];

    _cargando = true;

    _popularesPage++;

    final url = Uri.https(_url, '3/movie/popular', {
       'api_key' : _apikey,
       'lenguage' : _lenguage,
       'page' : _popularesPage.toString(),
     });

        final resp = await _procesarRespuesta(url);

        _populares.addAll(resp);
        popularesSink(_populares);

        _cargando = false;

        return resp;


  }


    Future<List<Actor>> getCast(String peliId) async{
      final url = Uri.http(_url, '3/movie/$peliId/credits',{
          'api_key' : _apikey,
          'lenguage' : _lenguage,
      });

      final resp = await http.get(url);
      final decodedData = json.decode( resp.body );

      final cast = new Cast.fromJsonList(decodedData['cast']);

      return cast.actores;
    }

    Future <List<Pelicula>> buscarPelicula(String query) async{

     final url = Uri.https(_url, '3/search/movie', {
       'api_key' : _apikey,
       'lenguage' : _lenguage,
       'query' : query
     });

     return await _procesarRespuesta(url);

  }
}