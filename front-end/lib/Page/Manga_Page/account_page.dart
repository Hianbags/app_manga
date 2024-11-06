import 'package:appmanga/Page/Shop_page/order_list_page.dart';
import 'package:appmanga/Service/User_Service/user_service.dart';
import 'package:appmanga/User/page/avatar_page.dart';
import 'package:appmanga/main.dart';
import 'package:flutter/material.dart';
import 'package:appmanga/UserPackage/UserLogin.dart';
import 'package:appmanga/Model/User_model/user_model.dart';


class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: UserService.getUserInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          bool hasUserData = snapshot.hasData && snapshot.data != null;
          return Scaffold(
            appBar: AppBar(
              title: Text('Tài khoản của bạn'),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    color: hasUserData ? Colors.grey : Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (hasUserData && snapshot.data!.avatar != null)
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(snapshot.data!.avatar),
                          )
                        else
                          CircleAvatar(
                            radius: 30,
                            child: Icon(Icons.person),
                          ),
                        SizedBox(width: 20),
                        hasUserData
                            ? Text(
                          snapshot.data!.name,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )
                            : SizedBox(),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  hasUserData
                      ? ElevatedButton(
                    onPressed: () {
                      UserService.logout();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => MyHomePage()),
                      );
                    },
                    child: Text('Đăng xuất'),
                  )
                      : ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text('Đăng nhập'),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AvatarPage()),
                      );
                    },
                    child: ListTile(
                      leading: Icon(Icons.image),
                      title: Text('Danh sách khung avatar'),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      print('Bấm vào Danh sách sticker của bạn');
                    },
                    child: ListTile(
                      leading: Icon(Icons.sticky_note_2),
                      title: Text('Danh sách sticker của bạn'),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      print('Bấm vào Danh hiệu');
                    },
                    child: ListTile(
                      leading: Icon(Icons.badge),
                      title: Text('Danh hiệu'),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      print('Bấm vào Bình luận của bạn');
                    },
                    child: ListTile(
                      leading: Icon(Icons.comment),
                      title: Text('Bình luận của bạn'),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                  SizedBox(height: 20),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderlistPage()),
                      );
                    },
                    child: ListTile(
                      leading: Icon(Icons.star),
                      title: Text('Đơn hàng của bạn'),
                      contentPadding: EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}


