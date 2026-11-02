import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  
import 'myapp.dart';

// this is the where the app starts
void main() async {
  await RestClient.checkHttpConnection();
  runApp(const MyApp());
}

// This is the class resposible for sending the HTTP request to the BackEnd
class RestClient {
  static const String baseUrl = 'http://localhost:8080';//'http://192.168.101.73:8080';//'http://localhost:8080'; // the ip of the RestAPI

  // constant headers to decrybe the type of the request
  static const Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };

  static Future<void> checkHttpConnection() async {
    var response = await get('/test', null);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      //print('Error: ${response.body}');
      var bodyUtf8 = utf8.decode(response.bodyBytes);
      dynamic error = jsonDecode(bodyUtf8);
      print('Error: ${error['error']}');
      print('Details: ${error['trace']}');
    }
  }

  static Future<String?> getLoggedUser() async {
    var response = await get('/getLoggedUsername', null);
    if (response.statusCode == 200) {
      return response.body;
    } else { return null; }
  }

  static Future<String> getBio(String username) async {
    var response = await get('/getBiography', {'user': username});
    if (response.statusCode == 200) {
      return response.body;
    } else { return "Error!: ${response.body}"; }
  }

  static Future<String> setBio(String bio) async {
    var response = await get('/setBiography', {'bio': bio});
    if (response.statusCode == 200) {
      return response.body;
    } else { return "Error!: ${response.body}"; }
  }

  static Future<void> logout() async {
    await get('/logout', null);
  }

  static Future<bool?> checkLogin(String username, String password) async {
    var response = await get('/validateUser', {'name': username, 'pass': password});
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else { return null; }
  }

  static Future<bool?> checkSignup(String username, String password) async {
    var response = await get('/checkUsername', {'name': username, 'pass' : password});
    if (response.statusCode == 200) {
      return await jsonDecode(response.body);
    } else { return null; }
  }

  static Future<String?> handleSignup(String username, String password) async {
    var response = await get('/handleSignup', {'name': username, 'pass': password});
    if (response.statusCode == 200) {
      return response.body;
    } else { return null; }
  }

  static Future<String?> handleLogin(String username, String gameName) async {
    var response = await get('/handleLogin', {'name': username, 'pass': gameName});
    if (response.statusCode == 200) {
      return response.body;
    } else { return null; }
  }

  static Future<List<String>> getOpenings() async {
    var response = await get('/getOpenings', null);
    if (response.statusCode == 200) {
      return jsonDecode(response.body).cast<String>();
    } else {
      return ['Error: ${response.body}'];
    }
  }

  static Future<List<String>> getFavs(String username) async {
    var response = await get('/getFavs', {'user': username});
    if (response.statusCode == 200) {
      return jsonDecode(response.body).cast<String>();
    } else {
      return ['Error: ${response.body}'];
    }
  }

  static Future<String> getTitle(String opName) async {
    var response = await get('/getFullTitle', {'opName': opName});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Error: ${response.body}';
    }
  }

  static Future<String> getOverview(String opName) async {
    var response = await get('/getOverview', {'opName': opName});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Error: ${response.body}';
    }
  }

  static Future<String> getMoves(String opName) async {
    var response = await get('/getMoves', {'opName': opName});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Error: ${response.body}';
    }
  }

  static Future<String> getAuthor(String opName) async {
    var response = await get('/getAuthor', {'opName': opName});
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Error: ${response.body}';
    }
  }

  static Future<Map<String, String>> getVariations(String opName) async {
    var response = await get('/getVariations', {'opName': opName});
    if (response.statusCode == 200) {
      return jsonDecode(response.body).cast<String, String>();
    } else {
      return {'Error': response.body};
    }
  }

  static Future<List<String>> getExtras(String opName) async {
    var response = await get('/getExtras', {'opName': opName});
    if (response.statusCode == 200) {
      return jsonDecode(response.body).cast<String>();
    } else {
      return ['Error: ${response.body}'];
    }
  }

  static Future<void> addToFav(String opName) async {
    await get('/addToFav', {'opName': opName});
  }

  static Future<void> removeFav(String opName) async {
    await get('/removeFromFav', {'opName': opName});
  }

  static Future<bool> checkFav(String opName) async {
    var response = await get('/isFav', {'opName': opName});
    if (response.statusCode == 200) {
      print(response.body);
      return await jsonDecode(response.body);
    } else {
      return false;
    }
  }

  static Future<List<String>> getDiscovered() async {
    var response = await get('/getDiscovered', null);
    if (response.statusCode == 200) {
      return jsonDecode(response.body).cast<String>();
    } else {
      return ['Error: ${response.body}'];
    }
  }

  static Future<void> discoverOpening(String opName) async {
    await get('/discover', {'opName': opName});
  }

  // ***** METHODS FOR THE WORDLE API *****

  static Future<List<String>> getWords() async {
    var response = await get('/getWords', null);
    if (response.statusCode == 200) {
      return jsonDecode(response.body).cast<String>();
    } else {
      return ['Error: ${response.body}'];
    }
  }

  static Future<void> startGame() async {
    await get('/startGame', null);
  }

  static Future<String> getCurrentWord() async {
    var response = await get('/getCurrentWord', null);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return 'Error: ${response.body}';
    }
  }

  // the function to automatically create the uri for the request
  static Future<http.Response> get(String endpoint, Map<String, String>? data) async {
    String parameters = "";
    if (data != null) {
      parameters += "?";
      for (var pair in data.entries) {
        parameters += "${pair.key}=${pair.value}&";
      }
    }
    return await http.get(Uri.parse("$baseUrl$endpoint$parameters"),
        headers: headers);
  }
}
