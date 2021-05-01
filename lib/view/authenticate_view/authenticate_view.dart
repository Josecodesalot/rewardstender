import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rewards_network_shared/const/theme.dart';
import 'package:rewards_network_shared/models/auth_fields.dart';
import 'package:rewards_network_shared/models/response.dart';
import 'package:rewards_network_shared/utils/validators.dart';
import 'package:rewards_network_shared/widgets/custom_snack_bar.dart';
import 'package:rewards_network_shared/widgets/opacity_in.dart';
import 'package:rewards_network_shared/widgets/primary_button.dart';
import 'package:rewards_network_shared/widgets/slide.dart';
import 'package:rewardstender/view_model/auth_model.dart';

class AuthenticateView extends StatefulWidget {
  @override
  _AuthenticateViewState createState() => _AuthenticateViewState();
}

class _AuthenticateViewState extends State<AuthenticateView> {
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  bool isSignIn = true;

  TextEditingController emailController;
  TextEditingController passwordController;
  String name;

  AuthFields getAuthFields() => AuthFields(
        email: emailController.text,
        password: passwordController.text,
        name: name,
      );

  void _signInPressed() {
    final formIsValid = signInFormKey.currentState.validate();

    if (formIsValid) {
      showLoadingSnack();
      authModel.signIn(getAuthFields(), onError: (ResponseError error) {
        CustomSnackBar(
          context,
          duration: 2,
          message: error.message,
        ).show();
      });
    }
  }

  void _signUpPressed() {
    final formIsValid = signInFormKey.currentState.validate();
    if (formIsValid) {
      showLoadingSnack();
      authModel.signUp(getAuthFields(), onError: (ResponseError error) {
        CustomSnackBar(
          context,
          duration: 2,
          message: error.message,
        ).show();
      });
    }
  }

  void _skipAuthSignInAnon() => authModel.signInAnon();

  @override
  initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  AuthModel get authModel => Provider.of<AuthModel>(context, listen: false);

  @override
  Widget build(BuildContext outerContext) {
    debugPrint('LoginPageCalled');
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: OpacityAnimation(
        curve: Curves.easeInCubic,
        duration: const Duration(milliseconds: 600),
        key: Key('authView $isSignIn'),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: signInFormKey,
              child: Column(
                children: [
                  _title(),
                  _emailInput(),
                  _passwordInput(),
                  const Spacer(),
                  _button(
                    'Sign-${isSignIn ? "in" : "up"}',
                    () => isSignIn ? _signInPressed() : _signUpPressed(),
                  ),
                  _button(
                    'Sign-in (as guest)',
                    _skipAuthSignInAnon,
                  ),
                  _bottomMessage(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget _button(String title, Function onTap, {Color color}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12, left: 24, right: 24),
      child: PrimaryButton(
        title: title,
        onTap: onTap,
        color: color,
        width: 200,
      ),
    );
  }

  Widget _emailInput() {
    return SlideAnimation(
      tween: Tween(begin: Offset(0, 80), end: Offset(0, 0)),
      key: Key('slide in email $isSignIn'),
      delay: const Duration(milliseconds: 300),
      curve: Curves.decelerate,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TextFormField(
          controller: emailController,
          decoration: InputDecoration(labelText: 'Email'),
          autocorrect: false,
          validator: validateEmail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
        ),
      ),
    );
  }

  Widget _passwordInput() {
    return SlideAnimation(
      key: Key('slide in password $isSignIn'),
      tween: Tween(begin: Offset(0, 80), end: Offset(0, 0)),
      delay: const Duration(milliseconds: 400),
      curve: Curves.decelerate,
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.0),
        child: TextFormField(
          controller: passwordController,
          autocorrect: false,
          buildCounter: _buildCounter,
          validator: validatePassword,
          decoration: InputDecoration(labelText: 'Password'),
          obscureText: true,
          onSaved: (_) {
            if (isSignIn) {
              _signInPressed();
            } else {
              _signUpPressed();
            }
          },
        ),
      ),
    );
  }

  Widget _buildCounter(BuildContext context,
      {int currentLength, bool isFocused, int maxLength}) {
    if (currentLength == 0) return const SizedBox();
    return Text('$currentLength');
  }

  Widget _title() {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.only(top: 48, bottom: 52),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to Fidelity Rewards!',
            style: Theme.of(context).textTheme.headline4,
          ),
          const SizedBox(height: 8),
          Text(
            'Sign-${isSignIn ? 'in' : 'up'} to start collecting',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ],
      ),
    );
  }

  Widget _bottomMessage() {
    final style = Theme.of(context).textTheme.bodyText1.copyWith(
          letterSpacing: .8,
          color: Theme.of(context).textTheme.bodyText1.color.withOpacity(.75),
        );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        setState(() {
          isSignIn = !isSignIn;
        });
      },
      child: Container(
        height: 44,
        margin: const EdgeInsets.only(bottom: 8),
        alignment: Alignment.center,
        child: isSignIn ? signUpSpan(style) : signInSpan(style),
      ),
    );
  }

  Widget signUpSpan(TextStyle style) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Don\'t have an account? ',
            style: style,
          ),
          TextSpan(
            text: 'Sign-up!',
            style: style.copyWith(
              color: primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget signInSpan(TextStyle style) {
    final boldStyle = style.copyWith(
      color: primary,
      fontWeight: FontWeight.w600,
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: 'Already have an account? ',
            style: style,
          ),
          TextSpan(
            text: 'Sign-in!',
            style: boldStyle,
          ),
        ],
      ),
    );
  }

  void showLoadingSnack() {
    CustomSnackBar(
      context,
      message: 'loading',
      color: loadingGreen,
      duration: 1,
    ).show();
  }
}
