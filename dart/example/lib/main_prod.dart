import 'package:app/common/config/app_config.dart';
import 'package:app/main_common.dart';

void main() {
  final config = AppConfig(
    // TODO: replace Bugfender key
    bugfenderKey: 'bJ9jywdfzbCM2wo3MfIpASQcFwA2Jjq7',
    // TODO: Add api endpoint
    apiUri: Uri.parse('https://api.example.com'),
    // TODO: Add pipe uri
    pipeUri: Uri.parse('https://example.com/leanpipe'),
    kratosUri: Uri.parse('https://auth.exampleapp.test.lncd.pl'),
    configCatSdkKey: 'LqLbCBSqfUCF8J0xspJ_rw/beuOvFkmn0ezv-0BeUzGsg',
    debugMode: false,
  );

  mainCommon(config);
}
