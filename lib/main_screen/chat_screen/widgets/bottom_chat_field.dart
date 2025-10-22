import 'dart:io';

import 'package:chat_pro/constraints/c_colors.dart';
import 'package:chat_pro/constraints/c_shadow.dart';
import 'package:chat_pro/constraints/c_typography.dart';
import 'package:chat_pro/enums/enums.dart';
import 'package:chat_pro/main_screen/chat_screen/widgets/message_reply_preview.dart';
import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:chat_pro/provider/chat_provider.dart';
import 'package:chat_pro/utilities/attachment_picker/attachment_picker.dart';
import 'package:chat_pro/utilities/global_method.dart';
import 'package:chat_pro/utilities/permission/permission.dart';
import 'package:chat_pro/widgets/attachment_picker_bottom_sheet/attachment_picker_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_record/flutter_sound_record.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class BottomChatField extends StatefulWidget {
  const BottomChatField({
    super.key,
    required this.contactUID,
    required this.contactName,
    required this.contactImage,
    required this.groupId,
  });

  final String contactUID;
  final String contactName;
  final String contactImage;
  final String groupId;

  @override
  State<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends State<BottomChatField> {
  FlutterSoundRecord? _soundRecord;
  late TextEditingController _textEditingController;
  late FocusNode _focusNode;
  File? finalFileImage;
  String filePath = '';
  bool _isFocused = false;

  bool isRecording = false;
  bool isShowSendButton = false;
  bool isSendingAudio = false;
  bool isShowEmojiPicker = false;
  @override
  void initState() {
    _textEditingController = TextEditingController();
    _soundRecord = FlutterSoundRecord();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _soundRecord?.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  // pick video from gallery
  Future<File?> pickVideo({required Function(String) onFail}) async {
    File? fileVideo;
    try {
      final pickedFile = await ImagePicker().pickVideo(
        source: ImageSource.gallery,
      );
      if (pickedFile == null) {
        onFail('No video selected');
      } else {
        fileVideo = File(pickedFile.path);
      }
    } catch (e) {
      onFail(e.toString());
    }

    return fileVideo;
  }

  // select a video file from device
  void selectVideo() async {
    File? fileVideo = await pickVideo(
      onFail: (String message) {
        showSnackBar(context, message, Type.failed);
      },
    );

    popContext();

    if (fileVideo != null) {
      filePath = fileVideo.path;
      // send video message to firestore
      sendFileMessage(messageType: MessageEnum.video);
    }
  }

  // start recording audio
  void startRecording() async {
    bool hasPermission = await CPermission.checkMicrophonePermission();
    if (hasPermission) {
      var tempDir = await getTemporaryDirectory();
      filePath = '${tempDir.path}/flutter_sound.aac';
      await _soundRecord!.start(path: filePath);
      setState(() {
        isRecording = true;
      });
    }
  }

  // stop recording audio
  void stopRecording() async {
    await _soundRecord!.stop();
    setState(() {
      isRecording = false;
      isSendingAudio = true;
    });
    // send audio message to firestore
    sendFileMessage(messageType: MessageEnum.audio);
  }

  // send text message to firestore
  void sendTextMessage() {
    final currentUser = context.read<AuthenticationProvider>().userModel!;
    final chatProvider = context.read<ChatProvider>();

    chatProvider.sendTextMessage(
      sender: currentUser,
      contactUID: widget.contactUID,
      contactName: widget.contactName,
      contactImage: widget.contactImage,
      message: _textEditingController.text,
      messageType: MessageEnum.text,
      groupId: widget.groupId,
      onSuccess: () {
        _textEditingController.clear();
        _focusNode.unfocus();
      },
      onError: (error) {
        showSnackBar(context, error, Type.failed);
      },
    );
  }

  // picp image from gallery or camera
  Future<File?> pickImage({
    required bool fromCamera,
    required Function(String) onFail,
  }) async {
    File? fileImage;
    if (fromCamera) {
      // get picture from camera
      try {
        final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.camera,
        );
        if (pickedFile == null) {
          onFail('No image selected');
        } else {
          fileImage = File(pickedFile.path);
        }
      } catch (e) {
        onFail(e.toString());
      }
    } else {
      // get picture from gallery
      try {
        final pickedFile = await ImagePicker().pickImage(
          source: ImageSource.gallery,
        );
        if (pickedFile == null) {
          onFail('No image selected');
        } else {
          fileImage = File(pickedFile.path);
        }
      } catch (e) {
        onFail(e.toString());
      }
    }

    return fileImage;
  }

  void selectImage(bool fromCamera) async {
    finalFileImage = await pickImage(
      fromCamera: fromCamera,
      onFail: (String message) {
        showSnackBar(context, message, Type.failed);
      },
    );

    // crop image
    await cropImage(finalFileImage?.path);

    popContext();
  }

  popContext() {
    Navigator.pop(context);
  }

  Future<void> cropImage(croppedFilePath) async {
    if (croppedFilePath != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: croppedFilePath,
        maxHeight: 800,
        maxWidth: 800,
        compressQuality: 90,
      );

      if (croppedFile != null) {
        filePath = croppedFile.path;
        // send image message to firestore
        sendFileMessage(messageType: MessageEnum.image);
      }
    }
  }

  // send image message to firestore
  void sendFileMessage({required MessageEnum messageType}) {
    final currentUser = context.read<AuthenticationProvider>().userModel!;
    final chatProvider = context.read<ChatProvider>();

    chatProvider.sendFileMessage(
      sender: currentUser,
      contactUID: widget.contactUID,
      contactName: widget.contactName,
      contactImage: widget.contactImage,
      file: File(filePath),
      messageType: messageType,
      groupId: widget.groupId,
      onSuccess: () {
        _textEditingController.clear();
        _focusNode.unfocus();
        setState(() {
          isSendingAudio = false;
        });
      },
      onError: (error) {
        setState(() {
          isSendingAudio = false;
        });
        showSnackBar(context, error, Type.failed);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final messageReply = chatProvider.messageReplyModel;
        final isMessageReply = messageReply != null;
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: CColors.pureWhite,

                  boxShadow: _isFocused ? null : CShadow.pinkLightShadow,
                ),
                child: Column(
                  children: [
                    isMessageReply ? MessageReplyPreview() : SizedBox.shrink(),
                    Row(
                      children: [
                        IconButton(
                          onPressed: isSendingAudio
                              ? null
                              : () async {
                                  {
                                    showModalBottomSheet(
                                      backgroundColor: CColors.pureWhite,
                                      context: context,
                                      builder: (context) {
                                        return SizedBox(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                // select image from camera
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.camera_alt,
                                                    color: CColors.hotPink,
                                                  ),
                                                  title: Text(
                                                    'Camera',
                                                    style: CTypography.title
                                                        .copyWith(
                                                          color:
                                                              CColors.hotPink,
                                                        ),
                                                  ),
                                                  onTap: () {
                                                    selectImage(true);
                                                  },
                                                ),
                                                // select image from gallery
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.image,
                                                    color: CColors.hotPink,
                                                  ),
                                                  title: Text(
                                                    'Gallery',
                                                    style: CTypography.title
                                                        .copyWith(
                                                          color:
                                                              CColors.hotPink,
                                                        ),
                                                  ),
                                                  onTap: () {
                                                    selectImage(false);
                                                  },
                                                ),
                                                // select a video file from device
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.video_library,
                                                    color: CColors.hotPink,
                                                  ),
                                                  title: Text(
                                                    'Video',
                                                    style: CTypography.title
                                                        .copyWith(
                                                          color:
                                                              CColors.hotPink,
                                                        ),
                                                  ),
                                                  onTap: () {
                                                    selectVideo();
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                },
                          icon: Icon(
                            Icons.attachment,
                            color: _isFocused
                                ? CColors.hotPink
                                : CColors.lightPink,
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            cursorColor: _isFocused
                                ? CColors.hotPink
                                : CColors.lightPink,
                            controller: _textEditingController,
                            focusNode: _focusNode,
                            decoration: InputDecoration(
                              hoverColor: CColors.hotPink,
                              hintText: 'Type a message',
                              hintStyle: CTypography.title.copyWith(
                                color: _isFocused
                                    ? CColors.hotPink
                                    : CColors.lightPink,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            onChanged: (value) => {
                              setState(() {
                                isShowSendButton = value.isNotEmpty;
                              }),
                            },
                          ),
                        ),
                        chatProvider.isLoading
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(),
                              )
                            : GestureDetector(
                                onTap: () {
                                  //send text message to firebase
                                  isShowSendButton ? sendTextMessage() : null;
                                },
                                onLongPress: () =>
                                    isShowSendButton ? null : startRecording(),
                                onLongPressUp: () => stopRecording(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: _isFocused
                                        ? CColors.hotPink
                                        : CColors.lightPink,
                                  ),
                                  margin: EdgeInsets.all(5),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: isShowSendButton
                                        ? Icon(
                                            Icons.arrow_upward,
                                            color: CColors.pureWhite,
                                          )
                                        : Icon(
                                            Icons.mic,
                                            color: CColors.pureWhite,
                                          ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickFiles(BuildContext context) async {
    final result = await pickAttachment(
      context: context,
      allowedExtensions: ['jpg', 'png'],
      allowedSources: [AttachmentSource.file, AttachmentSource.gallery],
    );
  }
}
