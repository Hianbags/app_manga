import 'package:appmanga/Chat/roomchat/firebase.dart';
import 'package:flutter/material.dart';

class ChatPageRoom extends StatefulWidget {
  final int roomId;
  final String userId; // Add userId parameter

  ChatPageRoom({required this.roomId, required this.userId}); // Modify constructor

  @override
  _ChatPageRoomState createState() => _ChatPageRoomState();
}

class _ChatPageRoomState extends State<ChatPageRoom> {
  final TextEditingController _controller = TextEditingController();
  String? userName;

  @override
  void initState() {
    super.initState();
    _promptUserName();
  }

  void _promptUserName() async {
    String? chosenName = await showDialog<String>(
      context: context,
      builder: (context) {
        String tempName = "";
        return AlertDialog(
          title: Text('Enter your name or choose to be anonymous'),
          content: TextField(
            decoration: InputDecoration(labelText: 'Name'),
            onChanged: (value) {
              tempName = value;
            },
          ),
          actions: [
            TextButton(
              child: Text('Anonymous'),
              onPressed: () {
                Navigator.of(context).pop(null); // null means anonymous
              },
            ),
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(tempName);
              },
            ),
          ],
        );
      },
    );

    setState(() {
      userName = chosenName ?? 'Anonymous';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<MessageWithUser>>(
              stream: getMessagesWithUserDetails(widget.roomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(messages[index].message),
                        subtitle: Text('${messages[index].userName} - ${messages[index].timestamp}'),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Enter message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (userName != null) {
                      sendMessage(widget.roomId, _controller.text, widget.userId); // Use userId parameter
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
