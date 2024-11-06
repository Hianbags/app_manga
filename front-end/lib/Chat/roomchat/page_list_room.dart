import 'package:appmanga/Chat/roomchat/model.dart';
import 'package:appmanga/Chat/roomchat/page_chat_room.dart';
import 'package:appmanga/Chat/roomchat/service.dart';
import 'package:flutter/material.dart';

class RoomListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rooms'),
      ),
      body: FutureBuilder<List<RoomChat>>(
        future: fetchRooms(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final rooms = snapshot.data!;
            return ListView.builder(
              itemCount: rooms.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(rooms[index].name),
                  subtitle: Text(rooms[index].description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPageRoom(roomId: rooms[index].id,userId: '111',),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
