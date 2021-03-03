import 'package:academia/layout/Forum/response.dart';
import 'package:academia/models/problems.dart';
import 'package:academia/models/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_moment/simple_moment.dart';

class CardProblem extends StatefulWidget {
  Problems _problems;
  User currentUser;
  CardProblem(this._problems, this.currentUser);
  @override
  _CardProblemState createState() => _CardProblemState(_problems, currentUser);
}

class _CardProblemState extends State<CardProblem> {
  Problems problem;
  User currentUser;
  _CardProblemState(this.problem, this.currentUser);

  @override
  Widget build(BuildContext context) {
    return new Card(
        color: Theme.of(context).primaryColor,
        child: GestureDetector(
          child: Container(
            alignment: Alignment.centerLeft,
            color: currentUser.idusers == problem.idstudents
                ? Color.fromRGBO(236, 240, 241, 1.0)
                : Colors.white,
            margin: EdgeInsets.only(left: 3.0, right: 3.0),
            child: Container(
                margin: EdgeInsets.only(left: 8.0, right: 3.0, top: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(problem.fullname.toUpperCase(),
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              )),
                          Icon(
                            problem.file != null ? Icons.attach_file : null,
                            size: 12,
                            color: Theme.of(context).primaryColor,
                          ),
                        ]),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          problem?.content ?? '',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text.rich(
                              TextSpan(
                                //text: 'Réponses :', // default text style
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'Réponses : ' +
                                          problem.countResponse.toString(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          color:
                                              Theme.of(context).primaryColor)),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                problem.status == true ? Icons.star : null,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () {},
                            ),
                            Text.rich(
                              TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                      text: Moment.parse(
                                              DateTime.parse(problem.createdAt)
                                                  .toString())
                                          .format("dd/MM/yyyy HH:mm"),
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                )),
          ),
          onTap: () {
            Navigator.push(
                context,
                new PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        new ResponseScreen(currentUser, problem)));
          },
        ));
  }
}
