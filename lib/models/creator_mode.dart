import 'package:meetmeyou_app/models/event.dart';
import 'package:meetmeyou_app/services/mmy/mmy_creator.dart';

class CreatorMode{
  MMYCreator? mmyCreator;
  Event? publicEvent;
  bool editPublicEvent = false;
  bool isLocationEvent = false;

}