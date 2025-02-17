import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'shortener_bloc.dart';
import 'shortener_event.dart';
import 'shortener_state.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Shortner extends StatefulWidget {
  const Shortner({super.key});

  @override
  State<Shortner> createState() => _ShortnerState();
}

class _ShortnerState extends State<Shortner> {
  final TextEditingController _urlController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFE5E7EB),
        body: (SafeArea(
            child: ListView(padding: EdgeInsets.all(20), children: [
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
                        // labelText: "Long Url",
                        labelStyle:
                            TextStyle(color: Color.fromARGB(169, 1, 121, 105)),
                        border: OutlineInputBorder(),
                        hintText: 'Enter your url',
                        hintStyle:
                            TextStyle(color: Color.fromARGB(169, 1, 121, 105)),
                        filled: true, // Enable filling
                        fillColor:
                            Colors.white, // Set background color to white
                      ),
                      autofocus: true,
                      onSubmitted: (_) {
                        context
                            .read<ShortenerBloc>()
                            .add(ShortenUrl(_urlController.text.trim()));
                      },
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<ShortenerBloc, ShortenerState>(
                        builder: (context, state) {
                      return ElevatedButton(
                        onPressed: () {
                          context
                              .read<ShortenerBloc>()
                              .add(ShortenUrl(_urlController.text.trim()));
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(1000, 50), // Width and height
                          backgroundColor: Color.fromARGB(255, 64, 255, 230),
                          shape: RoundedRectangleBorder(
                            // Remove default border radius
                            borderRadius: BorderRadius.zero, // No rounding
                          ),
                        ),
                        child: state is ShortenerLoading
                            ? Padding(padding: EdgeInsets.all(5), child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white)))
                            : const Text(
                                'Shorten It!',
                                style: TextStyle(color: Colors.white),
                              ),
                      );
                    }),
                    const SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 50),
          BlocBuilder<ShortenerBloc, ShortenerState>(
            builder: (context, state) {
              if (state is ShortenerLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ShortenerFailure) {
                return Center(
                    child: Text(state.error,
                        style: const TextStyle(color: Colors.red)));
              } else if (state is ShortenerSuccess) {
                return ListView.builder(
                    shrinkWrap: true, // Ensures it only takes necessary space
                    physics:
                        NeverScrollableScrollPhysics(), // Disables scrolling inside ListView
                    itemCount: state.links.length,
                    itemBuilder: (context, index) {
                      final link = state.links[index];

                      return Padding(
                          // Add padding around each item for spacing
                          padding: const EdgeInsets.only(
                              bottom: 5), // Space between each item
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
                                  child: Text(link['link']!,
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
                                    child: Text(link['shorted_link']!,
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
                                                link['shorted_link']!);
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
                                            viewUrl(link['shorted_link']!);
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
                    });
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ]))));
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
