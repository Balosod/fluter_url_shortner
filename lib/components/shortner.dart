import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class Shortner extends StatefulWidget {
  const Shortner({super.key});

  @override
  State<Shortner> createState() => _ShortnerState();
}

class _ShortnerState extends State<Shortner> {
  List<Map<String, String>> links = [];
  final TextEditingController _urlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void onShorten(link) async {
      final url = Uri.parse('https://ur-tuki.onrender.com/api/post-link');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"link": link}),
      );

      if (response.statusCode == 200) {
        setState(() {
          final responseData = jsonDecode(response.body);

          links.add({
            "link": link,
            "shorted_link":
                "https://ur-tuki.onrender.com/api/get-link/${responseData['message']['shorted_link']}"
          });
        });
      } else {
        print("Failed to send data");
      }
    }

    void copyToClipboard(String link) {
      Clipboard.setData(ClipboardData(text: link)).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Link copied to clipboard!')),
        );
      });
    }

    void viewUrl(String url) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => WebViewScreen(url: url)),
      );
    }

    return Scaffold(
        backgroundColor: const Color(0xFFE5E7EB),
        body: (SafeArea(
            child: ListView(
          padding: EdgeInsets.all(50),
          children: [
            Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: Color.fromRGBO(59, 48, 84, 1),
                    child: SvgPicture.asset(
                      'assets/images/bg-shorten-desktop.svg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                  child: Column(
                    children: [
                      TextField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          labelText: "Long Url",
                          labelStyle: TextStyle(
                              color: Color.fromARGB(169, 1, 121, 105)),
                          border: OutlineInputBorder(),
                          hintText: 'Enter your url',
                          hintStyle: TextStyle(
                              color: Color.fromARGB(169, 1, 121, 105)),
                          filled: true, // Enable filling
                          fillColor:
                              Colors.white, // Set background color to white
                        ),
                        autofocus: true,
                        onSubmitted: (_) =>
                            {onShorten(_urlController.text.trim())},
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          onShorten(_urlController.text.trim());
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(1000, 50), // Width and height
                          backgroundColor: Color.fromARGB(255, 64, 255, 230),
                          shape: RoundedRectangleBorder(
                            // Remove default border radius
                            borderRadius: BorderRadius.zero, // No rounding
                          ),
                        ),
                        child: const Text(
                          'Shorten it!',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            // links.isEmpty
            //     ? SizedBox.shrink()
            Container(
                child: ListView.builder(
                    shrinkWrap: true, // Ensures it only takes necessary space
                    physics:
                        NeverScrollableScrollPhysics(), // Disables scrolling inside ListView
                    itemCount: links.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          // Add padding around each item for spacing
                          padding: const EdgeInsets.only(
                              bottom: 20), // Space between each item
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize
                                  .min, // Ensures content is centered vertically
                              mainAxisAlignment: MainAxisAlignment
                                  .center, // Center align the children
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 10),
                                  child: Text(links[index]['link']!,
                                      overflow: TextOverflow
                                          .ellipsis, // Truncates text with "..."
                                      maxLines: 1,
                                      style: TextStyle(
                                          color: Colors
                                              .black) // Ensures only one line is shown
                                      ),
                                ),
                                const SizedBox(height: 10), // Adds spacing
                                const Divider(
                                  color: Colors.grey, // Grey border
                                  thickness: 1, // Thickness of the line
                                  height: 20, // Space between elements
                                ),
                                const SizedBox(height: 10),
                                Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 20,
                                        horizontal: 10), // Adds spacing
                                    child: Text(links[index]['shorted_link']!,
                                        style: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 3, 145, 126)))),
                                const SizedBox(height: 10),
                                Container(
                                    padding: EdgeInsets.all(20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Expanded(
                                            child: ElevatedButton(
                                          onPressed: () {
                                            copyToClipboard(
                                                links[index]['shorted_link']!);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color.fromARGB(
                                                    255, 64, 255, 230),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  4), // Small rounded corners
                                            ),
                                          ),
                                          child: const Text('Copy'),
                                        )),
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: ElevatedButton(
                                          onPressed: () {
                                            viewUrl(
                                                links[index]['shorted_link']!);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.deepPurpleAccent,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(
                                                  4), // Small rounded corners
                                            ),
                                          ),
                                          child: const Text('View'),
                                        )),
                                      ],
                                    )),
                                const SizedBox(height: 30),
                              ],
                            ),
                          ));
                    })),
          ],
        ))));
  }
}

class WebViewScreen extends StatefulWidget {
  final String url;
  const WebViewScreen({super.key, required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  // late WebViewController _controller;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..loadRequest(
        Uri.parse(widget.url),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("View URL")),
      body: WebViewWidget(
        controller: controller, // Use WebViewWidget with controller
      ),
    );
  }
}
