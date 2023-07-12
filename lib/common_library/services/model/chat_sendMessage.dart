
import 'dart:typed_data';

class SendMessage
{
  String msgBody;
  ByteBuffer msgBinaryBuffer;
  String msgBinaryType;
  String replyToId;

  SendMessage({required this.msgBody,required this.msgBinaryBuffer,required this.msgBinaryType,required this.replyToId});

  factory SendMessage.fromJson(Map<String, dynamic> json) {
    return SendMessage(msgBody :json['msgBody'], msgBinaryBuffer:json['msgBinaryBuffer'], msgBinaryType:json['msgBinaryType'], replyToId:json['replyToId']);
  }
}