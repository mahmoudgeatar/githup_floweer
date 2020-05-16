import 'package:flutter/material.dart';
import 'package:github/pages/flowers.dart';
import 'package:github/providers/provider.dart';
import 'package:provider/provider.dart';

main() => runApp(ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: homePage(),
      ),
    ));

class homePage extends StatefulWidget {
  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  TextEditingController _controller = TextEditingController();
  void _getUser() {
    if (_controller.text == '') {
      Provider.of<UserProvider>(context)
          .setMessage('please inter your user name');
    } else {
      Provider.of<UserProvider>(context)
          .fetchUser(_controller.text)
          .then((value) {
        if (value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => flowers(),
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 100,
                ),
                Container(
                  height: 80,
                  width: 80,
                  child: CircleAvatar(
                    backgroundImage: AssetImage('img/logo.png'),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  'Github',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 150,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(.1)),
                  child: TextField(
                    onChanged: (value) {
                      Provider.of<UserProvider>(context).setMessage(null);
                    },
                    controller: _controller,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      errorText:
                          Provider.of<UserProvider>(context).getMessage(),
                      border: InputBorder.none,
                      hintText: 'username',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                MaterialButton(
                  padding: EdgeInsets.all(20),
                  onPressed: () {
                    _getUser();
                  },
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Align(
                    child: Provider.of<UserProvider>(context).isLoading()
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            strokeWidth: 2,
                          )
                        : Text(
                            'Get Your Following Now',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
