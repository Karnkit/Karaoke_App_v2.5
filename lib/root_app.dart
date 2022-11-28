import 'package:flutter/material.dart';
import 'package:karaoke_real_one/pages/home/karaoke_home.dart';
import 'package:karaoke_real_one/pages/ranking/karaoke_ranking.dart';
import 'package:karaoke_real_one/pages/Screen-profile/Profile_Page.dart';
import 'package:karaoke_real_one/fb_connect.dart';

class RootApp extends StatefulWidget {
  final List userData;
  final List rankingData;
  final List appSongs;

  RootApp({Key? key, required this.userData, required this.rankingData, required this.appSongs})
      : super(key: key);

  @override
  _RootAppState createState() => _RootAppState();
}

class _RootAppState extends State<RootApp> {
  int activeTab = 0;

  List userData = [];
  List rankingData = [];
  List userSongs = [];
  List appSongs = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      bottomNavigationBar: getFooter(),
      body: getBody(),
    );
  }

  Widget getBody() {
    bool firstState = true;
    if (firstState) {
      setState(() {
        userData = widget.userData;
        rankingData = widget.rankingData;
        appSongs = widget.appSongs;
      });
      firstState = false;
    }
    return IndexedStack(
      index: activeTab,
      children: [
        HomePage(userData: userData, songs: appSongs),
        KaraokeRanking(usersRanking: rankingData),
        ProfilePage(userData: userData)
      ],
    );
  }

  Widget getFooter() {
    List items = [
      Icons.home,
      Icons.emoji_events_rounded,
      Icons.supervisor_account_sharp
    ];
    return Container(
      height: 70,
      decoration: BoxDecoration(color: Colors.black),
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(items.length, (index) {
              return IconButton(
                  icon: Icon(
                    items[index],
                    color: activeTab == index ? Colors.green : Colors.white,
                  ),
                  onPressed: () async {
                    setState(() {
                      activeTab = index;
                    });
                    if (index == 1) {
                      rankingData = await fb_connect().loadRanking();
                    } else if (index == 2) {
                      // setState(() {
                      //   userData = widget.userData;
                      // });
                      if (userData[0]['songs_count'] > 0) {
                        userData[0]['songs'] = await fb_connect()
                            .fetchingSongList(userData[0]['userName']);
                      }
                    }
                  });
            })),
      ),
    );
  }
}
