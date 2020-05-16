import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github/models/users.dart';
import 'package:github/providers/provider.dart';
import 'package:github/requests/getRequest.dart';
import 'package:provider/provider.dart';

class flowers extends StatefulWidget {
  @override
  _flowersState createState() => _flowersState();
}

class _flowersState extends State<flowers> {
  User user;
  List<User> users;
  @override
  Widget build(BuildContext context) {
    setState(
      () {
        user = Provider.of<UserProvider>(context).gerUser();
        Github(user.login).fetchFollowing().then((flowers) {
          Iterable list = json.decode(flowers.body);
          setState(() {
            users = list.map((model) => User.fromJson(model)).toList();
          });
        });
      },
    );
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              brightness: Brightness.light,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.grey,
                ),
              ),
              backgroundColor: Colors.white,
              expandedHeight: 200,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 100,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(user.avatar_url),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        user.login,
                        style: TextStyle(fontSize: 20),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  height: 600,
                  child: users != null
                      ? ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey[200],
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Container(
                                        width: 60,
                                        height: 60,
                                        child: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              users[index].avatar_url),
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        users[index].login,
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.grey[700]),
                                      ),
                                    ],
                                  ),
                                  Text('Following',
                                      style: TextStyle(color: Colors.blue)),
                                ],
                              ),
                            );
                          })
                      : Align(
                          child: Text('Data is loading ...'),
                        ),
                )
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
