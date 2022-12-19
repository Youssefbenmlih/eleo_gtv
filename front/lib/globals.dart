// ignore_for_file: non_constant_identifier_names

library globals;

import 'dart:io' show Platform;

String ipAndPortReal = "http://196.12.214.194:5002";

String testAndroidIp = "http://10.0.2.2:5002";

String testOtherIp = "http://127.0.0.1:5002";

bool test = false;

void ChangeTest() {
  test = !test;
  print(test ? "Test mode is on" : "Test Mode is Off");
}

String getIp() {
  if (test) {
    if (!Platform.isAndroid) {
      return testOtherIp;
    }
    return testAndroidIp;
  }
  return ipAndPortReal;
}
