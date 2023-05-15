import 'package:flutter/material.dart';
import 'package:ymcc_presence/api.dart';
import 'package:ymcc_presence/globals.dart' as globals;
import 'package:ymcc_presence/qrcode_scanner.dart';
// import 'package:ymcc_presence/side_menu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'YMCC 2023 Presence',
      debugShowCheckedModeBanner: false,
      home: MainScreen(),
    );
  }
}

List _snapshotToList(snapshot) {
  return snapshot.data;
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const SideMenu(),
      appBar: AppBar(
        title: const Text("YMCC 2023 Events"),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: API.getEvent(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: _snapshotToList(snapshot).map(((data) {
                  return Container(
                      decoration: const BoxDecoration(
                          // color: Colors.black54,
                          border: Border(
                              top: BorderSide(
                                  width: 5, color: Colors.transparent),
                              bottom: BorderSide(
                                  width: 3, color: Colors.transparent)),
                          color: Color.fromARGB(35, 35, 35, 35)),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            globals.selectedEventId = data["id"].toString();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const QRCodeScanner(),
                              ),
                            );
                          });
                        },
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(data['name'])))
                          ],
                        ),
                      ));
                })).toList(),
              );
            } else {
              return const Text('Loading...');
            }
          },
        ),
      ),
    );
  }
}
