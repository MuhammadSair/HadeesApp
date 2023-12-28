import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mad_project/assistant.dart';
import 'package:mad_project/languageScreen.dart';
import 'package:mad_project/pallets.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HadithName {
  final Map<String, dynamic> name;

  HadithName({required this.name});
}

Future<List<HadithName>> fetchNamesList() async {
  final response = await http.get(Uri.parse(
      "https://cdn.jsdelivr.net/gh/fawazahmed0/hadith-api@1/editions.json"));

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    List<HadithName> namesList = [];

    data.forEach((edition, nameData) {
      namesList.add(HadithName(name: nameData));
    });

    return namesList;
  } else {
    throw Exception("Failed to Load Data");
  }
}

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  late Future<List<HadithName>> futureName;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureName = fetchNamesList();
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Hadith'),
              onTap: () {
                _onNavItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Assistant'),
              onTap: () {
                 Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const ChatAssistant()));
                // _onNavItemTapped(1);
                // Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Quran'),
              onTap: () {
                _onNavItemTapped(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      backgroundColor: Pallete.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: const DecorationImage(
                      image: AssetImage('assets/books.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  height: 200,
                  width: double.infinity,
                ),
                const SizedBox(height: 15),
                const Text(
                  "Select a Book for Hadiths",
                  style: TextStyle(fontSize: 19),
                ),
                const SizedBox(height: 15),
                if (_selectedIndex == 0) ...[
                  FutureBuilder<List<HadithName>>(
                    future: futureName,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return CarouselSlider.builder(
                          itemCount: snapshot.data!.length,
                          options: CarouselOptions(
                            height: 200,
                            enableInfiniteScroll: true,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            pauseAutoPlayOnTouch: true,
                            enlargeCenterPage: true,
                          ),
                          itemBuilder: (context, index, realIndex) {
                            final name = snapshot.data![index];
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  // print(name.name['collection']);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => LanguageScreen(
                                              hadithData: name.name['collection'])));
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  padding: const EdgeInsets.all(16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 70,
                                        ),
                                        const Icon(
                                          Icons.book,
                                          color: Colors.black,
                                        ),
                                        const SizedBox(
                                          width: 7,
                                        ),
                                        Text(
                                          name.name['name'] as String,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Text(
                            "No data in Snapshot because ${snapshot.error}");
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ] else if (_selectedIndex == 1) ...[
                  // Assistant content
                  const Text('Assistant Content'),
              //     OnTap:(){
              // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> const ChatAssistant()));
              //     }
                 
                ] else if (_selectedIndex == 2) ...[
                  // Quran content
                  const Text('Quran Content'),
                ],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        backgroundColor: Colors.transparent,
        color: Colors.blue,
        buttonBackgroundColor: Colors.blue,
        height: 50,
        items: const <Widget>[
          Icon(Icons.book, size: 30),
          Icon(Icons.person, size: 30),
          Icon(Icons.menu_book, size: 30),
        ],
        onTap: _onNavItemTapped,
      ),
    );
  }
}
