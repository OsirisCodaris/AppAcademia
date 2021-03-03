import 'package:academia/Components/FileReader.dart';
import 'package:academia/Components/handleError.dart';
import 'package:academia/HttpRequest/responserequest.dart';
import 'package:academia/layout/Forum/response.dart';
import 'package:academia/models/problems.dart';
import 'package:academia/models/response.dart';
import 'package:academia/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_moment/simple_moment.dart';

class CardResponse extends StatefulWidget {
  Responses _response;
  Problems _problem;
  User currentUser;
  CardResponse(
    this.currentUser,
    this._problem,
    this._response,
  );
  @override
  _CardResponseState createState() =>
      _CardResponseState(this.currentUser, this._problem, this._response);
}

class _CardResponseState extends State<CardResponse> {
  Responses response;
  User currentUser;
  Problems problem;
  Moment moment;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  _CardResponseState(this.currentUser, this.problem, this.response);

  @override
  Widget build(BuildContext context) {
    final bool isMe = currentUser.idusers == response.idusers;
    final moment = Moment.now().add(seconds: 1);
    final bool isMyProblem = currentUser.role == 'STUDENT'
        ? currentUser.idusers == problem.idstudents
        : false;
    final Column msg = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        key: new Key(response.idresponses.toString()),
        children: [
          Container(
            margin: isMe
                ? EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 80.0,
                  )
                : EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                  ),
            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
            width: MediaQuery.of(context).size.width * 0.85,
            decoration: BoxDecoration(
              color: isMe ? Color.fromRGBO(236, 240, 241, 1.0) : Colors.white,
              border: isMe
                  ? Border(
                      left: BorderSide(
                        color: Theme.of(context).primaryColor,
                        width: 3.0,
                      ),
                    )
                  : Border(
                      right: BorderSide(
                        color: Colors.grey,
                        width: 3.0,
                      ),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: isMe
                  ? <Widget>[
                      response.file != null
                          ? FileReader(response.file)
                          : Container(),
                      response.content != null
                          ? Text(
                              response.content,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.justify,
                            )
                          : Container(),
                    ]
                  : <Widget>[
                      Text(
                          response.role == 'TEACHER'
                              ? 'PROF- ${response.fullname.toUpperCase()}'
                              : response.fullname.toUpperCase(),
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          )),
                      SizedBox(height: 8.0),
                      response.file != null
                          ? FileReader(response.file)
                          : Container(),
                      SizedBox(height: 2.0),
                      response.content != null
                          ? Text(
                              response.content,
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16.0,
                                fontWeight: FontWeight.normal,
                              ),
                              textAlign: TextAlign.justify,
                            )
                          : Container(),
                    ],
            ),
          ),
          Text(
            moment
                .locale(new LocaleFr())
                .from(DateTime.parse(response.createdAt)),
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 11.0,
              fontWeight: FontWeight.normal,
            ),
            textAlign: TextAlign.right,
          )
        ]);
    if (isMe) {
      return msg;
    }
    return Row(
      key: new Key(response.idresponses.toString()),
      children: <Widget>[
        msg,
        isMyProblem
            ? IconButton(
                icon: response.status
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                iconSize: 30.0,
                color: response.status
                    ? Theme.of(context).primaryColor
                    : Colors.grey,
                onPressed: () {
                  _changeStatus();
                },
              )
            : response.status
                ? IconButton(
                    icon: Icon(Icons.favorite),
                    iconSize: 30.0,
                    color: Theme.of(context).primaryColor,
                    onPressed: () {},
                  )
                : Container()
      ],
    );
  }

  _changeStatus() async {
    try {
      await ResponseRequest.changeState(response.idresponses, !response.status);
      setState(() {
        response.status = !response.status;
      });
    } catch (e) {
      HandleError.buildError(context, e).then((result) => setState(() {}));
    }
  }
}
