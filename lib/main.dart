import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'components/home.dart';
import 'components/shortner/shortner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/shortner/shortener_bloc.dart';


void main() {
  // runApp(const MyApp());
   runApp(
    BlocProvider(
      create: (context) => ShortenerBloc(),
      child: const MaterialApp(
        home: MyApp(),
      ),
    ),
  );
}

final GoRouter _router = GoRouter(
  initialLocation: '/home', // Default page
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return Layout(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const Home(),
        ),
        GoRoute(
          path: '/shortner',
          builder: (context, state) => const Shortner(),
        ),
      ],
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Url Shortner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class Layout extends StatelessWidget {
  final Widget child;
  const Layout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("URL Shortner"),
        centerTitle: true,
        elevation: 5,
        toolbarOpacity: 0.8,
        backgroundColor: const Color.fromARGB(255, 64, 255, 230),
      ),
      body: child,
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: const Color.fromARGB(169, 1, 121, 105),
          unselectedItemColor: Colors.grey,
          currentIndex: _getCurrentIndex(context),
          onTap: (index) {
            if (index == 0) context.go('/home');
            if (index == 1) context.go('/shortner');
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.create), label: 'create')
          ]),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    if (location == '/home') return 0;
    if (location == '/shortner') return 1;
    return 0;
  }
}
