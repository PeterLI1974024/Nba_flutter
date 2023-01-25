import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'reusable card/neubox.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/player_card.dart';
import 'models/player_datail.dart';
import 'reusable card/neutext.dart';
import 'reusable card/sizebox.dart';

class InfoCard extends StatefulWidget {
  final playerId;
  final playerName;
  InfoCard({this.playerId, this.playerName});

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  List<PlayerDetail> wholeDetail = [];
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
    setState(() {});
  }

  Future getPlayerDetail() async {
    var response = await http.get(Uri.parse(
        'https://api.sportsdata.io/v3/nba/scores/json/Player/${widget.playerId}?key=$apiKey'));
    var playerDetails = jsonDecode(response.body);

    var playerDetail = PlayerDetail(
      name: playerDetails['DraftKingsName'],
      salary: playerDetails['Salary'].toString(),
      height: playerDetails['Height'] * 2.54,
      weight: playerDetails['Weight'] / 2.2,
      birth: playerDetails['BirthDate'],
    );

    wholeDetail.add(playerDetail);
    setState(() {});
  }

  @override
  void initState() {
    getHeadShots();
    getPlayerDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          Container(
            height: 450,
            width: 500,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 169, 174, 164),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
          ),
          SafeArea(
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
                              ))
                          : Hero(
                              tag: 'picture',
                              child: Center(
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
                            ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        (wholeDetail.length > 0 ? wholeDetail[0].name : ''),
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )),
                  const SizedBox(
                    height: 25,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cake,
                            color: Color.fromARGB(255, 118, 81, 79),
                            size: 30,
                          ),
                          NeuText(
                              text: 'Birth:',
                              text1: ' ' +
                                  (wholeDetail.length > 0
                                      ? wholeDetail[0].birth.substring(0, 10)
                                      : ''),
                              text2: ' b.c'),
                        ],
                      ),
                      Sizebox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.height,
                            color: Colors.red,
                            size: 30,
                          ),
                          NeuText(
                              text: 'Height:',
                              text1: ' ' +
                                  (wholeDetail.length > 0
                                      ? wholeDetail[0].height.toStringAsFixed(2)
                                      : ''),
                              text2: ' cm')
                        ],
                      ),
                      Sizebox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.line_weight,
                            color: Color.fromARGB(255, 177, 114, 109),
                            size: 30,
                          ),
                          NeuText(
                              text: 'Weight:',
                              text1: ' ' +
                                  (wholeDetail.length > 0
                                      ? wholeDetail[0].weight.toStringAsFixed(2)
                                      : ''),
                              text2: ' kg'),
                        ],
                      ),
                      Sizebox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: Colors.amber,
                            size: 30,
                          ),
                          NeuText(
                              text: 'Salary:',
                              text1: ' ' +
                                  (wholeDetail.length > 0
                                      ? wholeDetail[0].salary
                                      : ' '),
                              text2: ' USD'),
                        ],
                      ),
                      Sizebox(),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
