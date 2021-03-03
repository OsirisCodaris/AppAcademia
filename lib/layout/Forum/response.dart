import 'dart:async';
import 'dart:io';

import 'package:academia/Components/cardResponse.dart';
import 'package:academia/Components/chargement.dart';
import 'package:academia/Components/custom_snack.dart';
import 'package:academia/Components/fontImage.dart';
import 'package:academia/Components/handleError.dart';
import 'package:academia/Components/showProblem.dart';
import 'package:academia/HttpRequest/notificationrequest.dart';
import 'package:academia/HttpRequest/responserequest.dart';
import 'package:academia/models/problems.dart';
import 'package:academia/models/response.dart';
import 'package:academia/models/user.dart';
import 'package:academia/utils/multipartfile.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ResponseScreen extends StatefulWidget {
  final User user;
  final Problems problem;

  ResponseScreen(this.user, this.problem);

  @override
  _ResponseScreenState createState() =>
      _ResponseScreenState(this.user, this.problem);
}

class _ResponseScreenState extends State<ResponseScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  User currentUser;
  Problems problem;
  bool isLoading = true;
  bool isSending = false;
  bool canSend = true;
  bool isFiltering = false;
  bool isShowingProb = false;
  bool isNotified = false;
  bool _init = true;
  File file;
  String fileName = '';
  TextEditingController _controller = TextEditingController();
  _ResponseScreenState(this.currentUser, this.problem);
  // ignore: close_sinks
  StreamController<List<Responses>> controller =
      StreamController<List<Responses>>.broadcast();

  ScrollController _scrollController = new ScrollController();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences prefs;
  String tokenfcm = '';
  StreamSubscription<QuerySnapshot> firestore;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var _isVisible = false;

  @override
  void initState() {
    super.initState();
    onLoad();
  }

  @override
  void dispose() {
    firestore.cancel();
    super.dispose();
  }

  List<Responses> responses;
  onLoad() async {
    if (tokenfcm.isEmpty) {
      prefs = await _prefs;
      tokenfcm = prefs.getString('tokenfcm');
    }

    isFiltering = false;

    try {
      responses = await ResponseRequest.getResponses(problem.idproblems);
      controller.add(responses);
      if (_init) {
        await Firebase.initializeApp();
        firestore = FirebaseFirestore.instance
            .collection("responses")
            .where('idproblems', isEqualTo: problem.idproblems)
            .orderBy('idresponses', descending: true)
            .snapshots()
            .listen(receivedResponse);
      }

      isNotified = await NotificationRequest.haveNotif(
          currentUser.idusers, problem.idproblems);
      if (currentUser.role == 'TEACHER') {
        canSend =
            currentUser.idusers == (problem?.idteachers ?? currentUser.idusers);
      }
      _scrollController.addListener(() {
        if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse) {
          /* only set when the previous state is false
             * Less widget rebuilds 
             */
          print("**** ${_isVisible} up"); //Move IO away from setState
          setState(() {
            _isVisible = true;
          });
        }
        if (_scrollController.position.atEdge) {
          if (_scrollController.position.pixels == 0) {
            setState(() {
              _isVisible = false;
            });
          } else {
            print("***** TOP");
          }
        }
      });
      setState(() {
        isLoading = false;
        isSending = false;
      });
    } catch (e) {
      HandleError.buildError(context, e).then((r) {
        return onLoad();
      });
    }
  }

  receivedResponse(snapshot) async {
    print('received');
    if (!_init) {
      var data = snapshot.docs;
      var rep = Responses.fromJson(data[0].data());
      responses.insert(0, rep);
      if (!isFiltering) {
        controller.add(responses);
      }
      await Future.delayed(Duration(milliseconds: 1500)).then((_) async {
        await flutterLocalNotificationsPlugin.cancel(rep.idresponses);
      });
    } else {
      _init = false;
    }
  }

  Widget postResponse() {
    return Container(
        margin: EdgeInsets.only(left: 8.0, right: 8.0),
        child: canSend
            ? Column(children: [
                Container(
                    child: fileName.isNotEmpty
                        ? GestureDetector(
                            child: Chip(
                              avatar: Icon(
                                Icons.clear,
                                size: 14,
                                color: Theme.of(context).primaryColor,
                              ),
                              label: Text(fileName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  )),
                            ),
                            onTap: () {
                              setState(() {
                                fileName = '';
                              });
                            },
                          )
                        : null),
                Row(children: [
                  Expanded(
                      child: TextField(
                    controller: _controller,
                    autocorrect: true,
                    minLines: 1,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Ecrivez votre message...",
                      hintStyle: TextStyle(color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.attach_file),
                        color: Theme.of(context).primaryColor,
                        onPressed: () {
                          _openFileExplorer();
                        },
                      ),
                    ),
                  )),
                  IconButton(
                    icon: Icon(Icons.send),
                    color: Theme.of(context).primaryColor,
                    onPressed: isSending
                        ? () {}
                        : () {
                            if (_controller.text.isNotEmpty || file != null) {
                              _sendResponse();
                            } else {
                              var custom = new CustomSnack(
                                  "Veuillez indiquer le contenu de votre problème !",
                                  "warning");
                              _scaffoldKey.currentState
                                  .showSnackBar(new SnackBar(
                                content: custom.getText(),
                              ));
                            }
                          },
                  ),
                ]),
              ])
            : Center(
                child: Text(
                  "Un enseignant s'occupe de ce problème, selectionnez un autre depuis la fenêtre précedente",
                  textAlign: TextAlign.justify,
                  style: TextStyle(color: Colors.amber),
                ),
              ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        problem.fullname.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: isNotified
                      ? Icon(Icons.notifications_active)
                      : Icon(Icons.notifications_active_outlined),
                  onPressed: () {
                    _associateNotif();
                  },
                ),
                IconButton(
                  icon: isFiltering
                      ? Icon(Icons.favorite)
                      : Icon(Icons.favorite_border),
                  onPressed: () {
                    isFiltering = !isFiltering;
                    if (isFiltering) {
                      var filter = responses
                          .where((response) => response.status)
                          .toList();
                      controller.add(filter);
                    } else {
                      controller.add(responses);
                    }
                    setState(() {});
                  },
                ),
                IconButton(
                  icon: isShowingProb
                      ? Icon(Icons.remove_red_eye)
                      : Icon(Icons.remove_red_eye_outlined),
                  onPressed: () {
                    isShowingProb = !isShowingProb;
                    setState(() {});
                    showDialog(
                        context: context,
                        builder: (context) => ShowProblem(problem)).then((_) {
                      isShowingProb = !isShowingProb;
                      setState(() {});
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Builder(builder: (BuildContext context) {
        return new Container(
            decoration: DecoFontImage().fontClair(), //background
            child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: isLoading
                    ? Center(child: ChargementClass())
                    : Column(
                        children: <Widget>[
                          isSending ? PageChargement() : Container(),
                          StreamBuilder(
                            stream: controller.stream,
                            initialData: responses,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                var listResponses = snapshot.data;
                                return Expanded(
                                    child: ListView.builder(
                                  key: new Key(listResponses.length.toString()),
                                  padding: EdgeInsets.only(top: 15.0),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    final Responses response =
                                        listResponses[index];
                                    return CardResponse(
                                        currentUser, problem, response);
                                  },
                                  itemCount: listResponses.length,
                                  controller: _scrollController,
                                  reverse: true,
                                  shrinkWrap: true,
                                ));
                              } else {
                                return ChargementClass();
                              }
                            },
                          ),
                          postResponse(),
                        ],
                      )));
      }),
      floatingActionButton: new Visibility(
        visible: _isVisible,
        child: new FloatingActionButton(
          backgroundColor: Colors.grey,
          onPressed: () async {
            if (_scrollController.hasClients) {
              await _scrollController.animateTo(
                0.0,
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 500),
              );
            }
          },
          child: new Icon(
            Icons.arrow_downward,
            size: 14,
          ),
        ),
      ),
    );
  }

  void _openFileExplorer() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path);
      setState(() {
        fileName = result.files.single.name;
      });
    } else {
      // User canceled the picker
    }
  }

  void _sendResponse() async {
    try {
      setState(() {
        isSending = true;
      });
      var files = file != null
          ? MultipartFileExtended.fromFileSync(file.path, filename: fileName)
          : null;
      var responseSend = await ResponseRequest.sendResponse(
          problem.idproblems, _controller.text.toString(), files);
      setState(() {
        isSending = false;
      });

      setState(() {
        file = null;
        fileName = '';
        _controller.clear();
        onLoad();
      });
    } catch (e) {
      HandleError.buildError(context, e, _scaffoldKey)
          .then((result) => onLoad());
    }
  }

  _associateNotif() async {
    try {
      var result =
          await NotificationRequest.associate(problem.idproblems, tokenfcm);
      setState(() {
        isNotified = result;
      });
    } catch (e) {
      HandleError.buildError(context, e, _scaffoldKey)
          .then((result) => onLoad());
    }
  }
}
