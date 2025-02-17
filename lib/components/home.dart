import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        SvgPicture.asset(
          "assets/images/illustration_working.svg",
          fit: BoxFit.cover,
        ),
        Container(
          color: Colors.black.withOpacity(0.6),
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "More than just shorter links",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28, // Increases font size
                    fontWeight: FontWeight.bold, // Makes it bold
                    color: Colors.grey[200], // Optional: Ensures visibility
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Build your brand recognitions and get detailed insights on how your links are performing",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16, // Adjusts font size
                    color: Colors
                        .white, // Slightly darker grey for better readability
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                    onPressed: () {
                      context.go('/shortner');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 64, 255, 230),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                    ),
                    child: Text("Get Started",
                        style: TextStyle(color: Colors.black))),
              ],
            ),
          ),
        )
      ],
    ));
  }
}
