import 'package:flutter/material.dart';

class CPinPutController with ChangeNotifier {
  final TextEditingController controller = TextEditingController();
  final FocusNode focusNode = FocusNode();
  bool isError = false;
  bool isVerifyPass = false;

  CPinPutController() {
    focusNode.addListener(() {
      notifyListeners(); // rebuild widget เมื่อ focus เปลี่ยน
    });
  }

  void clear() {
    controller.clear();
    isError = false;
    isVerifyPass = false;
    notifyListeners();
  }

  void setError(bool value) {
    isError = value;
    notifyListeners();
  }

  void setVerify(bool value) {
    isVerifyPass = value;
    notifyListeners();
  }

  void disposeAll() {
    controller.dispose();
    focusNode.dispose();
    dispose();
  }
}
