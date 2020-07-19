import 'package:go_minyan/model/model.dart';
import 'package:mailer2/mailer.dart';

class MailProvider {
  static final options = new GmailSmtpOptions()
    ..username = 'minyanfinder@gmail.com'
    ..password = 'minyan1948';

  Future sendGMail(MarkerData newUser) async {
    //   String username = 'minyanfinder@gmail.com';
    //   String password = 'minyan1948';

    //   final smtpServer = gmail(username, password);

    //   final message = Message()
    //     ..from = Address(username, 'Go Minyan')
    //     ..recipients.add(newUser.email)
    //     ..subject = 'Apertura de cuenta Go Minyan'
    //     ..html = "<h2>Datos</h2>\n<p>Nombre institucional: " +
    //         newUser.title +
    //         "</p>"
    //             "Email: " +
    //         newUser.email;
    //   try {
    //     final sendReport = await send(message, smtpServer);
    //     print('Message sent: ' + sendReport.toString());
    //   } on MailerException catch (e) {
    //     // for (var p in e.problems) {
    //     //   print('Problem: ${p.code}: ${p.msg}');
    //     // }
    //     throw ('Message not sent.');
    //   }
    // }

    var emailTransport = new SmtpTransport(options);
    var envelope = new Envelope()
      ..from = 'minyanfinder@gmail.com'
      ..recipients.add(newUser.email)
      ..subject = 'Apertura de cuenta Go Minyan'
      ..html = "<h2>Datos</h2>\n<p>Nombre institucional: " +
          newUser.title +
          "</p>"
              "Email: " +
          newUser.email;

    try {
      await emailTransport.send(envelope);
    } catch (e) {
      throw 'Email not send';
    }
  }
}

/*
 ..html = "<h2>New minyan request</h2>\n<p>Email: "+data.email+"</p>"
          "Institutional Name: "+newUser.instName+"</p>\n<p>Phone: "+newUser.phone+"</p>\n<p>Email: "+newUser.email +"</p>";
 */
