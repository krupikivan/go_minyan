import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_minyan/register/register.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/widget/widget.dart';

import '../authentication_bloc/authentication_bloc.dart';
import '../authentication_bloc/authentication_event.dart';

class RegisterForm extends StatefulWidget {
  final bool darkmode;

  const RegisterForm({Key key, this.darkmode}) : super(key: key);
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _instController = TextEditingController();

  RegisterBloc _registerBloc;

  bool get isPopulated =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty &&
      _phoneController.text.isNotEmpty &&
      _instController.text.isNotEmpty &&
      _instController.text.isNotEmpty;

  bool isRegisterButtonEnabled(RegisterState state) {
    return state.isFormValid && isPopulated && !state.isSubmitting;
  }

  bool isUser;

  @override
  void initState() {
    super.initState();
    isUser = false;
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
    _phoneController.addListener(_onPhoneChange);
    _instController.addListener(_onNameChange);
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
                    CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            Theme.Colors.primaryColor)),
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
                    Text(Translations.of(context).emailSent,
                        maxLines: 2,
                        style: TextStyle(color: Theme.Colors.secondaryColor)),
                  ],
                ),
                backgroundColor: widget.darkmode
                    ? Theme.Colors.primaryDarkColor
                    : Theme.Colors.primaryColor,
              ),
            );
          _onClearForm();
        }
        if (state.isFailure) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextModel(
                        text: Translations.of(context).emailNotSent,
                        color: Theme.Colors.secondaryColor,
                      ),
                    ),
                    Expanded(
                      child: Icon(
                        Icons.error,
                        color: Theme.Colors.secondaryColor,
                      ),
                    ),
                  ],
                ),
                backgroundColor: widget.darkmode
                    ? Theme.Colors.primaryDarkColor
                    : Theme.Colors.primaryColor,
              ),
            );
        }
        if (state.isDuplicate) {
          Scaffold.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextModel(
                      text: Translations.of(context).emailDuplicate,
                      color: Theme.Colors.secondaryColor,
                    ),
                    Icon(
                      Icons.warning,
                      color: Theme.Colors.secondaryColor,
                    ),
                  ],
                ),
                backgroundColor: widget.darkmode
                    ? Theme.Colors.primaryDarkColor
                    : Theme.Colors.primaryColor,
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
                  ChoiceChip(
                      selected: isUser,
                      backgroundColor: Theme.Colors.primaryColor,
                      labelStyle: TextStyle(color: Colors.white),
                      selectedColor: Theme.Colors.primaryDarkColor,
                      label: Text(
                          isUser ? 'Cargar un Minian' : 'Cargar un usuario'),
                      onSelected: (value) {
                        setState(() {
                          isUser = value;
                          _onClearForm();
                        });
                      }),
                  _instNameBox(state),
                  SizedBox(
                    height: 10.0,
                  ),
                  _phoneBox(state),
                  SizedBox(
                    height: 10.0,
                  ),
                  _emailBox(state),
                  SizedBox(
                    height: 10.0,
                  ),
                  _passwordBox(state),
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
                      SizedBox(
                        width: 20,
                      ),
                      RegisterButton(
                        name: Translations.of(context).btnClear,
                        onPressed: _onClearForm,
                        darkmode: widget.darkmode,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      RegisterButton(
                        name: Translations.of(context).btnBack,
                        onPressed: () =>
                            BlocProvider.of<AuthenticationBloc>(context)
                                .dispatch(AppStarted()),
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

  Widget _instNameBox(state) {
    return TextFormField(
      autovalidate: true,
      textCapitalization: TextCapitalization.words,
      cursorColor: Theme.Colors.primaryColor,
      controller: _instController,
      decoration: InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        icon: _getIcon(isUser ? Icons.person_pin : Icons.home),
        labelText: isUser
            ? Translations.of(context).lblUserName
            : Translations.of(context).lblName,
        labelStyle: TextStyle(
            color: widget.darkmode
                ? Theme.Colors.hintDarkColor
                : Theme.Colors.hintColor),
      ),
      inputFormatters: [new LengthLimitingTextInputFormatter(15)],
      validator: (_) {
        return !state.isNameValid ? Translations.of(context).nameValid : null;
      },
//      validator: Validators().validateName,
    );
  }

  Widget _phoneBox(RegisterState state) {
    return TextFormField(
      autovalidate: true,
      cursorColor: Theme.Colors.primaryColor,
      controller: _phoneController,
      decoration: InputDecoration(
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        icon: _getIcon(isUser ? Icons.person_pin : Icons.phone),
        labelText: isUser
            ? Translations.of(context).lblUserLastName
            : Translations.of(context).lblContact,
        labelStyle: TextStyle(
            color: widget.darkmode
                ? Theme.Colors.hintDarkColor
                : Theme.Colors.hintColor),
      ),
      keyboardType: isUser ? TextInputType.text : TextInputType.phone,
      inputFormatters:
          !isUser ? [WhitelistingTextInputFormatter.digitsOnly] : null,
      validator: (_) {
        return !state.isPhoneValid
            ? isUser
                ? Translations.of(context).nameValid
                : Translations.of(context).phoneValid
            : null;
      },
//      validator: Validators().validatePhoneNumber,
    );
  }

  Widget _emailBox(state) {
    return TextFormField(
      autovalidate: true,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: widget.darkmode
                    ? Theme.Colors.hintDarkColor
                    : Theme.Colors.hintColor)),
        icon: _getIcon(Icons.email),
        labelText: Translations.of(context).emailHint,
        hintStyle: TextStyle(
            color: widget.darkmode
                ? Theme.Colors.hintDarkColor
                : Theme.Colors.hintColor),
        labelStyle: TextStyle(
            color: widget.darkmode
                ? Theme.Colors.hintDarkColor
                : Theme.Colors.hintColor),
      ),
      cursorColor: Theme.Colors.primaryColor,
      validator: (_) {
        return !state.isEmailValid
            ? Translations.of(context).invalidMail
            : null;
      },
    );
  }

  Widget _passwordBox(state) {
    return TextFormField(
      controller: _passwordController,
      autovalidate: true,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: widget.darkmode
                    ? Theme.Colors.hintDarkColor
                    : Theme.Colors.hintColor)),
        icon: _getIcon(Icons.lock),
        labelText: Translations.of(context).passHint,
        hintStyle: TextStyle(
            color: widget.darkmode
                ? Theme.Colors.hintDarkColor
                : Theme.Colors.hintColor),
        labelStyle: TextStyle(
            color: widget.darkmode
                ? Theme.Colors.hintDarkColor
                : Theme.Colors.hintColor),
      ),
      obscureText: true,
      cursorColor: Theme.Colors.primaryColor,
      validator: (_) {
        return !state.isPasswordValid
            ? Translations.of(context).invalidPass
            : null;
      },
    );
  }

  Widget _getIcon(IconData icon) {
    return Icon(
      icon,
      color: widget.darkmode
          ? Theme.Colors.secondaryColor
          : Theme.Colors.primaryColor,
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _instController.dispose();
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

  void _onPhoneChange() {
    _registerBloc.dispatch(
      !isUser
          ? PhoneChange(phone: _phoneController.text)
          : NameChange(name: _phoneController.text),
    );
  }

  void _onNameChange() {
    _registerBloc.dispatch(
      NameChange(name: _instController.text),
    );
  }

  void _onFormSubmitted() {
    _registerBloc.dispatch(
      Submitted(
        isUser: isUser,
        email: _emailController.text,
        password: _passwordController.text,
        title: _instController.text,
        contact: _phoneController.text,
      ),
    );
  }

  void _onClearForm() {
    setState(() {
      _emailController.clear();
      _passwordController.clear();
      _phoneController.clear();
      _instController.clear();
    });
  }
}
