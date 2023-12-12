import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_api_app/ytvideo.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';


List<String> seasons = <String>['2005', '2006', '2007', '2008', '2009' ];
List<String> episodes = <String>['1'];
Future<List<YtVideo>>? videosFuture;


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),

    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var dropDownValue = seasons.first;
  var dropDownValueEp = '1';
  bool isLoaded = false;
  static String apiKey = 'AIzaSyB2H2bSPOEG-jBdmaCZVA3s3s0s7zyKgCA';
  static String videoIdString = '';


  static YoutubePlayerController _controller = YoutubePlayerController(
    initialVideoId: 'Fy4tdiwTzgY',
    flags: YoutubePlayerFlags(
      autoPlay: true,
      mute: true,
    ),
  );






   Future<List<YtVideo>> getVideos() async {
    final response = await http.get(Uri.parse('https://www.googleapis.com/youtube/v3/search?key='+ apiKey +'&q=choufli+hal+'+ dropDownValue +'+'+ dropDownValueEp + '&type=video&part=snippet'));
    final Map<String, dynamic> data = jsonDecode(response.body);


    if (data.containsKey('items')) {
      final List<dynamic> items = data['items'];
      return items.map((e) => YtVideo.fromJson(e)).toList();
    } else {
      // Handle the case where 'items' key is not present in the response.
      return [];
    }
  }

  Widget getPlayer(){
    if(videosFuture != null){
      return FutureBuilder(
          future: videosFuture,
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              //loader
              return CircularProgressIndicator();
            }else if(snapshot.hasData){
              final videos = snapshot.data!;
              return YoutubePlayerBuilder(
                player: YoutubePlayer(
                  controller: YoutubePlayerController(
                    initialVideoId: videos[0].videoId!,
                    flags: YoutubePlayerFlags(
                      autoPlay: true,
                    ),
                  ),
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: Colors.deepPurple,

                ),
                builder: (context, player){
                  return Column(
                    children: [
                      player
                    ],
                  );
                },
              );


            }else{
              //did not recieve any data
              return Text('Something not working');

            }
          }
      );
    }else{
      return Text('');
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children:[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/img/Choufli_hal.png'),
                  fit: BoxFit.fill,
                  opacity: 0.5,

                ),

              ),
            ),

              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Choufli 7al9a',
                      style: TextStyle(
                          fontSize: 50,
                        fontFamily: 'Grinched',
                        color: Colors.deepPurple
                      ),

                    ),
                    SizedBox(height: 30),
                    Text(
                      'Pick a season',
                      style: TextStyle(fontSize: 19),

                    ),
                    DropdownButton(
                      value: dropDownValue,
                      icon: Icon(Icons.arrow_downward),
                      hint: Text('Select Season'),
                      items: seasons.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: onChangedController,
                    ),
                    Text(
                      'Pick an episode',
                      style: TextStyle(fontSize: 19),

                    ),
                    DropdownButton(
                      value: dropDownValueEp,
                      icon: Icon(Icons.arrow_downward),
                      items: episodes?.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? value){
                        setState(() {
                          dropDownValueEp = value!;
                        });
                      },
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: (){
                              setState(() {
                                Random random = Random();
                                int randomSeason = random.nextInt(seasons.length);
                                dropDownValue = seasons[randomSeason];

                                onChangedController(dropDownValue);

                                int randomEpisode = random.nextInt(episodes.length);
                                dropDownValueEp = episodes[randomEpisode];

                              });
                            },
                            child: Text('Random'),
                        ),
                        SizedBox(width: 15),
                        ElevatedButton(
                          onPressed: (){
                            setState(() {
                               videosFuture = getVideos();
                            });
                          },
                          child: Text(
                              'Watch',
                              style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    getPlayer(),
                    /*YoutubePlayer(
                      controller: _controller,
                      showVideoProgressIndicator: true,
                      progressIndicatorColor: Colors.deepPurple,

                    ),*/


                  ],
                ),
              ),


          ],
        ),
      ),
    );
  }

  void onChangedController(String? value){
              setState(() {
                dropDownValue = value!;
                if(dropDownValue == '2005' || dropDownValue == '2006' || dropDownValue == '2007'){
                  episodes = List.generate(30, (index) => '${index+1}');
                }else if(dropDownValue == '2008'){
                  episodes = List.generate(28, (index) => '${index+1}');
                }else if(dropDownValue == '2009'){
                episodes = List.generate(15, (index) => '${index+1}');
              }
              });
            }


}
