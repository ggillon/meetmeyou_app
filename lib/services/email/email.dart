import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:meetmeyou_app/services/email/password.dart';
import 'email_text.dart';

const EMAIL_ADDRESS = 'admin@meetmeyou.com';
const EMAIL_NAME = 'Admin MeetMeYou';

Future<bool> sendEmail({required List<String> emails, required String subject, required String message}) async {
  final smtpSever = SmtpServer('mail.gandi.net', port: 587, username: EMAIL_ADDRESS, password: EMAIL_PASSWORD);
  final email = Message()
    ..from = Address(EMAIL_ADDRESS, EMAIL_NAME)
    ..recipients = emails
    ..subject = subject
    ..text = message;
  try {
    await send(email, smtpSever);
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<void> sendOTPEmail(String email, String OTP) async {
  await sendEmail(
      emails: [email],
      subject: 'MeetMeYouOTP',
      message: EMAIL_TEXT_OTP_HEADER + OTP + EMAIL_TEXT_OTP_FOOTER);
}

Future<void> sendInvitesEmail(List<String> emails) async {
  await sendEmail(
      emails: emails,
      subject: 'MeetMeYou Invitation',
      message: EMAIL_TEXT_INVITATION);
}

