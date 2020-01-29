import 'package:go_minyan/model/model.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class MailProvider{

  Future sendGMail(MarkerData newUser) async {
    String username = 'minyanfinder@gmail.com';
    String password = 'minyan1948';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Go Minyan')
      ..recipients.add(newUser.email)
      ..subject = 'Apertura de cuenta Go Minyan'
      ..html = "<h2>Datos</h2>\n<p>Nombre institucional: "+newUser.title+"</p>"
          "Email: "+newUser.email;
    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}

/*
 ..html = "<h2>New minyan request</h2>\n<p>Email: "+data.email+"</p>"
          "Institutional Name: "+newUser.instName+"</p>\n<p>Phone: "+newUser.phone+"</p>\n<p>Email: "+newUser.email +"</p>";
 */