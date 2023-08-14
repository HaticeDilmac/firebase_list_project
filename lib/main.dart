import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyHomePage());
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var collection = FirebaseFirestore.instance
      .collection("books"); //Firebasedeki collectionumuza erişim.
  List<Map<String, dynamic>> items = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _incrementCounter();
  }

  void _incrementCounter() async {
    List<Map<String, dynamic>> templist = [];
    var data = await collection.get(); //koleksiyondan get işlemi yaparız.

    for (var element in data.docs) {
      templist.add(element.data());
    }

    setState(() {
      items = templist;
      isLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 175, 91, 76),
          title: const Text("Firebase List Example"),
          centerTitle: true,
        ),
        body: Center(
          child: isLoaded
              ? ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    var list = items[index];
                    // items.sort((a, b) => a['name'].compareTo(
                    //     b['name'])); //isme göre sıralama işlemi yapar.
                    return Container(
                      padding: EdgeInsets.all(Dimens.paddingSmallX),
                      margin: EdgeInsets.all(Dimens.paddingSmall),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 202, 177, 173),
                        border: Border.all(
                          color: const Color.fromARGB(255, 175, 91, 76),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(Dimens.paddingSmall),
                        child: ListTile(
                          trailing: Text(list["id"].toString()),
                          leading: Image.network(list["image"]),
                          title: Text(list["name"]),
                          subtitle: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(list["writer"]),
                              list["pages"] == null
                                  ? const Text("")
                                  : Text(
                                      " - ${list["pages"]} sayfa",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ),
      ),
    );
  }
}

class Dimens {
  static double paddingSmallX = 2;
  static double paddingSmall = 5;
  static double padding = 10;
  static double paddingMedium = 15;
  static double paddingLarge = 20;
}
