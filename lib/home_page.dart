import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:httpapp/player_card.dart';
import 'package:httpapp/player_page.dart';
import 'models/team.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Team> teams = [];
  bool isSelected = false;

  // get teams
  Future getTeams() async {
    var response = await http.get(Uri.https('balldontlie.io', 'api/v1/teams'));
    var jsonData = jsonDecode(response.body);

    for (var eachTeam in jsonData['data']) {
      final team = Team(
        abbreviation: eachTeam['abbreviation'],
        city: eachTeam['city'],
        id: eachTeam['id'],
      );

      teams.add(team);
    }
    print(teams.length);
  }

  Future? _data;

  @override
  void initState() {
    _data = getTeams();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'NBA TEAMS',
        ),
        backgroundColor: Color.fromARGB(255, 121, 153, 169),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: _data,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemCount: teams.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final nbaIcon = teams[index].city;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                              child: SvgPicture.asset('images/$nbaIcon.svg')),
                          title: Text(teams[index].abbreviation),
                          subtitle: Text(teams[index].city),
                          onTap: () {
                            setState(() {
                              isSelected = true;
                            });
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return PlayerCard(
                                  teamName: teams[index].abbreviation);
                            }));
                          },
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
