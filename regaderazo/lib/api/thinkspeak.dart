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
    // TODO: Mine EADNROT3DL06KNSR field 1
    // TODO: Tsip HXXCY391D2TWZCYY field 2
    Uri path = Uri.parse('https://api.thingspeak.com/update?api_key=EADNROT3DL06KNSR&field1=' + temp);
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
    // TODO: Mine YWOJUI2OQGO78WME
    // TODO: Tsip GMT4V4X3NB4L14X4
    Uri path = Uri.parse('https://api.thingspeak.com/channels/1916671/feeds.json?api_key=GMT4V4X3NB4L14X4&results');
    var response = await http.get(path);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  }

  /* Future<dynamic> getTemp() async {
    Uri path = Uri.parse('https://api.thingspeak.com/channels/1934178/fields/1.json?api_key=YWOJUI2OQGO78WME&results');
    var response = await http.get(path);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Failed to load data');
    }
  } */

  Future<dynamic> getFlujo() async {
    // TODO: Mine YWOJUI2OQGO78WME
    // TODO: Tsip GMT4V4X3NB4L14X4
    // https://api.thingspeak.com/channels/1916671/fields/1.json?api_key=GMT4V4X3NB4L14X4&results
    Uri path = Uri.parse('https://api.thingspeak.com/channels/1916671/fields/1.json?results=');
    var response = await http.get(path);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(data);
      return data;
    /*
    var response = await http.get(path);
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      Map map = data;
      List list = map['feeds'];
      List<Map<String, dynamic>> listFull = list.map((e) => e as Map<String, dynamic>).toList();
      return listFull.last;
    */
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<dynamic> getTemp() async {
    // TODO: Mine YWOJUI2OQGO78WME field 1
    // TODO: Tsip GMT4V4X3NB4L14X4 field 2
    // https://api.thingspeak.com/channels/1916671/fields/2.json?api_key=GMT4V4X3NB4L14X4&results
    Uri path = Uri.parse('https://api.thingspeak.com/channels/1916671/fields/2.json?results=');
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

  Future<dynamic> getValvula() async {
    // TODO: Mine YWOJUI2OQGO78WME field 3
    // TODO: Tsip GMT4V4X3NB4L14X4 field 3
    // https://api.thingspeak.com/channels/1916671/fields/3.json?api_key=GMT4V4X3NB4L14X4&results
    Uri path = Uri.parse('https://api.thingspeak.com/channels/1916671/fields/3.json?results=');
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
}