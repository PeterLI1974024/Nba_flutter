import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'models/player.dart';

class PlayerCard extends StatefulWidget {
  @override
  State<PlayerCard> createState() => _PlayerCardState();

  PlayerCard({this.teamName});
  final teamName;
}

class _PlayerCardState extends State<PlayerCard> {
  List<Player> players = [];
  int statusCode = 200;
  final apiKey = '89120b51e6ef4485b8172e7d466e8735';
  Future getNewPlayers() async {
    String requestedUrl =
        'https://api.sportsdata.io/v3/nba/scores/json/Players/${widget.teamName}?key=$apiKey';

    try {
      final response = await http.get(Uri.parse(requestedUrl));
      var statusCode = response.statusCode;
      var jsonData = jsonDecode(response.body);
      print(jsonData[0]['FirstName']);
      for (var eachPlayer in jsonData) {
        final player = Player(
          name: eachPlayer['FirstName'] + ' ' + eachPlayer['LastName'],
          position: eachPlayer['Position'],
          id: eachPlayer['PlayerID'],
          conference: eachPlayer['Status'],
          picture: eachPlayer['PhotoUrl'],
        );
        players.add(player);
      }
      print(players.length);
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Player List',
        ),
        backgroundColor: Color.fromARGB(255, 85, 91, 79),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: getNewPlayers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: players.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final url = players[index].picture;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(35),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Color.fromARGB(255, 85, 91, 79),
                            backgroundImage: NetworkImage(url),
                          ),
                          title: Text(players[index].name),
                          subtitle: Text(players[index].position),
                          onTap: () {},
                        ),
                      ),
                    );
                  },
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
