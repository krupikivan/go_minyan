import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_minyan/register/register.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/translation.dart';

class RegisterForm extends StatefulWidget {
  final bool darkmode;

  const RegisterForm({Key key, this.darkmode}) : super(key: key);
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.isSubmitting) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Translations.of(context).registerLoading),
                    CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Theme.Colors.primaryColor)),
                  ],
                ),
              ),
            );
        }
        if (state.isSuccess) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Translations.of(context).registerSuccess),
                    Icon(Icons.check),
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(Translations.of(context).errorDialog),
                    Icon(Icons.error),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
        }
      },
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              child: ListView(
                children: <Widget>[
                  TextFormField(
                    autovalidate: true,
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: widget.darkmode ? Theme.Colors.hintDarkColor : Theme.Colors.hintColor)),
                      icon: _getIcon(Icons.email),
                      labelText: Translations.of(context).emailHint,
                      hintStyle: TextStyle(color: widget.darkmode ? Theme.Colors.hintDarkColor : Theme.Colors.hintColor),
                      labelStyle: TextStyle(color: widget.darkmode ? Theme.Colors.hintDarkColor : Theme.Colors.hintColor),
                    ),
                    cursorColor: Theme.Colors.primaryColor,
                    validator: (_) {
                      return !state.isEmailValid ? Translations.of(context).invalidMail : null;
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    autovalidate: true,
                    decoration: InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: widget.darkmode ? Theme.Colors.hintDarkColor : Theme.Colors.hintColor)),
                      icon: _getIcon(Icons.lock),
                      labelText: Translations.of(context).passHint,
                      hintStyle: TextStyle(color: widget.darkmode ? Theme.Colors.hintDarkColor : Theme.Colors.hintColor),
                      labelStyle: TextStyle(color: widget.darkmode ? Theme.Colors.hintDarkColor : Theme.Colors.hintColor),
                    ),
                    obscureText: true,
                    cursorColor: Theme.Colors.primaryColor,
                    validator: (_) {
                      return !state.isPasswordValid ? Translations.of(context).invalidPass : null;
                    },
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    children: <Widget>[
                      RegisterButton(
                        name: Translations.of(context).btnRegister,
                        darkmode: widget.darkmode,
                        onPressed: isRegisterButtonEnabled(state)
                            ? _onFormSubmitted
                            : null,
                      ),
                      SizedBox(width: 20,),
                      RegisterButton(
                        name: Translations.of(context).btnClear,
                        onPressed: _onClearForm,
                        darkmode: widget.darkmode,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getIcon(IconData icon){
    return Icon(
      icon, color: widget.darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged() {
    _registerBloc.dispatch(
      EmailChanged(email: _emailController.text),
    );
  }

  void _onPasswordChanged() {
    _registerBloc.dispatch(
      PasswordChanged(password: _passwordController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.dispatch(
      Submitted(
        email: _emailController.text,
        password: _passwordController.text,
      ),
    );
  }

  void _onClearForm() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
    });
  }
}