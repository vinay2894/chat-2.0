class ChatModal {
  String msg, type;
  DateTime dateTime = DateTime.now();

  ChatModal({
    required this.msg,
    required this.type,
    required this.dateTime,
  });

  factory ChatModal.fromMap({required Map data}) {
    return ChatModal(
      msg: data['msg'],
      type: data['type'],
      dateTime: DateTime.fromMillisecondsSinceEpoch(data['dateTime']),
    );
  }

  Map<String, dynamic> get toMap {
    return {
      'msg': msg,
      'type': type,
      'dateTime': dateTime.millisecondsSinceEpoch,
    };
  }
}
