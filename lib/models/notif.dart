import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationItems {
  final String username;
  final String userId;
  final String type;
  final String userProfile;
  final String postId;
  final String postUrl;
  final String text;
  final Timestamp timeStamp;
  final String notifId;
  final String folder;

  NotificationItems({
    this.notifId,
    this.postId,
    this.postUrl,
    this.text,
    this.timeStamp,
    this.type,
    this.userId,
    this.userProfile,
    this.username,
    this.folder,
  });

  static NotificationItems fromDocument(DocumentSnapshot doc) {
    var snapshot = doc.data() as Map<String, dynamic>;

    return NotificationItems(
      notifId: snapshot['notifId'],
      postId: snapshot['postId'],
      postUrl: snapshot['postUrl'],
      text: snapshot['text'],
      timeStamp: snapshot['timeStamp'],
      type: snapshot['type'],
      userId: snapshot['userId'],
      userProfile: snapshot['userProfile'],
      username: snapshot['username'],
      folder: snapshot['folder'],
    );
  }

  Map<String, dynamic> toJson() => {
        'notifId': notifId,
        'postId': postId,
        'postUrl': postUrl,
        'text': text,
        'timeStamp': timeStamp,
        'type': type,
        'userId': userId,
        'userProfile': userProfile,
        'username': username,
        'folder': folder,
      };
}
