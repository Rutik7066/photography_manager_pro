import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:jk_photography_manager/auth/auth.dart';
import 'package:jk_photography_manager/common_widgets/my_textfield.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context);
    var auth = Provider.of<Auth>(context);
    var color = Colors.indigo;
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.indigo,
              child: Column(
                children: [
                  WindowTitleBarBox(child: MoveWindow()),
                  Flexible(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 450,
                          height: 450,
                          child: SvgPicture.asset('assets/login.svg'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTitle(color: color),
                const SizedBox(height: 150),
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Welcome to', style: style.textTheme.headline5!.copyWith(color: Colors.indigo)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8, bottom: 8),
                        child: Text('Studio Manager', style: style.textTheme.headline4!.copyWith(color: Colors.indigo)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        child: SizedBox(
                            width: 400,
                            child: MyTextField(
                              hintText: 'Email',
                              controller: _email,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20, top: 10),
                        child: SizedBox(
                            width: 400,
                            child: MyTextField(
                              hintText: 'Password',
                              obscureText: true,
                              controller: _password,
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          height: 30,
                          width: 300,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_email.text != '' && _password.text != '') {
                                  var r = await auth.signin(email: _email.text, pass: _password.text);
                                  if (r == 1) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        duration: const Duration(seconds: 4),
                                        backgroundColor: style.errorColor,
                                        content: const Text(
                                          'Log in failed ! check email and password',
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      duration: const Duration(seconds: 4),
                                      backgroundColor: style.errorColor,
                                      content: const Text(
                                        'Email and Password is required !',
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Log In')),
                        ),
                      ),
                      Text('or', style: style.textTheme.headline6!.copyWith(color: const Color.fromARGB(204, 63, 81, 181))),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: SizedBox(
                          height: 30,
                          width: 300,
                          child: ElevatedButton(onPressed: () {
                            auth.tryDemo();
                          }, child: const Text('Try')),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTitle extends StatelessWidget {
  const CustomTitle({
    Key? key,
    required this.color,
  }) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30,
      child: WindowTitleBarBox(
        child: Row(
          children: [
            Expanded(
              child: MoveWindow(),
            ),
            MinimizeWindowButton(
              animate: true,
              colors: WindowButtonColors(
                mouseOver: Colors.transparent,
                mouseDown: Colors.transparent,
                iconNormal: color,
                iconMouseDown: color,
                iconMouseOver: Colors.indigo,
              ),
            ),
            MaximizeWindowButton(
              animate: true,
              colors: WindowButtonColors(
                mouseOver: Colors.transparent,
                mouseDown: Colors.transparent,
                iconNormal: color,
                iconMouseDown: color,
                iconMouseOver: Colors.indigo,
              ),
            ),
            CloseWindowButton(
              animate: true,
              colors: WindowButtonColors(
                mouseOver: Colors.transparent,
                mouseDown: Colors.transparent,
                iconNormal: color,
                iconMouseDown: color,
                iconMouseOver: Colors.indigo,
              ),
            )
          ],
        ),
      ),
    );
  }
}
