import 'package:appmanga/Chat/page/chat.dart';
import 'package:appmanga/Chat/roomchat/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


Future<List<RoomChat>> fetchRooms() async {
  final response = await http.get(Uri.parse('https://magiabaiser.id.vn/api/room-chat'));
  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final List<dynamic> dataJson = jsonResponse['data'];
    return dataJson.map((json) => RoomChat.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load data');
  }
}

class FetchRoomsPage extends StatefulWidget {
  final String currentUserId;

  FetchRoomsPage({required this.currentUserId});

  @override
  _FetchRoomsPageState createState() => _FetchRoomsPageState();
}

class _FetchRoomsPageState extends State<FetchRoomsPage> {
  late Future<List<RoomChat>> futureRooms;

  @override
  void initState() {
    super.initState();
    futureRooms = fetchRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách phòng chat'),
      ),
      body: FutureBuilder<List<RoomChat>>(
        future: futureRooms,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Có lỗi xảy ra: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('Không có phòng chat nào'));
          }

          List<RoomChat> rooms = snapshot.data!;
          return ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              RoomChat room = rooms[index];
              return ListTile(
                title: Text(room.name),
                subtitle: Text(room.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        currentUserId: widget.currentUserId,
                        roomChat: room,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
