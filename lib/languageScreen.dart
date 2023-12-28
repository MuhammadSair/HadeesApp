import 'package:flutter/material.dart';
import 'package:mad_project/landing_page.dart';
import 'package:mad_project/pallets.dart';

class LanguageScreen extends StatelessWidget {
  final List<dynamic> hadithData;

  const LanguageScreen({super.key, required this.hadithData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        leading: BackButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LandingPage()));
          },
        ),
        title: const Text("Select a Language"),
      ),
      body: ListView.builder(
                itemCount: hadithData.length,
                itemBuilder: (context, index) {
                  final hadith = hadithData[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    elevation: 4,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        hadith['language'] ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text('Name: ${hadith['name'] ?? ''}'),
                          Text('Book: ${hadith['book'] ?? ''}'),
                        ],
                      ),
                      onTap: () {
                      },
                    ),
                  );
                },
              )

    );
  }
}
