import 'package:chat_pro/models/last_message_model.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/provider/chat_provider.dart';
import 'package:chat_pro/utilities/date_time_extension.dart';
import 'package:flutter/material.dart';

class MyChatsScreenProvider with ChangeNotifier {
  final ChatProvider _chatProvider;
  final AuthenticationProvider _authProvider;

  MyChatsScreenProvider(this._chatProvider, this._authProvider);

  Stream<List<LastMessageModel>> get chatsStream {
    final uid = _authProvider.userModel?.uid ?? '';
    return _chatProvider.getChatsListStream(uid);
  }

  String getLastMessage(LastMessageModel chat) {
    final uid = _authProvider.userModel?.uid ?? '';
    final isMe = (chat.senderUID) == uid;
    return isMe ? 'You: ${chat.message}' : (chat.message);
  }

  String getFormattedTime(LastMessageModel chat) {
    return chat.timeSent.formattedTime();
  }
}
