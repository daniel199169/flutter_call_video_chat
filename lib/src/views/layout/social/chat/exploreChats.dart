import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:undraw/undraw.dart';
import 'package:waya/models/users/usersModel.dart';
import 'package:waya/utils/margin_utils.dart';

import 'ChatScreen.dart';
import 'providers/ChatListController.dart';

class ExploreChats extends StatefulWidget {
  ExploreChatsState createState() => new ExploreChatsState();
}

class ExploreChatsState extends State<ExploreChats> {
  ChatListController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatListController>(builder: (context, counter, _) {
      controller = Provider.of<ChatListController>(context);
      return new Scaffold(
        appBar: AppBar(
          title: Text('Explore Chats'),
        ),
        body: new Center(
          child: Column(children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Container(
                height: 87,
                child: TextField(
                  controller: controller.filter,
                  onChanged: (val) {
                    if (val.isEmpty) {
                      controller.isSearching = false;
                    } else {
                      controller.isSearching = true;
                    }
                  },
                  style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Search Name / WayaID',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.orange,
                      ),
                      hintStyle: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                      labelStyle: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 18,
                          fontWeight: FontWeight.w400)),
                  keyboardType: TextInputType.text,
                ),
              ),
            ),
            !controller.isLoading2
                ? Flexible(child: _buildList())
                : LinearProgressIndicator()
          ]),
        ),
      );
    });
  }

  Widget _buildAvatar(User contact) {
    return new CircleAvatar(
      child: Text(
          initials(
              contact?.fullName.split(' ')[0], contact?.fullName.split(' ')[1]),
          style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.deepOrange,
      radius: 30.0,
    );
  }

  Widget _buildList() {
    return controller?.exploreUserContact != null &&
            controller.exploreUserContact.length > 0
        ? ListView.builder(
            itemCount: controller.exploreUserContact?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              if (controller.isSearching) if (controller
                      .exploreUserContact[index].fullName
                      .toLowerCase()
                      .contains(controller.filter.text.toLowerCase()) ||
                  controller.exploreUserContact[index].userId
                      .toString()
                      .toLowerCase()
                      .contains(controller.filter.text.toLowerCase()))
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 3)
                      .add(EdgeInsets.only(top: index == 0 ? 20 : 3)),
                  child: Card(
                    elevation: 0.2,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: new ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => new ChatScreen(
                                contact: controller.exploreUserContact[index],
                                getProfileData: controller.profileData,
                              ),
                            ),
                          );
                        },
                        leading:
                            _buildAvatar(controller.exploreUserContact[index]),
                        title: Text(
                          controller.exploreUserContact[index].fullName,
                          style: TextStyle(
                              fontSize: 19, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                );
              else
                return Container();
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 18, vertical: 3)
                    .add(EdgeInsets.only(top: index == 0 ? 20 : 3)),
                child: Card(
                  elevation: 0.2,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: new ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => new ChatScreen(
                              contact: controller.exploreUserContact[index],
                              getProfileData: controller.profileData,
                            ),
                          ),
                        );
                      },
                      leading:
                          _buildAvatar(controller.exploreUserContact[index]),
                      title: Text(
                        controller.exploreUserContact[index].fullName,
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              );
            },
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.width * 0.5,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: UnDraw(
                    color: Colors.orange,
                    illustration: UnDrawIllustration.not_found,
                    placeholder: Container(
                      height: 23,
                      width: 23,
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: Icon(Icons.error_outline,
                        color: Colors.grey[200], size: 30),
                  ),
                ),
                customYMargin(5),
                Text(
                  'Oh My Waya Land is Empty',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey),
                ),
                customYMargin(90),
                controller.isLoading2
                    ? CircularProgressIndicator()
                    : Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: FlatButton(
                          color: Colors.green[500],
                          child: Text(
                            'RELOAD',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          onPressed: () {
                            controller.loadExploreData(context);
                          },
                        ))
              ]);
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    await Future.delayed(Duration(seconds: 1));
    controller.loadExploreData(context);
  }
}

String initials(first, lastName) {
  return ((first.isNotEmpty == true ? first[0] : "") +
          (lastName?.isNotEmpty == true ? lastName[0] : ""))
      .toUpperCase();
}
