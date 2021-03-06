import 'package:flutter/material.dart';
import 'package:socail_network_flutter/views/Chat/widgets/chatlist.dart';

InputDecoration inputDecoration() {
  return InputDecoration(
      hintText: "Search...",
      hintStyle: TextStyle(color: Colors.grey.shade500),
      prefixIcon: Icon(
        Icons.search,
        color: Colors.grey.shade500,
        size: 20,
      ),
      fillColor: Colors.grey.shade100,
      contentPadding: EdgeInsets.all(8),
      border: UnderlineInputBorder(borderRadius: BorderRadius.circular(30)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade400)));
}

Align buildTextField(fieldController) {
  return Align(
    alignment: Alignment.bottomLeft,
    child: Container(
      padding: EdgeInsets.only(left: 16, bottom: 5),
      width: double.infinity,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
         Expanded(
           child:  Container(
             padding: EdgeInsets.only(right: 70,top: 5),
            child: TextField(
            keyboardType: TextInputType.multiline,
            maxLines: null,
            controller: fieldController,
            decoration: InputDecoration(
              hintText: "Type Message",
              hintStyle: TextStyle(color: Colors.grey.shade500),
              fillColor: Colors.grey.shade100,
              contentPadding: EdgeInsets.all(8),
              border: UnderlineInputBorder(borderRadius: BorderRadius.circular(30)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(color: Colors.grey.shade400),),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(30.0)),
                borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                ),
                textCapitalization: TextCapitalization.sentences,
              )
           ),
//            TextField(
//              keyboardType: TextInputType.multiline,
//              maxLines: null,
//              controller: fieldController,
//              decoration: InputDecoration(
//                  hintStyle: TextStyle(color: Colors.grey.shade500),
//                  hintText: "Type message...",
//                  border: InputBorder.none),
//              textCapitalization: TextCapitalization.sentences,
//            ),
          ),
        ],
      ),
    ),
  );
}

ListView buildListView(AsyncSnapshot snapshot) {
  return ListView.builder(
      itemCount: snapshot.data.length,
      itemBuilder: (_, index) {
        return ChatUserList(
          uid: snapshot.data[index].data['id'],
          displayName: snapshot.data[index].data['displayName'],
          photoUrl: snapshot.data[index].data['photoUrl'],
          email: snapshot.data[index].data['email'],
        );
      });
}

Widget getChatAppBar(context, name, photourl) {
  return AppBar(
      elevation: 10,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: EdgeInsets.only(right: 16),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 2,
              ),
              CircleAvatar(
                backgroundImage: NetworkImage(photourl),
                maxRadius: 20,
              ),
              SizedBox(
                width: 6,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      name,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.more_vert,
                color: Colors.grey.shade700,
              ),
            ],
          ),
        ),
      ));
}
