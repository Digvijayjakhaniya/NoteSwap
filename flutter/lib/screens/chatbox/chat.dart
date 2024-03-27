import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String userName;

  ChatScreen(this.userName);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<ChatMessage> messages = [
    ChatMessage(
        isSentByUser: false,
        message: 'Hello!',
        time: DateTime.now().subtract(Duration(days: 1))),
    ChatMessage(
        isSentByUser: false,
        message: 'How are you?',
        time: DateTime.now().subtract(Duration(hours: 22))),
    ChatMessage(
        isSentByUser: true,
        message: 'Hi there!',
        time: DateTime.now().subtract(Duration(hours: 20))),
    // Add more initial messages as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              // Add logic to display user avatar image
              child: Text(widget.userName[0]),
            ),
            SizedBox(width: 8.0),
            Text(widget.userName),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(
                Icons.phone,
                size: 25,
              ),
              onPressed: () {
                // Handle the phone icon pressed
                // You can implement a call functionality or any other action
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return messages[index];
              },
            ),
          ),
          ChatInput(
            onSendMessage: (message) {
              sendMessage(message);
            },
          ),
        ],
      ),
    );
  }

  void sendMessage(String message) {
    setState(() {
      messages.add(ChatMessage(
          isSentByUser: true, message: message, time: DateTime.now()));
    });

    // Simulate a response after a short delay
    Future.delayed(Duration(seconds: 1), () {
      receiveMessage('Thank you for your message!');
    });
  }

  void receiveMessage(String message) {
    setState(() {
      messages.add(ChatMessage(
          isSentByUser: false, message: message, time: DateTime.now()));
    });
  }
}

class ChatMessage extends StatelessWidget {
  final bool isSentByUser;
  final String message;
  final DateTime time;

  ChatMessage(
      {required this.isSentByUser, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSentByUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: isSentByUser
              ? Color(0xffA33DBA)
              : const Color.fromARGB(255, 154, 204, 245),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSentByUser ? 8.0 : 0.0),
            topRight: Radius.circular(isSentByUser ? 0.0 : 8.0),
            bottomLeft: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: 4.0),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      timeAgo(time),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String timeAgo(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'just now';
    }
  }
}

class ChatInput extends StatefulWidget {
  final Function(String) onSendMessage;

  ChatInput({required this.onSendMessage});

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.0),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              final message = _messageController.text.trim();
              if (message.isNotEmpty) {
                widget.onSendMessage(message);
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
