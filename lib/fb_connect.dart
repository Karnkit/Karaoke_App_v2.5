import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class fb_connect {
  Future loadSong(List listsong, String songname) async {
    List listsong = [];
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child("userSongs")
        .orderByChild("title")
        .equalTo(songname)
        .get();
    if (snapshot.exists) {
      for (final key in snapshot.children) {
        listsong.add(key.value);
      }
    }
    return listsong;
  }

  Future loadUser(String userUID) async {
    List userData = [];
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("Users/" + userUID).get();
    if (snapshot.exists) {
      userData.add(snapshot.value);
    }
    return userData;
  }

  Future loadRanking() async {
    List usersranking = [];
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("Users").orderByChild("stars").get();
    if (snapshot.exists) {
      for (final key in snapshot.children) {
        usersranking.add(key.value);
      }
    }
    return usersranking;
  }

  Future fetchingSongList(String userName) async {
    List listSong = [];
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child("userSongs")
        .orderByChild("userName")
        .equalTo(userName)
        .get();
    if (snapshot.exists) {
      for (final key in snapshot.children) {
        listSong.add(key.value);
      }
    }
    return listSong;
  }

  Future getSongList() async {
    List songList = [];
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child("appSongs/songs").orderByKey().get();
    if (snapshot.exists) {
      for (final key in snapshot.children) {
        songList.add(key.value);
      }
    }
    return songList;
  }

  Future getSongLyrics(int index) async {
    String Lyrics = "";
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child("allLyrics/" + index.toString() + "/lyrics")
        .orderByKey()
        .get();
    if (snapshot.exists) {
      for (final line in snapshot.children) {
        Lyrics = Lyrics + line.value.toString() + '\n';
      }
    }
    return Lyrics;
  }

  Future getSongMostScore(String userName) async {
    List songList = [];
    List tempList = [];
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child("userSongs")
        .orderByChild("userName")
        .equalTo(userName)
        .get();
    if (snapshot.exists) {
      for (final key in snapshot.children) {
        songList.add(key.value);
      }
    }
    for (int i = 3; i >= 0; i--) {
      for (int j = songList.length - 1; j >= 0; j--) {
        if (songList[j]['stars'] == i) {
          tempList.add(songList[j]);
        }
      }
    }
    songList = tempList;
    return songList;
  }

  Future getLastTenSong(String userName) async {
    List songList = [];
    DatabaseReference ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref
        .child("userSongs")
        .orderByChild("userName")
        .equalTo(userName)
        .get();
    if (snapshot.exists) {
      for (final key in snapshot.children) {
        songList.add(key.value);
      }
    }
    return songList;
  }

  Future updatePics(String userUID, String img) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/" + userUID);
    await ref.update({
      "img": img,
    });
    return "Update Success!";
  }

  Future updateUserName(String userUID, String userName) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("Users/" + userUID);
    await ref.update({
      "userName": userName,
    });
    return "Update Success!";
  }
}
