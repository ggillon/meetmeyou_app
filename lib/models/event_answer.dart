
class EventAnswer {
  EventAnswer ({required this.eid, required this.uid, required this.displayName, required this.email,  required this.attend, required this.fields, required this.answers, required this.timeStamp, });
  String eid;
  String uid;
  String displayName;
  String email;
  String attend;
  Map fields;
  Map answers;
  DateTime timeStamp;

  factory EventAnswer.fromMap(Map<String, dynamic> data) {

    final int timeStampMillisec = data['timeStamp'];

    final String eid= data['eid'];
    final String uid= data['uid'];
    final String displayName = data['displayName'];
    final String email = data['email'];
    final String attend = data['attend'];
    final Map fields = data['fields'];
    final Map answers = data['answers'];
    final DateTime timeStamp = DateTime.fromMillisecondsSinceEpoch(
        timeStampMillisec);

    return EventAnswer(eid: eid, uid: uid, displayName: displayName, email: email, attend: attend, fields: fields, answers: answers, timeStamp: timeStamp);
  }

  EventAnswer getFromMap(Map<String, dynamic> data) {
    final int timeStampMillisec = data['timeStamp'];

    final String eid= data['eid'];
    final String uid= data['uid'];
    final String displayName = data['displayName'];
    final String email = data['email'];
    final String attend = data['attend'];
    final Map fields = data['fields'];
    final Map answers = data['answers'];
    final DateTime timeStamp = DateTime.fromMillisecondsSinceEpoch(
        timeStampMillisec);

    return EventAnswer(eid: eid, uid: uid, displayName: displayName, email: email, attend: attend, fields: fields, answers: answers, timeStamp: timeStamp);
  }


  Map<String, dynamic> toMap() {
    return {
      'eid': eid,
      'uid': uid,
      'displayName': displayName,
      'email': email,
      'attend': attend,
      'fields': fields,
      'answers': answers,
      'timeStamp': timeStamp.millisecondsSinceEpoch,
    };
  }

}