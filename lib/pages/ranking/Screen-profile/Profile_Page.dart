import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'profile_widget.dart';
import 'package:karaoke_real_one/pages/home/listen_and_record/music_detail_page.dart';
import 'package:karaoke_real_one/fb_connect.dart';

class ProfilePage extends StatefulWidget {
  final List userData;

  const ProfilePage({Key? key, required this.userData}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  List lastTenSong = [];
  List mostScore = [];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.black,
        appBar: getAppBar(),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              children: [
                SizedBox(height: 120),
                ProfileWidget(
                  imagePath: widget.userData[0]['img'],
                  onClicked: () {},
                ),
                SizedBox(height: 40),
                Text(
                  widget.userData[0]['userName'],
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                SizedBox(height: 5),
                Text(
                  widget.userData[0]['userEmail'],
                  style: TextStyle(color: Colors.green, fontSize: 16),
                ),
                SizedBox(height: 25),
                buildNumber(),
                SizedBox(height: 25),
                tabBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget tabBar() {
    return Container(
      child: Column(
        children: [
          Container(
            child: TabBar(
              indicatorColor: Colors.green,
              isScrollable: true,
              tabs: [
                Tab(text: 'Last Singing'),
                Tab(text: 'Most Score'),
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: TabBarView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 0, right: 0),
                  child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: buildList1()),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 0, right: 0),
                  child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: buildList2()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: Colors.black.withOpacity(0.0),
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 10, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "View Profile",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildButton(
            context, widget.userData[0]['songs_count'].toString(), 'Singing'),
        buildDivider(),
        buildButton(context, widget.userData[0]['stars'].toString(), 'Stars'),
      ],
    );
  }

  Widget buildDivider() => Container(
        height: 26,
        child: VerticalDivider(),
      );

  Widget buildButton(BuildContext context, String value, String text) =>
      MaterialButton(
          padding: EdgeInsets.symmetric(vertical: 4),
          onPressed: () {},
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white),
              ),
              SizedBox(height: 2),
              Text(
                text,
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ));

  Widget getList() {
    List userSongs = widget.userData[0]['songs'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Text("USER LIST SONG"),
          Row(
            children: List.generate(userSongs.length, (index) {
              return Padding(
                padding: EdgeInsets.only(right: 15),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        PageTransition(
                            alignment: Alignment.bottomCenter,
                            child: MusicDetailPage(
                              title: userSongs[index]['title'],
                              description: "",
                              color: Colors.black,
                              img: userSongs[index]['img'],
                              songUrl: userSongs[index]['song_url'],
                            ),
                            type: PageTransitionType.scale));
                  },
                  child: Column(children: [
                    Container(
                      width: 180,
                      height: 180,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(userSongs[index]['img']),
                            fit: BoxFit.cover,
                          ),
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      userSongs[index]['title'],
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 100,
                      child: Text(
                        "",
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600),
                      ),
                    )
                  ]),
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget getList1(List songList) {
    var size = MediaQuery.of(this.context).size;
    return SingleChildScrollView(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 0),
        child: Column(
          children: [
            Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
                child: Row(
                  children: [
                    SizedBox(
                      width: (size.width - 60) * 0.57,
                      child: Text(
                        "#  " + "Songname - Datetime",
                        style: TextStyle(
                            color: Colors.yellow.withOpacity(0.8),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: (size.width - 60) * 0.35,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Stars",
                            style: TextStyle(
                                color: Colors.yellow.withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            Column(
                children: List.generate(
                    songList.length < 10 ? songList.length : 10, (index) {
              return Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        this.context,
                        PageTransition(
                            alignment: Alignment.bottomCenter,
                            child: MusicDetailPage(
                              title: songList[songList.length - index - 1]
                                  ['title'],
                              color: Colors.black,
                              description: "",
                              img: songList[songList.length - index - 1]['img'],
                              songUrl: songList[songList.length - index - 1]
                                  ['song_url'],
                            ),
                            type: PageTransitionType.scale));
                  },
                  child: Row(
                    children: [
                      Container(
                        width: (size.width - 60) * 0.57,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${index + 1}  " +
                                      songList[songList.length - index - 1]
                                          ['title'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  songList[songList.length - index - 1]['date']
                                      .toString()
                                      .substring(0, 19),
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: (size.width - 60) * 0.40,
                        height: 50,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                  children: List.generate(3, (index_stars) {
                                return Container(
                                    width: 25,
                                    height: 25,
                                    child: Icon(
                                      2 - index_stars >=
                                              songList[songList.length -
                                                  index -
                                                  1]['stars']
                                          ? Icons.star_border
                                          : Icons.star,
                                      color: Colors.green,
                                    ));
                              }))
                            ]),
                      ),
                    ],
                  ),
                ),
              );
            }))
          ],
        ));
  }

  Widget getList2(List songList) {
    var size = MediaQuery.of(this.context).size;
    return SingleChildScrollView(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 0),
        child: Column(
          children: [
            Column(children: [
              Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, bottom: 0),
                child: Row(
                  children: [
                    SizedBox(
                      width: (size.width - 60) * 0.57,
                      child: Text(
                        "#  " + "Songname - Datetime",
                        style: TextStyle(
                            color: Colors.yellow.withOpacity(0.8),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      width: (size.width - 60) * 0.35,
                      height: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Stars",
                            style: TextStyle(
                                color: Colors.yellow.withOpacity(0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            Column(
                children: List.generate(
                    songList.length < 10 ? songList.length : 10, (index) {
              return Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        this.context,
                        PageTransition(
                            alignment: Alignment.bottomCenter,
                            child: MusicDetailPage(
                              title: songList[index]['title'],
                              color: Colors.black,
                              description: "",
                              img: songList[index]['img'],
                              songUrl: songList[index]['song_url'],
                            ),
                            type: PageTransitionType.scale));
                  },
                  child: Row(
                    children: [
                      Container(
                        width: (size.width - 60) * 0.57,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${index + 1}  " + songList[index]['title'],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  songList[index]['date']
                                      .toString()
                                      .substring(0, 19),
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: (size.width - 60) * 0.40,
                        height: 50,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                  children: List.generate(3, (index_stars) {
                                return Container(
                                    width: 25,
                                    height: 25,
                                    child: Icon(
                                      2 - index_stars >=
                                              songList[index]['stars']
                                          ? Icons.star_border
                                          : Icons.star,
                                      color: Colors.green,
                                    ));
                              }))
                            ]),
                      ),
                    ],
                  ),
                ),
              );
            }))
          ],
        ));
  }

  Widget buildList1() {
    return FutureBuilder(
      future: getLastTenSong(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loadScreen();
        }
        return getList1(lastTenSong);
      },
    );
  }

  Widget buildList2() {
    return FutureBuilder(
      future: getSongMostScore(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return loadScreen();
        }
        return getList2(mostScore);
      },
    );
  }

  Future getLastTenSong() async {
    lastTenSong =
        await fb_connect().getLastTenSong(widget.userData[0]['userName']);
  }

  Future getSongMostScore() async {
    mostScore =
        await fb_connect().getSongMostScore(widget.userData[0]['userName']);
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
}
