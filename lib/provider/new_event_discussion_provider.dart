import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meetmeyou_app/constants/routes_constants.dart';
import 'package:meetmeyou_app/enum/view_state.dart';
import 'package:meetmeyou_app/helper/dialog_helper.dart';
import 'package:meetmeyou_app/locator.dart';
import 'package:meetmeyou_app/models/calendar_detail.dart';
import 'package:meetmeyou_app/models/discussion.dart';
import 'package:meetmeyou_app/models/discussion_detail.dart';
import 'package:meetmeyou_app/models/discussion_message.dart';
import 'package:meetmeyou_app/models/event_detail.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';
import 'package:meetmeyou_app/services/mmy/mmy.dart';
import 'package:meetmeyou_app/view/home/group_image_view/group_image_view.dart';
import 'package:meetmeyou_app/view/home/view_image_screen/view_image_screen.dart';
import 'package:meetmeyou_app/view/home/view_video_screen/view_video_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class NewEventDiscussionProvider extends BaseProvider {
  MMYEngine? mmyEngine;
  Stream<List<DiscussionMessage>>? eventDiscussionListStream;
  List<DiscussionMessage> eventDiscussionList = [];
  Discussion? eventDiscussion;
  EventDetail eventDetail = locator<EventDetail>();
  DiscussionDetail discussionDetail = locator<DiscussionDetail>();
  CalendarDetail calendarDetail = locator<CalendarDetail>();
  ScrollController scrollController = ScrollController();
  bool? isRightSwipe;
  File? image;
  File? video;
  Timer? clockTimer;
  bool isJump = true;
  // these variable used in reply message functionality.
  String replyMessage = "";
  String replyMid = "";
  String userName = "";
  String replyMessageText = "";
  String replyMessageImageUrl = "";
  String imageUrl = "";
 // List<VideoPlayerController> videoPlayerController = [];

  bool swipe = false;

  updateSwipe(bool val) {
    swipe = val;
    notifyListeners();
  }

  @override
  void dispose() {
  //  clockTimer!.cancel();
    super.dispose();
  }

  Future getImage(BuildContext context, int type, bool fromContactOrGroup, bool fromChatScreen, String fromChatScreenDid) async {
    final picker = ImagePicker();
    // type : 1 for camera in , 2 for gallery and 3 for video gallery
    Navigator.of(context).pop();
    if (type == 1) {
      final pickedFile = await picker.pickImage(
          source: ImageSource.camera, imageQuality: 90, maxHeight: 720);
      // image = File(pickedFile!.path);
      // if(image != null || image != ""){
      //   Navigator.pushNamed(context, RoutesConstants.viewImageScreen, arguments: ViewImageData(image: image!, imageUrl: "", fromContactOrGroup: fromContactOrGroup, groupContactChatDid: discussion?.did ?? "", fromChatScreen: fromChatScreen, fromChatScreenDid: fromChatScreenDid)).then((value) {
      //     image = null;
      //     value == true ? getDiscussion(context, fromChatScreenDid) : getEventDiscussion(context, false);
      //   });
      // }
      // else{
      //   DialogHelper.showMessage(context, "no_image_selected".tr());
      // }
      if(pickedFile != null){
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          image = value;
          if(image != null){
            Navigator.pushNamed(context, RoutesConstants.viewImageScreen, arguments: ViewImageData(image: image!, imageUrl: "", fromContactOrGroup: fromContactOrGroup, groupContactChatDid: discussion?.did ?? "", fromChatScreen: fromChatScreen, fromChatScreenDid: fromChatScreenDid)).then((value) {
              image = null;
              value == true ? getDiscussion(context, fromChatScreenDid) : getEventDiscussion(context, false);
            });
          } else{
            DialogHelper.showMessage(context, "no_image_selected".tr());
          }
        });
      }
      notifyListeners();
    } else if(type == 2) {
      final pickedFile = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 90, maxHeight: 720);
      //  image = File(pickedFile!.path);
      // if (pickedFile != null) {
      //   image = File(pickedFile.path);
      //   if(image != null || image != ""){
      //     Navigator.pushNamed(context, RoutesConstants.viewImageScreen, arguments: ViewImageData(image: image!, imageUrl: "", fromContactOrGroup: fromContactOrGroup, groupContactChatDid: discussion?.did ?? "", fromChatScreen: fromChatScreen, fromChatScreenDid: fromChatScreenDid)).then((value) {
      //       image = null;
      //      value == true ? getDiscussion(context, fromChatScreenDid) : getEventDiscussion(context, false);
      //     });
      //   } else{
      //     DialogHelper.showMessage(context, "no_image_selected".tr());
      //   }
      // }
      if(pickedFile != null){
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          image = value;
          if(image != null){
            Navigator.pushNamed(context, RoutesConstants.viewImageScreen, arguments:
            ViewImageData(image: image!, imageUrl: "", fromContactOrGroup: fromContactOrGroup,
                groupContactChatDid: discussion?.did ?? "", fromChatScreen: fromChatScreen, fromChatScreenDid: fromChatScreenDid)).then((value) {
              image = null;
              value == true ? getDiscussion(context, fromChatScreenDid) : getEventDiscussion(context, false);
            });
          } else{
            DialogHelper.showMessage(context, "no_image_selected".tr());
          }
        });
      }
      else {
        print('No image selected.');
        return;
      }
      notifyListeners();
    } else{
      final pickedFile = await picker.pickVideo(
          source: ImageSource.gallery);
      if(pickedFile != null){
        video = File(pickedFile.path);
        var fileName = (video!.path.split('/').last);
        var format = fileName.split(".").last;
        Navigator.pushNamed(context, RoutesConstants.viewVideoScreen, arguments:
        ViewVideoScreen(viewVideoData: ViewVideoData(video: video, videoUrl: "", fromContactOrGroup: fromContactOrGroup, groupContactChatDid: discussion?.did ?? "", fromChatScreen: fromChatScreen, fromChatScreenDid: fromChatScreenDid), fromChat: true, format: format)).then((value) {
          video = null;
          value == true ? getDiscussion(context, fromChatScreenDid) : getEventDiscussion(context, false);
        }
        );
      } else{
        DialogHelper.showMessage(context, "no_video_selected".tr());
      }
      notifyListeners();
    }
  }


  bool value = true;

  updateValue(bool val) {
    value = val;
    notifyListeners();
  }

  Future getEventDiscussion(BuildContext context, bool load, {bool jump = true}) async {
    load == true ? setState(ViewState.Busy) : updateValue(true);
    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value =
        await mmyEngine!.getEventDiscussion(eventDetail.eid!).catchError((e) {
      load == true ? setState(ViewState.Idle) : updateValue(false);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    if (value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          jump == true ?
          scrollController.jumpTo(scrollController.position.maxScrollExtent)
              : scrollListener();
        }
      });
      eventDiscussion = value;
      setParticipantKeys(value);
      eventDiscussionListStream = value.messages;
      eventDiscussionListStream?.listen((value) {

        eventDiscussionList.clear();
        eventDiscussionList.addAll(value) ;
        eventDiscussionList.sort((a,b) {
          return a.createdTimeStamp.compareTo(b.createdTimeStamp);
        });
        eventDiscussionList.forEach((element) {
          if(element.type == VIDEO_MESSAGE){
            element.videoPlayerController = VideoPlayerController.network(element.attachmentURL)
              ..initialize().then((_) {
                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
                notifyListeners();
              });
          }
        });
        notifyListeners();
      });
      load == true ? setState(ViewState.Idle) : updateValue(false);
    }
  }

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent){
      isJump = true;
    }

    isJump ? scrollController
        .jumpTo(scrollController.position.maxScrollExtent) : Container();
  }

  bool postMessage = false;

  updatePostMessage(bool val) {
    postMessage = val;
    notifyListeners();
  }

  Future postDiscussionMessage(BuildContext context, String type, String text,
      TextEditingController controller, bool fromContactOrGroup, bool fromChatScreen, String fromChatScreenDid,
      {String? replyMid}) async {
    updatePostMessage(true);

    await mmyEngine!.postDiscussionMessage(fromChatScreen == true ? fromChatScreenDid : (fromContactOrGroup == true ? discussion!.did : eventDetail.eid!), type: type, text: text, photoURL: "", replyMid: replyMid)
        .catchError((e) {
      updatePostMessage(false);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    controller.clear();
    isRightSwipe = false;
    replyMessage = "";
    imageUrl = "";
    this.replyMid = "";
    fromChatScreen == true ? await getDiscussion(context, fromChatScreenDid) : (fromContactOrGroup == true ? await getDiscussion(context, discussion!.did) : await getEventDiscussion(context, false));
    updatePostMessage(false);
  }

// Leave a discussion

  bool leave = false;

  updateLeave(bool val) {
    leave = val;
    notifyListeners();
  }

  Future leaveDiscussion(BuildContext context, bool fromChatScreen, String chatID) async {
    Navigator.of(context).pop();
    updateLeave(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    await mmyEngine?.leaveDiscussion(fromChatScreen == true ? chatID : eventDetail.eid!).catchError((e) {
      updateLeave(false);
      DialogHelper.showMessage(context, "error_message".tr());
    });

    updateLeave(false);
  }

  // chat in contact and group.
// start discussion bw contact and group
  Discussion? discussion;

  bool startDiscussion = false;

  updateStartDiscussion(bool val) {
    startDiscussion = val;
    notifyListeners();
  }

  Future startContactDiscussion(BuildContext context) async {
    updateStartDiscussion(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.startContactDiscussion(discussionDetail.userId.toString()).catchError((e) {
      updateStartDiscussion(false);
      DialogHelper.showMessage(context, e.message);
    });


    if (value != null) {
      discussion = value;
      await getDiscussion(context, discussion!.did);
      updateStartDiscussion(false);
    }
  }

  // Retreive an discussion you're part of

  bool retrieveDiscussion = false;

  updateRetrieveDiscussion(bool val){
    retrieveDiscussion = true;
    notifyListeners();
  }

  Future getDiscussion(BuildContext context, String did, {bool jump = true, bool fromChatScreen = false}) async{
   fromChatScreen == true ?  setState(ViewState.Busy) : updateRetrieveDiscussion(true);

    mmyEngine = locator<MMYEngine>(param1: auth.currentUser);

    var value = await mmyEngine!.getDiscussion(did).catchError((e) {
      fromChatScreen == true ?  setState(ViewState.Idle) : updateRetrieveDiscussion(false);
      DialogHelper.showMessage(context, e.message);
    });

    if (value != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (scrollController.hasClients) {
          jump == true ?
          scrollController.jumpTo(scrollController.position.maxScrollExtent)
              : scrollListener();
        }
      });
      eventDiscussion = value;
      setParticipantKeys(value);
      eventDiscussionListStream = value.messages;
      eventDiscussionListStream?.listen((value) {

        eventDiscussionList.clear();
        eventDiscussionList.addAll(value) ;
        eventDiscussionList.sort((a,b) {
          return a.createdTimeStamp.compareTo(b.createdTimeStamp);
        });
        print(eventDiscussionList);
        eventDiscussionList.forEach((element) {
          if(element.type == VIDEO_MESSAGE){
            element.videoPlayerController = VideoPlayerController.network(element.attachmentURL)
              ..initialize().then((_) {
                // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
               notifyListeners();
              });
          }
        });
       notifyListeners();
      });

      fromChatScreen == true ?  setState(ViewState.Idle) : updateRetrieveDiscussion(false);
    }
  }

  // find out participants keys in chat

  setParticipantKeys(Discussion chatDiscussion){
    List<String> keysList = [];
    for (var key in chatDiscussion.participants.keys) {
      keysList.add(key);

      eventDetail.attendingProfileKeys = keysList;
    }
  }

  // StreamController<DiscussionMessage> discussionMessagesController = StreamController.broadcast();
  //
  // void addMessages(DiscussionMessage message) {
  //   discussionMessagesController.sink.add(message);
  // }
  //
  // bool getStreamMessage = false;
  //
  // updateGetStreamMessages(bool val){
  //   getStreamMessage = val;
  //   notifyListeners();
  // }
  //
  // void getMessagesList() {
  //   updateGetStreamMessages(true);
  //   discussionMessagesController.stream.listen((data) {
  //   //  eventDiscussionList.clear();
  //     eventDiscussionList.add(data);
  //     eventDiscussionList.sort((a,b) {
  //       return a.createdTimeStamp.compareTo(b.createdTimeStamp);
  //     });
  //     print(eventDiscussionList);
  //     updateGetStreamMessages(false);
  //   }, onDone: () {}, onError: (error) {});
  // }

  // Change title and to of discussion

 bool titleAndPhoto = false;

  updateTitleAndPhoto(bool val){
    titleAndPhoto = val;
    notifyListeners();
  }

  File? groupImage;

  Future changeGroupImage(BuildContext context, int type, bool fromChatScreen, String chatDid) async {
    final picker = ImagePicker();
    // type : 1 for camera in and 2 for gallery
    Navigator.of(context).pop();
    if (type == 1) {
      final pickedFile = await picker.pickImage(source: ImageSource.camera, imageQuality: 90, maxHeight: 720);
     // groupImage = File(pickedFile!.path);
      if(pickedFile != null){
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          groupImage = value;
          Navigator.pushNamed(context, RoutesConstants.groupImageView, arguments: GroupImageData(groupImage: groupImage!, fromChatScreen: fromChatScreen, did: fromChatScreen == true ? chatDid: discussion!.did)).then((value) {
            groupImage = null;
            fromChatScreen == true ?  getDiscussion(context, chatDid, fromChatScreen: fromChatScreen) : startContactDiscussion(context);
          });
        });
      }
      notifyListeners();
    } else {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery, imageQuality: 90, maxHeight: 720);
      if (pickedFile != null) {
       // groupImage = File(pickedFile.path);
        Navigator.pushNamed(context, RoutesConstants.imageCropper, arguments: File(pickedFile.path)).then((dynamic value) async {
          groupImage = value;
          Navigator.pushNamed(context, RoutesConstants.groupImageView, arguments: GroupImageData(groupImage: groupImage!, fromChatScreen: fromChatScreen, did: fromChatScreen == true ? chatDid: discussion!.did)).then((value) {
            groupImage = null;
            fromChatScreen == true ?  getDiscussion(context, chatDid, fromChatScreen: fromChatScreen) : startContactDiscussion(context);
          });
        });
        // Navigator.pushNamed(context, RoutesConstants.groupImageView, arguments: GroupImageData(groupImage: groupImage!, fromChatScreen: fromChatScreen, did: fromChatScreen == true ? chatDid: discussion!.did)).then((value) {
        //   groupImage = null;
        //   fromChatScreen == true ?  getDiscussion(context, chatDid, fromChatScreen: fromChatScreen) : startContactDiscussion(context);
        //
        // });
      } else {
        print('No image selected.');
        return;
      }
      notifyListeners();
    }
  }

  Future updateDiscussionTitle(BuildContext context, String did, bool fromChatScreen, {String? title, File? photo}) async{
    Navigator.of(context).pop();
    updateTitleAndPhoto(true);

   var value =  await mmyEngine?.updateDiscussion(did, title: title.toString()).catchError((e) {
     updateTitleAndPhoto(false);
     DialogHelper.showMessage(context, e.message);
   });

   fromChatScreen == true ?  await getDiscussion(context, did, fromChatScreen: fromChatScreen) : startContactDiscussion(context);

   if(value != null){
     updateTitleAndPhoto(false);
   }

  }


}
