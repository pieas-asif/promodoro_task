import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: const Color(0xFF264444),
              ),
            ),
            Expanded(
              flex: 3,
              child: Container(
                child: Column(
                  children: [
                    
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
