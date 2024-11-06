import 'package:appmanga/User/model/avatar_model.dart';
import 'package:appmanga/User/service/avatar_service.dart';
import 'package:flutter/material.dart';

class AvatarPage extends StatefulWidget {
  @override
  _AvatarPageState createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  late Future<List<Avatar>> futureAvatars;
  final AvatarService avatarService = AvatarService();
  int? selectedAvatarId;

  @override
  void initState() {
    super.initState();
    futureAvatars = avatarService.fetchAvatars();
  }

  void _changeAvatar() async {
    if (selectedAvatarId != null) {
      try {
        await avatarService.changeAvatar(selectedAvatarId!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đổi avatar thành công!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to change avatar: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách avatar'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<List<Avatar>>(
        future: futureAvatars,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No avatars found.'));
          } else {
            return GridView.builder(
              padding: EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final avatar = snapshot.data![index];
                final isSelected = selectedAvatarId == avatar.id;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedAvatarId = avatar.id;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.grey.shade300,
                        width: isSelected ? 4.0 : 1.0,
                      ),
                      borderRadius: BorderRadius.circular(12.0),
                      image: DecorationImage(
                        image: NetworkImage(avatar.image),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.check_circle,
                          color: Colors.blue,
                          size: 30.0,
                        ),
                      ),
                    )
                        : null,
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeAvatar,
        backgroundColor: Colors.blue,
        child: Icon(Icons.check, color: Colors.white),
      ),
      backgroundColor: Colors.white,
    );
  }
}
