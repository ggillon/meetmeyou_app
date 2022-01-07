import 'package:meetmeyou_app/constants/color_constants.dart';
import 'package:meetmeyou_app/models/event.dart' as eventModel;

class CommonEventFunction{

 static getEventBtnStatus(eventModel.Event event, String userCid) {
    List<String> keysList = [];
    for (var key in event.invitedContacts.keys) {
      keysList.add(key);
    }
    List<String> valuesList = [];
    for (var value in event.invitedContacts.values) {
      valuesList.add(value);
    }
    for (int i = 0; i < keysList.length; i++) {
      if (keysList[i] == userCid) {
        if (valuesList[i] == "Invited") {
          return "respond";
        } else if (valuesList[i] == "Organiser") {
          return "edit";
        } else if (valuesList[i] == "Attending") {
          return "going";
        } else if (valuesList[i] == "Not Attending") {
          return "not_going";
        } else if (valuesList[i] == "Not Interested") {
          return "hidden";
        } else if (valuesList[i] == "Canceled") {
          return "cancelled";
        }
      }
    }
    return "";
  }

 static getEventBtnColorStatus(eventModel.Event event, String userCid,{bool textColor = true}) {
    List<String> keysList = [];
    for (var key in event.invitedContacts.keys) {
      keysList.add(key);
    }
    List<String> valuesList = [];
    for (var value in event.invitedContacts.values) {
      valuesList.add(value);
    }
    for (int i = 0; i < keysList.length; i++) {
      if (keysList[i] == userCid) {
        if (valuesList[i] == "Invited") {
          return textColor
              ? ColorConstants.colorWhite
              : ColorConstants.primaryColor;
        } else if (valuesList[i] == "Organiser") {
          return textColor
              ? ColorConstants.colorWhite
              : ColorConstants.primaryColor;
        } else if (valuesList[i] == "Attending") {
          return textColor
              ? ColorConstants.primaryColor
              : ColorConstants.primaryColor.withOpacity(0.2);
        } else if (valuesList[i] == "Not Attending") {
          return textColor
              ? ColorConstants.primaryColor
              : ColorConstants.primaryColor.withOpacity(0.2);
        } else if (valuesList[i] == "Not Interested") {
          return textColor
              ? ColorConstants.primaryColor
              : ColorConstants.primaryColor.withOpacity(0.2);
        } else if (valuesList[i] == "Canceled") {
          return textColor
              ? ColorConstants.primaryColor
              : ColorConstants.primaryColor.withOpacity(0.2);
        }
      }
    }
  }

}