import 'package:flutter/material.dart';
import 'package:go_minyan/model/model.dart';
import 'package:go_minyan/style/theme.dart' as Theme;
import 'package:go_minyan/translation.dart';
import 'package:go_minyan/widget/mp_button_widget.dart';
import 'package:go_minyan/widget/widget.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    bool darkmode = Provider.of<AppModel>(context).darkmode;
    return Scaffold(
      appBar: AppBar(
        title: TextModel(text: Translations.of(context).aboutTitle),
        backgroundColor: darkmode ? Theme.Colors.primaryDarkColor : Theme.Colors.primaryColor,
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constrain) {
          var size = constrain.maxWidth;
          return Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextModel(text: Translations.of(context).appTitle, size: 30, fontWeight: FontWeight.w300,),
                ),
                Text("Version 3.2.0"),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                ),
                Row(
                  children: <Widget>[
                    Icon(Icons.copyright),
                    Expanded(
                        child: Text(Translations.of(context).aboutGoMinyan)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0, top: 10.0),
                ),
                Divider(
                  height: 20.0,
                  color: Colors.grey,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8.0),
                  alignment: Alignment.topLeft,
                  child: TextModel(text: Translations.of(context).aboutGoMinyan, size: 18, fontWeight: FontWeight.bold,),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextModel(text: Translations.of(context).appDesc),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton.icon(onPressed: _emailMe, icon: Icon(Icons.mail, size: 30), label: TextModel(text: Translations.of(context).emailMe, size: 18))
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FlatButton.icon(onPressed: () =>_showMercadoPago(context, size), icon: Icon(Icons.star, size: 30), label: TextModel(text: Translations.of(context).donateMe, size: 18))
                  ],
                )
              ],
            ),
          );
        }
      ),
    );
  }

  _showMercadoPago(BuildContext context, size) {
    bool darkmode = Provider.of<AppModel>(context).darkmode;
    Alert(
        context: context,
        closeFunction: null,
        title: Translations.of(context).donateMe,
        style: AlertStyle(
          titleStyle: TextStyle(color: darkmode ? Theme.Colors.secondaryColor : Theme.Colors.primaryColor,),
        ),
        content: Container(
              width: MediaQuery.of(context).size.width / 1.5,
              height: size < 400 ? MediaQuery.of(context).size.height / 3 : MediaQuery.of(context).size.width / 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      MPButtonWidget(
                        size: MediaQuery.of(context).size,
                        darkmode: darkmode,
                        onPressed: () => _mercadoPago(200),
                        text: '\$200',
                      ),
                      MPButtonWidget(
                        size: MediaQuery.of(context).size,
                        darkmode: darkmode,
                        onPressed: () => _mercadoPago(400),
                        text: '\$400',
                      ),
                      MPButtonWidget(
                        size: MediaQuery.of(context).size,
                        darkmode: darkmode,
                        onPressed: () => _mercadoPago(600),
                        text: '\$600',
                      ),
                      MPButtonWidget(
                        size: MediaQuery.of(context).size,
                        darkmode: darkmode,
                        onPressed: () => _mercadoPago(800),
                        text: '\$800',
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      MPButtonWidget(
                        size: MediaQuery.of(context).size,
                        darkmode: darkmode,
                        onPressed: () => _mercadoPago(1000),
                        text: '\$1000',
                      ),
                      MPButtonWidget(
                        size: MediaQuery.of(context).size,
                        darkmode: darkmode,
                        onPressed: () => _mercadoPago(2000),
                        text: '\$2000',
                      ),
                      MPButtonWidget(
                        size: MediaQuery.of(context).size,
                        darkmode: darkmode,
                        onPressed: () => _mercadoPago(5000),
                        text: '\$5000',
                      ),
                      MPButtonWidget(
                        size: MediaQuery.of(context).size,
                        darkmode: darkmode,
                        onPressed: () => _mercadoPago(8000),
                        text: '\$8000',
                      ),
                    ],
                  ),
                ],
              ),
            ),
        buttons: [
        ]).show();
  }

  void _emailMe()async{
    var url = 'mailto:kfarsoft@gmail.com?subject=Go Minyan APP&body=';
    if (await canLaunch(url)) {
    await launch(url);
    } else {
    throw 'Could not launch $url';
    }
  }

  void _mercadoPago(amount)async{
    var url = '';
    switch(amount){
      case 200: url = 'https://www.mercadopago.com.ar/checkout/v1/redirect?pref_id=135332969-a30dbba9-da70-4764-a8e0-17fbd0fb8a56';
      break;
      case 400: url = 'https://www.mercadopago.com.ar/checkout/v1/redirect?pref_id=135332969-ca45a9e9-2db3-4aa4-a0f0-e5dd48ca9d60';
      break;
      case 600: url = 'https://www.mercadopago.com.ar/checkout/v1/redirect?pref_id=135332969-56cac3fc-7f45-43d5-8413-033eee2a1800';
      break;
      case 800: url = 'https://www.mercadopago.com.ar/checkout/v1/redirect?pref_id=135332969-fcf6e0a6-a7f9-4010-bf8a-19242a2e9df1';
      break;
      case 1000: url = 'https://www.mercadopago.com.ar/checkout/v1/redirect?pref_id=135332969-7390cab6-76e6-453e-a1be-c52d13be73cf';
      break;
      case 2000: url = 'https://www.mercadopago.com.ar/checkout/v1/redirect?pref_id=135332969-534bf1c7-1703-4ce7-9589-43b89a796273';
      break;
      case 4000: url = 'https://www.mercadopago.com.ar/checkout/v1/redirect?pref_id=135332969-1e149e7d-fbe1-42a3-b284-c94bb11d4712';
      break;
      case 6000: url = 'https://www.mercadopago.com.ar/checkout/v1/redirect?pref_id=135332969-89fc5c8d-2ebd-4901-8b3a-2ad2933bd94e';
      break;
      case 8000: url = 'https://www.mercadopago.com.ar/checkout/v1/redirect?pref_id=135332969-a4ecf5ec-8f78-49af-ad40-c93fb922d1ff';
      break;

    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

}
