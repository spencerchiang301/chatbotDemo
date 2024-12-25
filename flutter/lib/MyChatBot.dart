import 'package:choaidemo/MyHttp.dart';
import 'package:choaidemo/model/ChatModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyChatbot extends StatefulWidget {
  @override
  _MyChatbotState createState() => _MyChatbotState();
}

class _MyChatbotState extends State<MyChatbot> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isLiked = false;
  bool isFavorite = false;

  MyHttp _myHttp = MyHttp();
  final String _apiUrl = 'http://172.16.1.114:9000/chatbot'; // Replace with your server URL

  final List<Map<String, dynamic>> _chat = [];

  Future<void> _sendMessage(String userMessage) async {
    if (userMessage.isEmpty) return;

    setState(() {
      _chat.add({'role': 'user', 'message': userMessage});
    });

    try {
      ChatData retrieveChatData = await
      _myHttp.SearchResult(userMessage) as ChatData;

      if (retrieveChatData.responseStatus == 'Ok' && retrieveChatData.restaurantData != null) {
        print(retrieveChatData.restaurantData);
        setState(() {
          _chat.add(
              {'role': 'bot', 'restaurants': retrieveChatData.restaurantData});
        });
      }else {
        setState(() {
          _chat.add({'role': 'bot', 'message': retrieveChatData.responseResult});
        });
      }
    } catch (e) {
      setState(() {
        _chat.add({'role': 'bot', 'content': 'Error: Network issue or server not reachable'});
      });
    }

    // Scroll to the bottom
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent + 50,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _launchMaps(String address) async {
    final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$address');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the map')),
      );
    }
  }

  void _makePhoneCall(String phone) async {
    final Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not make the call')),
      );
    }
  }

  void _launchSocialMedia(String platform) async {
    String url = '';
    switch (platform) {
      case 'facebook':
        url = 'https://facebook.com';
        break;
      case 'instagram':
        url = 'https://instagram.com';
        break;
      case 'twitter':
        url = 'https://twitter.com';
        break;
    }
    if (url.isNotEmpty) {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $platform')),
        );
      }
    }
  }

  Widget _buildMessage(Map<String, dynamic> message) {
    if (message.containsKey('restaurants')) {
      final List<RestaurantData> restaurants = message['restaurants'];
      return Container(
        height: 640,
        child: PageView.builder(
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            return _buildCard(restaurants[index]);
          },
        ),
      );
    }

    bool isUser = message['role'] == 'user';
    return Container(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          message['message'] ?? '',
          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  Widget _buildCard(RestaurantData data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8, // Limits height to 80% of screen
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.name ?? 'No Name',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const Divider(),
                const Text(
                  "Menu:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(data.menu ?? 'No Menu Available'),
                const Divider(),
                const Text(
                  "Reason:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(data.reason ?? 'No Reason Provided'),
                const Divider(),
                const Text(
                  "Phone:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(data.phone ?? 'No Phone Number'),
                const Divider(),
                const Text(
                  "Address:",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(data.address ?? 'No Address'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Get.toNamed("/reservation");
                      },
                      icon: const Icon(Icons.rectangle_rounded, color: Colors.green,),
                      label: const Text('Order'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (data.phone != null) {
                          _makePhoneCall(data.phone!);
                        }
                      },
                      icon: const Icon(Icons.phone, color: Colors.deepPurpleAccent,),
                      label: const Text('Call'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (data.address != null) {
                          _launchMaps(data.address!);
                        }
                      },
                      icon: const Icon(Icons.place_rounded, color: Colors.red,),
                      label: const Text('Navigate', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      icon: Icon(
                        isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                        color: isLiked ? Colors.blue : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.thumb_down_outlined,
                        color: Colors.grey,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.facebook, color: Colors.blue),
                      onPressed: () => _launchSocialMedia('facebook'),
                    ),
                    IconButton(
                      icon: Icon(Icons.camera_alt, color: Colors.pink),
                      onPressed: () => _launchSocialMedia('instagram'),
                    ),
                    IconButton(
                      icon: Icon(Icons.alternate_email, color: Colors.blue),
                      onPressed: () => _launchSocialMedia('twitter'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Restaurant Guide Chatbot')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: _chat.length,
              itemBuilder: (context, index) => _buildMessage(_chat[index]),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: '  Enter your command',
                      hintStyle: TextStyle(color: Colors.grey), // Hint text color set to grey
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30)), // Circular border
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey), // Default border color
                        borderRadius: BorderRadius.all(Radius.circular(30)), // Circular border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue), // Border color when focused
                        borderRadius: BorderRadius.all(Radius.circular(30)), // Circular border
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.red,),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty) {
                      _sendMessage(_controller.text.trim());
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