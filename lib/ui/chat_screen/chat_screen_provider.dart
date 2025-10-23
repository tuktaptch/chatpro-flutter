
import 'package:chat_pro/ui/chat_screen/chat_screen.dart';
import 'package:flutter/material.dart';


class ChatScreenProvider with ChangeNotifier {
  String contactUID = '';
  String contactName = '';
  String contactImage = '';
  String? groupId;
  bool isGroupChat = false;

  

  void init(ChatScreenArguments args) async {
    await Future.delayed(const Duration(milliseconds: 800)); // จำลองโหลด
    contactUID = args.contactUID;
    contactName = args.contactName;
    contactImage = args.contactImage;
    groupId = args.groupId;
    // ✅ isGroupChat = true เฉพาะเมื่อ groupId ไม่ว่างและไม่ null
    isGroupChat = (groupId != null && groupId!.isNotEmpty);
    notifyListeners();
  }

  /// ✅ optional: ฟังก์ชัน reset ค่าเมื่อออกจากหน้าจอ chat
  void reset() {
    contactUID = '';
    contactName = '';
    contactImage = '';
    groupId = null;
    isGroupChat = false;
    notifyListeners();
  }

 
  
  
}
