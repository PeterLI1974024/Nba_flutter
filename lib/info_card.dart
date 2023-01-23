import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'reusable card/neubox.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/player_card.dart';

class InfoCard extends StatefulWidget {
  final playerId;
  final playerName;
  InfoCard({this.playerId, this.playerName});

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  List<PlayerCard> filteredHeadShots = [];
  List<PlayerCard> playerCards = [];
  final apiKey = '89120b51e6ef4485b8172e7d466e8735';

  Future getHeadShots() async {
    var response = await http.get(Uri.parse(
        'https://api.sportsdata.io/v3/nba/headshots/json/Headshots?key=$apiKey'));
    var jsonData = jsonDecode(response.body);
    for (var eachHeadShot in jsonData) {
      final headShot = PlayerCard(
          headshot: "${eachHeadShot['PreferredHostedHeadshotUrl']}",
          id: eachHeadShot['PlayerID']);
      playerCards.add(headShot);
    }

    for (var headshot in playerCards) {
      if (headshot.id == widget.playerId) {
        filteredHeadShots.add(headshot);
      }
    }
    print(filteredHeadShots[0].headshot);

    setState(() {});
  }

  @override
  void initState() {
    getHeadShots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Player info'),
          backgroundColor: Color.fromARGB(255, 134, 133, 124),
        ),
        backgroundColor: Colors.grey[100],
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              children: [
                const SizedBox(
                  height: 25,
                ),
                NeuBox(
                    child: Column(
                  children: [
                    filteredHeadShots.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              filteredHeadShots[0].headshot,
                              // loadingBuilder: (_, __, event) {
                              //   if (event == ImageChunkEvent)
                              //   return CircularProgressIndicator();
                              // },
                            ))
                        : Center(
                            child: SpinKitWanderingCubes(
                            color: Color.fromARGB(
                              255,
                              93,
                              114,
                              69,
                            ),
                            size: 30,
                            duration: Duration(seconds: 3),
                          )),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Lebron james',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )
                  ],
                )),
                const SizedBox(
                  height: 25,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    RichText(
                        text: TextSpan(
                            text: "Salary:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            children: [
                          TextSpan(
                              text: " \$999,999,999",
                              style: TextStyle(color: Colors.black))
                        ])),
                    // Text('salary'),
                    Text('birthday'),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
