import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'karaoke_seekbar.dart';
import 'package:rxdart/rxdart.dart' as rxdart;

class MusicDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final Color color;
  final String img;
  final String songUrl;

  const MusicDetailPage(
      {Key? key,
      required this.title,
      required this.description,
      required this.color,
      required this.img,
      required this.songUrl})
      : super(key: key);
  @override
  _MusicDetailPageState createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage>
    with SingleTickerProviderStateMixin {
  AudioPlayer? audioPlayer = AudioPlayer();
  double _currentSliderValue = 0;
  int playProgress = 0;
  double max_value = 211658;
  bool isTap = false;

  bool isPlaying = false;
  bool firstTimePlay = true;

  @override
  void initState() {
    super.initState();
  }

  Stream<SeekBarData> get _seekBarDataSteam =>
      rxdart.Rx.combineLatest2<Duration, Duration, SeekBarData>(
          audioPlayer!.onPositionChanged, audioPlayer!.onDurationChanged, (
        Duration position,
        Duration? duration,
      ) {
        return SeekBarData(position, duration ?? Duration.zero);
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
          audioPlayer?.stop();
          audioPlayer = AudioPlayer();
          setState(() {
            isPlaying = false;
            firstTimePlay = true;
          });
        },
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "NOW LISTENING",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Icon(Icons.music_note),
          ],
        ),
      ),
    );
  }

  var playing = false;

  Widget getBody() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.network(
          widget.img,
          fit: BoxFit.cover,
        ),
        ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white,
                  Colors.white.withOpacity(0.5),
                  Colors.white.withOpacity(0.0),
                ],
                stops: const [
                  0.0,
                  0.4,
                  0.6
                ]).createShader(rect);
          },
          blendMode: BlendMode.dstOut,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.black.withOpacity(0.8),
                  Colors.black,
                ])),
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder<SeekBarData>(
                  stream: _seekBarDataSteam,
                  builder: (context, snapshot) {
                    final positionData = snapshot.data;
                    return SeekBar(
                      position: positionData?.position ?? Duration.zero,
                      duration: positionData?.duration ?? Duration.zero,
                      onChangedEnd: audioPlayer!.seek,
                    );
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 29,
                    backgroundColor: Colors.white.withOpacity(0.0),
                    child: IconButton(
                      icon: Icon(
                        Icons.pause,
                        color: isPlaying ? Colors.white : Colors.grey,
                        size: 30,
                      ),
                      onPressed: () async {
                        if (isPlaying == false || firstTimePlay == true) return;
                        audioPlayer?.pause();
                        setState(() {
                          isPlaying = false;
                        });
                      },
                    ),
                  ),
                  Container(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white.withOpacity(0.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.0),
                      radius: 29,
                      child: IconButton(
                          icon: Icon(
                            Icons.play_arrow,
                            color: isPlaying ? Colors.green : Colors.white,
                            size: 30,
                          ),
                          onPressed: () async {
                            if (isPlaying == false && firstTimePlay == true) {
                              audioPlayer = AudioPlayer()
                                ..play(UrlSource(widget.songUrl));
                              setState(() {
                                isPlaying = true;
                                firstTimePlay = false;
                              });
                              audioPlayer?.onDurationChanged
                                  .listen((Duration event) {
                                setState(() {
                                  max_value = event.inMilliseconds.toDouble();
                                });
                              });
                              audioPlayer?.onPositionChanged
                                  .listen((Duration event) {
                                if (isTap) return;
                                setState(() {
                                  playProgress = event.inMilliseconds;
                                });
                              });
                              audioPlayer?.onPlayerStateChanged
                                  .listen((PlayerState state) {
                                setState(() {
                                  playing = state == PlayerState.playing;
                                });
                              });
                            } else if (isPlaying == false &&
                                firstTimePlay == false) {
                              audioPlayer?.resume();
                              setState(() {
                                isPlaying = true;
                              });
                            }
                          }),
                    ),
                  ),
                  Container(
                    width: 10,
                  ),
                  CircleAvatar(
                    radius: 29,
                    backgroundColor: Colors.white.withOpacity(0.0),
                    child: IconButton(
                        icon: Icon(
                          Icons.stop,
                          color: isPlaying ? Colors.white : Colors.grey,
                          size: 30,
                        ),
                        onPressed: () async {
                          if (isPlaying == false || firstTimePlay == true)
                            return;
                          audioPlayer?.stop();
                          audioPlayer = AudioPlayer();
                          setState(() {
                            isPlaying = false;
                            firstTimePlay = true;
                          });
                        }),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
