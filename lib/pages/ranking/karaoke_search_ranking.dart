import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:karaoke_real_one/pages/ranking/Screen-profile/Profile_Page.dart';
import 'package:karaoke_real_one/fb_connect.dart';

class KaraokeSearchRanking extends StatefulWidget {
  final List usersRanking;
  final int index;

  const KaraokeSearchRanking({Key? key, required this.usersRanking, required this.index})
      : super(key: key);

  @override
  State<KaraokeSearchRanking> createState() => _KaraokeSearchRankingState();
}

class _KaraokeSearchRankingState extends State<KaraokeSearchRanking> {
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
              "Search Ranking",
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
            arrowBackIcon(),
          ],
        ),
      ),
    );
  }

  Widget arrowBackIcon() {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: Colors.white),
      onPressed: () {
        Navigator.pop(context);
      },
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
