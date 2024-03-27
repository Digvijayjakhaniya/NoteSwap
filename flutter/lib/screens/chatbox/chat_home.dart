import 'package:flutter/material.dart';
import 'package:noteswap/screens/chatbox/chat.dart';

class ChatUserList extends StatefulWidget {
  @override
  _ChatUserListState createState() => _ChatUserListState();
}

class _ChatUserListState extends State<ChatUserList> {
  final List<UserInfo> allUsers = [
    UserInfo(
        name: 'Digvijay',
        lastMessage: 'How are you?',
        lastMessageTime: DateTime.now()),
    UserInfo(
        name: 'Sandip',
        lastMessage: 'See you later!',
        lastMessageTime: DateTime.now().subtract(Duration(hours: 2))),
    UserInfo(
        name: 'Viral',
        lastMessage: 'What\'s up?',
        lastMessageTime: DateTime.now().subtract(Duration(minutes: 30))),
    UserInfo(
        name: 'Jayesh',
        lastMessage: 'Hello there!',
        lastMessageTime: DateTime.now().subtract(Duration(days: 1))),
  ];

  List<UserInfo> displayedUsers = [];

  // TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    displayedUsers = List.from(allUsers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Handle search button pressed
              // You can show a search bar or navigate to a search screen
              showSearch(
                context: context,
                delegate: ChatUserSearchDelegate(allUsers),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: displayedUsers.length,
        itemBuilder: (context, index) {
          final user = displayedUsers[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(user.name[0]),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(user.name),
                Text(
                  formatLastMessageTime(user.lastMessageTime),
                  style: TextStyle(color: Colors.black45, fontSize: 13),
                ),
              ],
            ),
            subtitle: Text(user.lastMessage),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatScreen(user.name)),
              );
            },
          );
        },
      ),
    );
  }

  String formatLastMessageTime(DateTime time) {
    return '${time.hour}:${time.minute}';
  }
}

class UserInfo {
  final String name;
  final String lastMessage;
  final DateTime lastMessageTime;

  UserInfo(
      {required this.name,
      required this.lastMessage,
      required this.lastMessageTime});
}

class ChatUserSearchDelegate extends SearchDelegate {
  final List<UserInfo> allUsers;

  ChatUserSearchDelegate(this.allUsers);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implement search results based on the query
    List<UserInfo> searchResults = allUsers
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final user = searchResults[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.lastMessage),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(user.name)),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // Suggestions based on the query
    List<UserInfo> suggestionList = allUsers
        .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        final user = suggestionList[index];
        return ListTile(
          title: Text(user.name),
          subtitle: Text(user.lastMessage),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ChatScreen(user.name)),
            );
          },
        );
      },
    );
  }
}
