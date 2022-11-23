import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class APIRepository {
  static final APIRepository _singleton = APIRepository._internal();

  factory APIRepository() {
    return _singleton;
  }

  APIRepository._internal();

  Future<dynamic> putTemp(String temp) async {
    // TODO: change field 4 to field 1
    Uri path = Uri.parse('https://api.thingspeak.com/update?api_key=EADNROT3DL06KNSR&field4=' + temp);
    var response = await http.get(path);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getAll() async {
    Uri path = Uri.parse('https://api.thingspeak.com/channels/1934178/feeds.json?api_key=YWOJUI2OQGO78WME&results');
    var response = await http.get(path);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getTemp() async {
    Uri path = Uri.parse('https://api.thingspeak.com/channels/1934178/fields/1.json?api_key=YWOJUI2OQGO78WME&results');
    var response = await http.get(path);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getPresion() async {
    Uri path = Uri.parse('https://api.thingspeak.com/channels/1934178/fields/2.json?api_key=YWOJUI2OQGO78WME&results');
    var response = await http.get(path);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getValvula() async {
    // TODO: change field 5 to field 3
    Uri path = Uri.parse('https://api.thingspeak.com/channels/1934178/fields/5.json?api_key=YWOJUI2OQGO78WME&results');
    var response = await http.get(path);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Map map = data;
      List list = map['feeds'];
      List<Map<String, dynamic>> listFull = list.map((e) => e as Map<String, dynamic>).toList();
      return listFull.last;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getTest() async {
    Uri path = Uri.parse('https://api.thingspeak.com/channels/1934178/fields/4.json?api_key=YWOJUI2OQGO78WME&results');
    var response = await http.get(path);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      //print(data);
      Map map = data;
      List list = map['feeds'];
      List<Map<String, dynamic>> listFull = list.map((e) => e as Map<String, dynamic>).toList();
      /* for (var i = 0; i < list2.length; i++) {
        print(list2[i]['field4']);
      } */
      //print("LIST $list2");
      return listFull;
    } else {
      throw Exception('Failed to load data');
    }
  }
}