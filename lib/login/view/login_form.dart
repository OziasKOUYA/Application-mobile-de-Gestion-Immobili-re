import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';

import '../../connexion/connexionUtils.dart';
import '../../register/view/registerForm.dart';
import '../bloc/login_bloc.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context).showSnackBar(

            SnackBar(
              duration: Duration(seconds: 2, milliseconds: 500),
                content: Text(
                  state.errorMessage,
                )),
          );
        }
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final isSmallScreen = constraints.maxWidth < 600;
          double availableHeight = constraints.maxHeight;
          final imageSize = isSmallScreen ? 150.0 : 200.0;
          final fontSize = isSmallScreen ? 16.0 : 24.0;
          final buttonStyle = ElevatedButton.styleFrom(
            textStyle: TextStyle(fontSize: isSmallScreen ? 12.0 : 16.0),
            padding: isSmallScreen ? EdgeInsets.all(8) : EdgeInsets.all(16),
          );
          return Align(
            alignment: Alignment(0.1, 0.2),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      ClipPath(
                        clipper: FooterWaveClipper(),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                Theme.of(context).secondaryHeaderColor,
                                Theme.of(context).primaryColor
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          height: availableHeight / 4 ,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(14.0),
                        decoration: BoxDecoration(
                          //color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          ),
                        ),
                        child:Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container( // Transparent container to overlay the wavy footer
                              //color: Colors.white,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                Text(
                                'Connectez-Vous',
                                style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w800,

                                ),
                              ),
                              const Padding(padding: EdgeInsets.all(12)),
                              _UsernameInput(),
                              const Padding(padding: EdgeInsets.all(12)),
                              _PasswordInput(),
                              const Padding(padding: EdgeInsets.all(12)),
                              _LoginButton(buttonStyle),
                                ],
                              ),
                            ),
                          ],
                        ),
                        ),
                    ],
                  ),
                  const Padding(padding: EdgeInsets.all(6)),
                  _SignUpButton(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: TextField(
            key: const Key('loginForm_usernameInput_textField'),
            onChanged: (username) =>
                context.read<LoginBloc>().add(LoginUsernameChanged(username)),
            decoration: InputDecoration(
              labelText: "Nom d'utilisateur",
              labelStyle: TextStyle(fontSize: isSmallScreen ? 12.0 : 16.0),
              contentPadding:
              isSmallScreen ? EdgeInsets.all(6) : EdgeInsets.all(8),
              border: InputBorder.none,
              errorText: state.username.displayError != null
                  ? "Nom d'utilisateur invalide"
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        final isSmallScreen = MediaQuery.of(context).size.width < 600;
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4.0),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            ),
          ),
          child: TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginBloc>().add(LoginPasswordChanged(password)),
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'Mots de passe',
              labelStyle: TextStyle(fontSize: isSmallScreen ? 12.0 : 16.0),
              contentPadding:
              isSmallScreen ? EdgeInsets.all(6) : EdgeInsets.all(8),
              border: InputBorder.none,
              errorText: state.password.displayError != null
                  ? 'Mots de passe invalide'
                  : null,
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  final ButtonStyle style;
  const _LoginButton(this.style);
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
          key: const Key('loginForm_continue_raisedButton'),
          onPressed: state.isValid
              ? () async {
            final isConnected =
            await InternetConnectivity.isConnected();
            if (isConnected) {
              context.read<LoginBloc>().add(const LoginSubmitted());
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Pas de connexion Internet.'),
                duration: Duration(seconds: 3),
              ));
            }
          }
              : null,
          child: Text(
            'Connexion',
            style: TextStyle(
              fontSize: isSmallScreen ? 15.0 : 16.0,
              fontWeight: FontWeight.w800,
            ),
          ),
        );
      },
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  final ButtonStyle style;
  const _ForgotPasswordButton(this.style);
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return TextButton(
      onPressed: () {
        // Add your forgot password navigation code here.
      },
      child: Text(
        'Mot de passe oublié?',
        style: TextStyle(
          fontSize: isSmallScreen ? 15.0 : 16.0,
        ),
      ),
    );
  }
}

class _SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RegisterForm(),
          ),
        );
      },
      child: Text(
        'Vous n\'avez pas de compte ? S\'inscrire',
        style: TextStyle(
          fontSize: isSmallScreen ? 15.0 : 16.0,
        ),
      ),
    );
  }
}
class FooterWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
   /* var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height - 10);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);
*/
    Path path = Path();
    double width = size.width;
    double height = size.height;
    double curveHeight = height / 5; // Adjust the curve height as needed

    // Starting point (top-left corner)
    path.moveTo(0, 0);

    // Top-right corner with curve
    path.quadraticBezierTo(width / 2, 2 * curveHeight, width, 0);

    // Bottom-right corner with curve (symmetric to the top-right curve)
    path.quadraticBezierTo(width / 2, height - 2 * curveHeight, 0, height);

    // Close the path to complete the shape
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
