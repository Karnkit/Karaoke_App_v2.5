import 'dart:ui';
import 'dart:async';
import 'package:alert/alert.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lyric/lyrics_reader.dart';
import 'package:karaoke_real_one/pages/home/listen_and_record/karaoke_seekbar.dart';
import 'package:flutter/foundation.dart';
import 'package:karaoke_real_one/pages/home/listen_and_record/music_detail_page.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:record/record.dart';
import 'package:karaoke_real_one/pages/home/listen_and_record/flask_connect.dart';
import 'package:rxdart/rxdart.dart' as rxdart;
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:karaoke_real_one/fb_connect.dart';

flask_connect flask = new flask_connect();

class Singing extends StatefulWidget {
  final String song_url;
  final String img;
  final String songname;
  final List userData;
  final int index;
  final String normallyrics;

  const Singing(
      {Key? key,
      required this.song_url,
      required this.img,
      required this.songname,
      required this.userData,
      required this.index,
      required this.normallyrics})
      : super(key: key);

  @override
  _SingingState createState() => _SingingState();
}

class _SingingState extends State<Singing> with SingleTickerProviderStateMixin {
  AudioPlayer? audioPlayer = AudioPlayer();
  int playProgress = 0;
  double max_value = 211658;
  bool isTap = false;

  String? audioPath;

  int _recordDuration = 0;
  Timer? _timer;
  final _audioRecorder = Record();
  StreamSubscription<RecordState>? _recordSub;
  RecordState _recordState = RecordState.stop;
  StreamSubscription<Amplitude>? _amplitudeSub;
  Amplitude? _amplitude;

  final RoundedLoadingButtonController _btnController1 =
      RoundedLoadingButtonController();

  List newestSong = [];

  @override
  void initState() {
    _recordSub = _audioRecorder.onStateChanged().listen((recordState) {
      setState(() => _recordState = recordState);
    });

    _amplitudeSub = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 300))
        .listen((amp) => setState(() => _amplitude = amp));

    lyricModel = LyricsModelBuilder.create()
        .bindLyricToMain(widget.normallyrics)
        // .bindLyricToExt(transLyric)
        .getModel();

    super.initState();
  }

  Future<void> _start() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        // We don't do anything with this but printing
        final isSupported = await _audioRecorder.isEncoderSupported(
          AudioEncoder.aacLc,
        );
        if (kDebugMode) {
          print('${AudioEncoder.aacLc.name} supported: $isSupported');
        }

        // final devs = await _audioRecorder.listInputDevices();
        // final isRecording = await _audioRecorder.isRecording();

        await _audioRecorder.start();
        _recordDuration = 0;

        _startTimer();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> _stop(bool complete) async {
    _timer?.cancel();
    _recordDuration = 0;
    String msg;

    var path = null;
    path = await _audioRecorder.stop();

    if (complete) {
      msg = await flask.upload(path.toString(), widget.index.toString(),
          widget.userData[0]['userName'], widget.songname);
    }
  }

  Widget myMainBody(bool complete) {
    return FutureBuilder(
        future: _stop(complete),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return loadScreen();
          }
          return myNewBody();
        });
  }

  Future loadSong() async {
    List tempSong =
        await fb_connect().getLastTenSong(widget.userData[0]['userName']);
    newestSong = tempSong;
  }

  Widget myNewBody() {
    return FutureBuilder(
        future: loadSong(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return loadScreen();
          }
          return Stack(
            children: [
              MusicDetailPage(
                  title: newestSong[newestSong.length - 1]['title'],
                  description: "",
                  color: Colors.black,
                  img: newestSong[newestSong.length - 1]['img'],
                  songUrl: newestSong[newestSong.length - 1]['song_url']),
              AlertDialog(
                content: Stack(children: [
                  Text(
                    'You got ' +
                        newestSong[newestSong.length - 1]['stars'].toString() +
                        ' star(s) for this singing!',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  )
                ]),
              ),
            ],
          );
        });
  }

  Widget loadScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          color: Color.fromARGB(255, 0, 255, 8),
          size: 200,
        ),
      ),
    );
  }

  Future<void> _pause() async {
    _timer?.cancel();
    await _audioRecorder.pause();
  }

  Future<void> _resume() async {
    _startTimer();
    await _audioRecorder.resume();
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0' + numberStr;
    }

    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recordSub?.cancel();
    _amplitudeSub?.cancel();
    _audioRecorder.dispose();
    super.dispose();
  }

  bool useEnhancedLrc = false;
  var lyricModel;
  var lyricUI = UINetease(
    otherMainSize: 16,
    defaultExtSize: 8,
    defaultSize: 32,
    lineGap: 40,
    inlineGap: 5,
    highlight: false,
  );

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
      appBar: getAppBar(),
      extendBodyBehindAppBar: false,
      body: buildBody(),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.black.withOpacity(0.5),
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
            _stop(false);
          });
        },
      ),
      title: Padding(
        padding: const EdgeInsets.only(left: 0, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "NOW SINGING",
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

  bool isPlaying = false;
  bool firstTimePlay = true;

  Widget buildBody() {
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
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
        ),
        buildReaderWidget(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
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
                          _pause();
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
                            Icons.mic,
                            color: isPlaying ? Colors.green : Colors.white,
                            size: 30,
                          ),
                          onPressed: () async {
                            if (isPlaying == false && firstTimePlay == true) {
                              audioPlayer = AudioPlayer()
                                ..play(UrlSource(widget.song_url));
                              setState(() {
                                playing = true;
                                isPlaying = true;
                                firstTimePlay = false;
                                _start();
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
                              audioPlayer?.onPlayerComplete.listen((event) {
                                setState(() {
                                  playProgress = 0;
                                });
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        alignment: Alignment.bottomCenter,
                                        child: myMainBody(true),
                                        type: PageTransitionType.scale));
                              });
                            } else if (isPlaying == false &&
                                firstTimePlay == false) {
                              audioPlayer?.resume();
                              setState(() {
                                isPlaying = true;
                                _resume();
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
                            _stop(false);
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

  var lyricPadding = 40.0;

  Stack buildReaderWidget() {
    return Stack(
      children: [
        //...buildReaderBackground(),
        LyricsReader(
          padding: EdgeInsets.symmetric(horizontal: lyricPadding),
          model: lyricModel,
          position: playProgress,
          lyricUi: lyricUI,
          playing: playing,
          size:
              Size(double.infinity, MediaQuery.of(context).size.height * 3 / 4),
          emptyBuilder: () => Center(
            child: Text(
              "No lyrics",
              style: lyricUI.getOtherMainTextStyle(),
            ),
          ),
        )
      ],
    );
  }

  var playing = false;
}
