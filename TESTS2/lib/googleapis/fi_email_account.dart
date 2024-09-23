//import 'package:connectx/utils/cx_log.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../backend/models/fi_user_email.dart';
import 'fi_authentication_client.dart';
import 'package:googleapis/gmail/v1.dart' as gmail;

class FiEmailAccount {
  GoogleSignInAccount? account;
  String? dbEmail ;
  late gmail.GmailApi _gmailApi;


  FiEmailAccount({this.account,this.dbEmail});

  String get email {
    return dbEmail!= null && dbEmail!.trim().isNotEmpty ? dbEmail! : account?.email??"" ;
  }

  Future<void> connectToEmails() async {
    try {
      if(account != null) {
        var headers = await account!.authHeaders;
        final authenticateClient = GoogleAuthClient(headers);
        _gmailApi = gmail.GmailApi(authenticateClient);
      }
      else {

      }
    } catch (err, stack) {
      //logger.d("Error: $err, stack = $stack");
    }
  }

  Future<FiUserEmail> toModel() async {

    var headers = account!= null ? await account!.authHeaders : null;

    FiUserEmail email = FiUserEmail(email: account != null? account!.email : this.email,headers:headers );
    return email ;
  }
}
