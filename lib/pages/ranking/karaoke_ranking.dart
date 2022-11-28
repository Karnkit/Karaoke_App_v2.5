import 'dart:async';
import 'dart:io';

import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:karaoke_real_one/pages/ranking/Screen-profile/Profile_Page.dart';
import 'package:karaoke_real_one/fb_connect.dart';
import 'package:karaoke_real_one/pages/ranking/karaoke_search_ranking.dart';

class KaraokeRanking extends StatefulWidget {
  final List usersRanking;

  const KaraokeRanking({Key? key, required this.usersRanking})
      : super(key: key);

  @override
  State<KaraokeRanking> createState() => _KaraokeRankingState();
}

class _KaraokeRankingState extends State<KaraokeRanking> {
  final TextEditingController textController = TextEditingController();

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
      title: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Top 50 Ranking",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            searchIcon(),
          ],
        ),
      ),
    );
  }

  Widget searchIcon() {
    return AnimSearchBar(
      width: 215,
      textController: 
        textController
          ..addListener(() { 
            new Timer(const Duration(seconds: 5),(){
              String textSearch = textController.text;
              for(int i=0;i<widget.usersRanking.length;i++){
                List userData = [widget.usersRanking[widget.usersRanking.length - i - 1]];
                if(userData[0]['userName'].toString().toLowerCase() == textSearch.toLowerCase()){
                  textController.clear();
                  Navigator.push(context, PageTransition(
                    alignment: Alignment.bottomCenter,
                    child: KaraokeSearchRanking(usersRanking: userData, index: i),
                    type: PageTransitionType.scale)
                  );
                  break;
                }
              }
            });
          }),
      onSuffixTap: () {
        setState(() {
          textController.clear();
        });
      },
      color: Colors.white24,
      helpText: "Search User",
      autoFocus: true,
      closeSearchOnSuffixTap: true,
      animationDurationInMilli: 600,
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
              child: Row(
                children: [
                  SizedBox(
                    width: (size.width - 60) * 0.70,
                    child: Text(
                      "#  " +
                      "Name",
                    style: TextStyle(
                    color: Colors.yellow.withOpacity(0.8), fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: (size.width - 60) * 0.30,
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Total Stars",
                          style: TextStyle(
                            color: Colors.yellow.withOpacity(0.8),
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: List.generate(widget.usersRanking.length<50? widget.usersRanking.length:50, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30, bottom: 10),
                      child: GestureDetector(
                        onTap: () async {
                          List userData = [
                            widget.usersRanking[widget.usersRanking.length - index - 1]
                          ];
                          List userSongs =
                              await fb_connect().fetchingSongList(userData[0]['userName']);
                          userData[0]['songs'] = userSongs;
                          Navigator.push(
                              context,
                              PageTransition(
                                  alignment: Alignment.bottomCenter,
                                  child: ProfilePage(userData: userData),
                                  type: PageTransitionType.scale));
                        },
                        child: Row(
                          children: [
                            SizedBox(
                              width: (size.width - 60) * 0.70,
                              child: Text(
                                "${index + 1}  " +
                                    widget.usersRanking[
                                        widget.usersRanking.length - index - 1]['userName'],
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              width: (size.width - 60) * 0.30,
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    widget.usersRanking[
                                            widget.usersRanking.length - index - 1]['stars']
                                        .toString(),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
              }),
            ),
          ],
        ));
  }
}
