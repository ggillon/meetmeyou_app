import 'package:flutter/src/widgets/editable_text.dart';
import 'package:meetmeyou_app/provider/base_provider.dart';

class EditProfileProvider extends BaseProvider{


  void setUserDetail(TextEditingController nameController){
    if(auth.currentUser==null){
     // auth.currentUser.reload();
    }
    var value=auth.currentUser?.displayName??"";
    nameController.value;

    notifyListeners();
  }

}