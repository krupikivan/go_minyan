import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_minyan/model/contactForm.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/resources/mailProvider.dart';
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/menu/bloc/form_bloc.dart';
import 'package:go_minyan/validators.dart';
import 'package:go_minyan/widget/text_model.dart';
import 'package:provider/provider.dart';

class MinianForm extends StatefulWidget {

  @override
  _MinianFormState createState() => _MinianFormState();
}

class _MinianFormState extends State<MinianForm> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  bool _autovalidate;
  ContactForm contact;

  bool darkmode;
  TextEditingController _nameController;
  TextEditingController _instController;
  TextEditingController _phoneController;
  TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _autovalidate = false;
    blocForm.changeProgress(false);
    contact = new ContactForm();
    _nameController = TextEditingController();
    _instController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    darkmode = Provider.of<AppModel>(context).darkmode;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Translations.of(context).newMinianTitle),
        backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
      ),
      body: Form(
                key: _formKey,
                autovalidate: _autovalidate,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  children: <Widget>[
                    SizedBox(height: 15,),
                    _nameFormField(),
                    SizedBox(height: 15,),
                    _instNameFormField(),
                    SizedBox(height: 15,),
                    _phoneFormField(),
                    SizedBox(height: 15,),
                    _emailFormField(),
                    _buttonFormField(),
                  ],
                )
            ),
    );
  }

  Widget _nameFormField(){
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      cursorColor: Theme.Colors.primaryColor,
      controller: _nameController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        icon: _getIcon(Icons.person),
        labelText: Translations
            .of(context)
            .name,
        labelStyle: TextStyle(
            color: darkmode ? Theme.Colors.hintDarkColor : Theme.Colors
                .hintColor),
      ),
      inputFormatters: [
        new LengthLimitingTextInputFormatter(15)
      ],
      validator: _validateName,
      onSaved: (val) => contact.name = val,
    );
  }
  ///VALIDATORS
  String _validateName(String value) {
    if (value.isEmpty)
      return Translations.of(context).nameValid;
    final RegExp nameExp = Validators.validateNameForm;
    if (!nameExp.hasMatch(value))
      return Translations.of(context).errorFormName;
    return null;
  }

  Widget _instNameFormField(){
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      cursorColor: Theme.Colors.primaryColor,
      controller: _instController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        icon: _getIcon(Icons.home),
        labelText: Translations
            .of(context)
            .lblName,
        labelStyle: TextStyle(
            color: darkmode ? Theme.Colors.hintDarkColor : Theme.Colors
                .hintColor),
      ),
      inputFormatters: [
        new LengthLimitingTextInputFormatter(15)
      ],
      validator: _validateName,
      onSaved: (val) => contact.instName = val,
    );
  }

  Widget _phoneFormField(){
    return TextFormField(
      cursorColor: Theme.Colors.primaryColor,
      controller: _phoneController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        icon: _getIcon(Icons.phone),
        labelText: Translations
            .of(context)
            .lblContact,
        labelStyle: TextStyle(
            color: darkmode ? Theme.Colors.hintDarkColor : Theme.Colors
                .hintColor),
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [
        WhitelistingTextInputFormatter.digitsOnly
      ],
      validator: _validatePhoneNumber,
      onSaved: (val) => contact.phone = val,
    );
  }
  ///VALIDATORS
  String _validatePhoneNumber(String value) {
    final RegExp phoneExp = Validators.validatePhoneForm;
    if (!phoneExp.hasMatch(value))
      return Translations.of(context).phoneValid;
    return null;
  }

  Widget _emailFormField(){
    return TextFormField(
      cursorColor: Theme.Colors.primaryColor,
      controller: _emailController,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey)),
        icon: _getIcon(Icons.email),
        labelText: Translations
            .of(context)
            .emailHint,
        labelStyle: TextStyle(
            color: darkmode ? Theme.Colors.hintDarkColor : Theme.Colors
                .hintColor),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: _validateEmail,
      onSaved: (val) => contact.email = val,
    );
  }
  ///VALIDATORS
  String _validateEmail(String value) {
    final RegExp emailExp = Validators.validateEmailForm;
    if (!emailExp.hasMatch(value))
      return Translations.of(context).emailValid;
    return null;
  }

  Widget _buttonFormField(){
    return StreamBuilder<bool>(
        stream: blocForm.showProgress,
        builder: (context, snapshot) {
          if (snapshot.data) {
            return Center(child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Theme.Colors.primaryColor),),);
          }
          else {
            return new Container(
                padding: const EdgeInsets.only(
                    left: 40.0, top: 20.0),
                child: new RaisedButton(
                  color: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors
                      .primaryColor,
                  textColor: Theme.Colors.secondaryColor,
                  child: Text(Translations
                      .of(context)
                      .submit),
                  onPressed: _submitForm,
                )
            );
          }
        }
    );
  }

  Widget _getIcon(IconData icon){
    return Icon(
      icon, color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor,
    );
  }

  void _submitForm() {
    FocusScope.of(context).requestFocus(new FocusNode());
    final FormState form = _formKey.currentState;
    MailProvider mailProvider = new MailProvider();
    if (!form.validate()) {
      _autovalidate = true;
      showInSnackBar(Translations.of(context).formError);
    } else {
      form.save(); //This invok
      blocForm.changeProgress(true);
      mailProvider.sendGMail(contact).then((value) {
        showInSnackBar(Translations.of(context).emailSent);
        _clearForm();
        blocForm.changeProgress(false);
      }
      ).catchError((err) {
        blocForm.changeProgress(false);
        showInSnackBar(Translations.of(context).emailNotSent);});
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: TextModel(text: value, color: Theme.Colors.secondaryColor), backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
    ));
  }

  void _clearForm(){
    _nameController.clear();
    _instController.clear();
    _phoneController.clear();
    _emailController.clear();
  }

}
