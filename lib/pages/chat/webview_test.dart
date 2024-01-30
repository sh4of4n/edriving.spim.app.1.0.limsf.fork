import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import '../../common_library/services/database/database_helper.dart';
import '../../common_library/services/model/createroom_response.dart';
import '../../common_library/services/model/m_roommember_model.dart';
import '../../common_library/services/repository/chatroom_repository.dart';
import '../../common_library/utils/local_storage.dart';
import 'socketclient_helper.dart';

class TestWebview extends StatefulWidget {
  const TestWebview({super.key});

  @override
  State<TestWebview> createState() => _TestWebviewState();
}

class _TestWebviewState extends State<TestWebview> {
  late final WebViewController _controller;
  late io.Socket socket;
  final chatRoomRepo = ChatRoomRepo();
  final localStorage = LocalStorage();
  final dbHelper = DatabaseHelper.instance;
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final getSocket = Provider.of<SocketClientHelper>(context, listen: false);
      socket = getSocket.socket;
    });

    final WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith(
                'https://tbsweb.tbsdns.com/Tbs.Chat.Client.Web/DEVP/1_0/testwebview.html')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'messageHandler',
        onMessageReceived: (JavaScriptMessage message) async {
          var createChatSupportResult = await chatRoomRepo
              .createChatSupportByMemberFromWebView(message.message.toString());
          if (createChatSupportResult.data != null &&
              createChatSupportResult.data.length > 0) {
            if (!mounted) return;
            await context.read<SocketClientHelper>().loginUserRoom();
            String userid = await localStorage.getUserId() ?? '';
            CreateRoomResponse getCreateRoomResponse =
                createChatSupportResult.data[0];

            List<RoomMembers> roomMembers = await dbHelper
                .getRoomMembersList(getCreateRoomResponse.roomId!);
            for (var roomMember in roomMembers) {
              if (userid != roomMember.userId) {
                var inviteUserToRoomJson = {
                  "invitedRoomId": getCreateRoomResponse.roomId!,
                  "invitedUserId": roomMember.userId
                };
                socket.emitWithAck('inviteUserToRoom', inviteUserToRoomJson,
                    ack: (data) {
                  if (data != null) {
                    if (kDebugMode) {
                      print('inviteUserToRoomJson from server $data');
                    }
                  } else {
                    if (kDebugMode) {
                      print("Null from inviteUserToRoomJson");
                    }
                  }
                });
              }
            }
          }
          if (kDebugMode) {
            print(message.message.toString());
          }
          //context.router.push(RoomList());
          // ScaffoldMessenger.of(context).showSnackBar(
          //   SnackBar(content: Text(message.message)),
          // );
        },
      )
      ..loadRequest(Uri.parse(
          'https://tbsweb.tbsdns.com/Tbs.Chat.Client.Web/DEVP/1_0/testwebview.html'));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
