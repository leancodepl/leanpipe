import 'package:app/common/config/app_config.dart';
import 'package:app/main_common.dart';

// TODO: Override with the endpoint
final _defaultEndpoint = Uri.parse('https://exampleapp.test.lncd.pl/api/');

AppConfig _getTstConfig({Uri? apiEndpoint}) {
  return AppConfig(
    // TODO: Add Bugfender key
    bugfenderKey: '00l0bRl0scod4VVsOc24x60Xdl747Pqd',
    apiUri: apiEndpoint ?? _defaultEndpoint,
    // TODO: replace pipe uri
    pipeUri: Uri.parse('https://exampleapp.test.lncd.pl/leanpipe'),
    configCatSdkKey: 'LqLbCBSqfUCF8J0xspJ_rw/VOk3Ffaud02lKDk9OuFeSA',
    kratosUri: Uri.parse('https://auth.exampleapp.test.lncd.pl'),
    debugMode: true,
  );
}

Future<void> main() async {
  await mainCommon(_getTstConfig(apiEndpoint: _defaultEndpoint));
}
