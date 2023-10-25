import 'package:app/common/config/app_config.dart';
import 'package:app/main_common.dart';

void main() {
  final config = AppConfig(
    apiUri: Uri.parse('https://exampleapp.test.lncd.pl/api/'),
    pipeUri: Uri.parse('https://exampleapp.test.lncd.pl/leanpipe'),
    kratosUri: Uri.parse('https://auth.exampleapp.test.lncd.pl'),
  );

  mainCommon(config);
}
