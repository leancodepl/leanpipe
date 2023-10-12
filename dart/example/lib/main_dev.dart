import 'package:app/common/config/app_config.dart';
import 'package:app/main_common.dart';

void main() {
  final config = AppConfig(
    // TODO: replace Bugfender key
    bugfenderKey: '00l0bRl0scod4VVsOc24x60Xdl747Pqd',
    // TODO: replace api uri
    apiUri: Uri.parse('https://exampleapp.test.lncd.pl/api/'),
    // TODO: replace pipe uri
    pipeUri: Uri.parse('https://exampleapp.test.lncd.pl/leanpipe'),
    configCatSdkKey: 'LqLbCBSqfUCF8J0xspJ_rw/VOk3Ffaud02lKDk9OuFeSA',
    kratosUri: Uri.parse('https://auth.exampleapp.test.lncd.pl'),
    debugMode: true,
  );

  mainCommon(config);
}
