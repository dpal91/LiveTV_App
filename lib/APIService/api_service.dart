import 'package:http/http.dart' as http;

class APIService {
  static var noImage = "https://buddytv.netlify.app/img/no-logo.png";
  static fetchPlaylist(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.body; // raw m3u text
    } else {
      throw Exception('Failed to load playlist');
    }
  }
}
