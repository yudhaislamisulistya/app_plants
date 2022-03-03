import 'package:app_plants/screens/panel_screen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new SingleChildScrollView(
          child: new Container(
            child: new Padding(
              padding: const EdgeInsets.all(18.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  new Text(
                    "Selamat Datang",
                    style: new TextStyle(
                      color: Colors.blue,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),
                  new Container(
                    height: 239.0,
                    width: 321.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/rafiki.png'),
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),
                  new Text(
                    "Login",
                    style: new TextStyle(
                      color: Colors.blue,
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  new SizedBox(
                    height: 30.0,
                  ),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                    ),
                    onChanged: (text) {
                      setState(() {
                        username = text;
                      });
                    },
                  ),
                  new SizedBox(
                    height: 20.0,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                    onChanged: (text) {
                      setState(() {
                        password = text;
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      new ElevatedButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context){
                                return new Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: new Row(
                                      children: [
                                        new CircularProgressIndicator(),
                                        new SizedBox(
                                          width: 8.0,
                                        ),
                                        new Text("Loading...")
                                      ],
                                    ),
                                  ),
                                );
                              }
                          );

                          new Future.delayed(new Duration(seconds: 1), () async{
                            Navigator.pop(context);
                            if(username == "admin" && password == "admin"){
                              AwesomeDialog(
                                  context: context,
                                  animType: AnimType.LEFTSLIDE,
                                  headerAnimationLoop: false,
                                  dialogType: DialogType.SUCCES,
                                  title: 'Success',
                                  desc:
                                  'Anda Berhasil Login',
                                  btnOkOnPress: () {
                                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                        PanelScreen()), (Route<dynamic> route) => false);
                                  },
                                  btnOkIcon: Icons.check_circle,)
                                ..show();
                            }else{
                              AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.ERROR,
                                  animType: AnimType.RIGHSLIDE,
                                  headerAnimationLoop: false,
                                  title: 'Error',
                                  desc:"Nama Pengguna atau Kata Sandi Yang Anda Masukkan Salah",
                                  btnOkOnPress: () {},
                                  btnOkIcon: Icons.cancel,
                                  btnOkColor: Colors.red)
                                ..show();
                            }
                          });

                        },
                        child: new Text("Login"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
