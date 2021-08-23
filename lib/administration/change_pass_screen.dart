import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_minyan/authentication_bloc/authentication_event.dart';
import 'package:go_minyan/authentication_bloc/bloc.dart';
import 'package:go_minyan/model/app_model.dart';
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/validators.dart';
import 'package:go_minyan/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:go_minyan/style/theme.dart' as Theme;

class ChangePassword extends StatefulWidget {

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  bool _autovalidate, darkmode;
  @override
  void initState() {
    super.initState();
    _autovalidate = false;
  }

  @override
  Widget build(BuildContext context) {
    darkmode = Provider.of<AppModel>(context).darkmode;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Translations.of(context).changePassword),
        backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
      ),
      body: Form(
          autovalidate: _autovalidate,
        key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              SizedBox(height: 15,),
              _passwordField(darkmode),
              SizedBox(height: 15,),
              _passwordFieldRepeat(darkmode),
              SizedBox(height: 15,),
              _buttonFormField(darkmode),
            ],
          )
      ),
    );
  }

  Widget _passwordField(darkmode){
    return TextFormField(
      controller: _passwordController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: darkmode ? Theme.Colors.hintDarkColor : Theme.Colors.hintColor)),
        icon: _getIcon(Icons.lock, darkmode),
        labelText: Translations.of(context).newPass,
        hintStyle: TextStyle(color: darkmode ? Theme.Colors.hintDarkColor : Theme.Colors.hintColor),
        labelStyle: TextStyle(color: darkmode ? Theme.Colors.hintDarkColor : Theme.Colors.hintColor),
      ),
      obscureText: true,
      cursorColor: Theme.Colors.primaryColor,
      validator: _validatePass,
    );
  }
  Widget _passwordFieldRepeat(darkmode){
    return TextFormField(
      controller: _repeatPasswordController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: darkmode ? Theme.Colors.hintDarkColor : Theme.Colors.hintColor)),
        icon: _getIcon(Icons.lock, darkmode),
        labelText: Translations.of(context).repeatPassHint,
        hintStyle: TextStyle(color: darkmode ? Theme.Colors.hintDarkColor : Theme.Colors.hintColor),
        labelStyle: TextStyle(color: darkmode ? Theme.Colors.hintDarkColor : Theme.Colors.hintColor),
      ),
      obscureText: true,
      cursorColor: Theme.Colors.primaryColor,
      validator: _validatePassRepeat,
    );
  }

  ///VALIDATORS
  String _validatePass(String value) {
    if (value.isEmpty)
      return Translations.of(context).invalidPass;
    final RegExp nameExp = Validators.validatePassForm;
    if (!nameExp.hasMatch(value))
      return Translations.of(context).invalidPass;
    return null;
  }
  String _validatePassRepeat(String value) {
    if (value.isEmpty)
      return Translations.of(context).invalidPass;
    final RegExp nameExp = Validators.validatePassForm;
    if (!nameExp.hasMatch(value))
      return Translations.of(context).invalidPass;
    if (value != _passwordController.text)
      return Translations.of(context).passNotMatch;
    return null;
  }

  Widget _buttonFormField(darkmode){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        RaisedButton(
      color: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors
          .primaryColor,
      textColor: Theme.Colors.secondaryColor,
      child: Text(Translations
          .of(context)
          .btnSave),
      onPressed: _submitForm,
    ),
        SizedBox(width: 20),
        RaisedButton(
          color: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors
              .primaryColor,
          textColor: Theme.Colors.secondaryColor,
          child: Text(Translations
              .of(context)
              .btnBack),
          onPressed: () => BlocProvider.of<AuthenticationBloc>(context).dispatch(LoggedIn()),
        )
      ],
    );
  }

  Widget _getIcon(IconData icon, darkmode){
    return Icon(
      icon, color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor,
    );
  }

  void _submitForm() {
    FocusScope.of(context).requestFocus(new FocusNode());
    final FormState form = _formKey.currentState;
      if (!form.validate()) {
        _autovalidate = true;
        showInSnackBar(Translations.of(context).formError);
      } else {
        form.save(); //This invok
        BlocProvider.of<AuthenticationBloc>(context).dispatch(ChangePass(_passwordController.text));
      }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: TextModel(text: value, color: Theme.Colors.secondaryColor), backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
    ));
  }

}
