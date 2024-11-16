import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() {
  runApp(VRDApp());
}

class VRDApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VRD Timer App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Roboto',
      ),
      home: VRDHomePage(),
    );
  }
}

class VRDHomePage extends StatefulWidget {
  @override
  _VRDHomePageState createState() => _VRDHomePageState();
}

class _VRDHomePageState extends State<VRDHomePage> {
  int seconds = 60;
  Timer? _timer;
  bool isMaterial = true; // To toggle styles between Material and Cupertino
  bool switchValue = false;

  int _currentIndex = 0;

  void startTimer() {
    _timer?.cancel();
    setState(() {
      seconds = 60;
    });
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
        _showSnackBar(context, 'Timer Finished!');
      }
    });
  }

  void resetTimer() {
    _timer?.cancel();
    setState(() {
      seconds = 60;
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('VRD Timer App'),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Welcome!',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'user@example.com',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.support),
              title: Text('Support'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          buildHomeContent(),
          buildTimerContent(),
          buildPickerContent(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Temporizador',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'Más',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 1
          ? FloatingActionButton(
              onPressed: startTimer,
              backgroundColor: Colors.indigo,
              child: Icon(Icons.play_arrow),
            )
          : null,
    );
  }

  Widget buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome to VRD Timer!',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Toggle Styles:',
                style: TextStyle(fontSize: 18),
              ),
              CupertinoSwitch(
                value: switchValue,
                onChanged: (value) {
                  setState(() {
                    switchValue = value;
                    isMaterial = !value;
                  });
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Use the switch above to toggle between Material and Cupertino styles.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTimerContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(15),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Remaining Time',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '$seconds s',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo.shade900,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: startTimer,
                child: Text('Start Timer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
              ElevatedButton(
                onPressed: resetTimer,
                child: Text('Reset Timer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPickerContent() {
    return Center(
      child: isMaterial
          ? DropdownButton<String>(
              value: 'Option 1',
              items: [
                DropdownMenuItem(
                  child: Text('Option 1'),
                  value: 'Option 1',
                ),
                DropdownMenuItem(
                  child: Text('Option 2'),
                  value: 'Option 2',
                ),
                DropdownMenuItem(
                  child: Text('Option 3'),
                  value: 'Option 3',
                ),
              ],
              onChanged: (value) {},
            )
          : CupertinoPicker(
              itemExtent: 40,
              onSelectedItemChanged: (index) {},
              children: [
                Text('Option 1'),
                Text('Option 2'),
                Text('Option 3'),
              ],
            ),
    );
  }
}
