import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:go_minyan/model/contactForm.dart';

class MailProvider{

  Future sendGMail(ContactForm contact) async {
    String username = 'minyanfinder@gmail.com';
    String password = 'minyan1948';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'MINYAN APP')
      ..recipients.add('kfarsoft@gmail.com')
      ..subject = 'Mail from Minyan APP'
      ..html = "<h2>New minyan request</h2>\n<p>Name: "+contact.name+"</p>"
          "Institutional Name: "+contact.instName+"</p>\n<p>Phone: "+contact.phone+"</p>\n<p>Email: "+contact.email +"</p>";
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