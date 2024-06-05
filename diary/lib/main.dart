
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:intl/intl.dart';

const List<String> emojis = ["😊", "😔", "😡", "😮", "😐"];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LandingScreen(),
    );
  }
}

class LandingScreen extends StatefulWidget {
  const LandingScreen({Key? key}) : super(key: key);

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  String selectedEmoji = '';
  List<String> extra = [];
  static const String apiKey = "KEY";
  static const String url = "https://api.openai.com/v1/images/generations";
  String? image;  
  final myController = TextEditingController();

  void updateEmoji(String emoji) {
    setState(() {
      selectedEmoji = emoji;
    });
  }

  void _toggleItem(String item) {
    setState(() {
      if (extra.contains(item)) {
        extra.remove(item);
      } else {
        extra.add(item);
      }
      debugPrint('extra: $extra');
    });
  }

  void getImage() async{
    if (selectedEmoji.isNotEmpty && extra.isNotEmpty && myController.text.isNotEmpty) {
      var data = {
        "prompt": "Create therapy art about how i feel. this si the prompt: ${myController.text}",
        "n": 1,
        "size": "256x256"
      };

      var res = await http.post(Uri.parse(url), 
          headers: {"Authorization": "Bearer ${apiKey}", "Content-Type": "application/json"},
          body: jsonEncode(data));
        
      var jsonResponse = jsonDecode(res.body);

      image =jsonResponse['data'][0]['url'];
      setState(() {
      });
    } else {
      print("enter");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 243, 0.984),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
          children: [
            const SizedBox(height: 70),
            date(),
            const SizedBox(height: 20),
            emotion(),
            const SizedBox(height: 20),
            explanation(),
            const SizedBox(height: 20),
            generateContent(),
            if (image != null)
              art(apiKey)
          ],
        ),
        ),
        
      ),
    );
  }

  Widget generateContent() {
    return GestureDetector(
                      onTap: () => getImage(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            "Generate Image",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    );
  }

  Widget date() {
  return Container(
    child: ListTile(
      title: Text(
        "June 5, 2024",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        "How do you feel today?",
        style: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    ),
  );
}

Widget emotion() {
  return Container(
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      children: [
        Row(
          children: [
            Text(
              "Today I'm feeling  ",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            if (selectedEmoji.isEmpty)
              DashedCircleIcon()
            else
              Text("$selectedEmoji", style: TextStyle(fontSize: 35))
          ],
        ),
        SizedBox(height: 10), // Add some spacing between the rows
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: emojis
              .map((emoji) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        updateEmoji(emoji);
                        extra.clear();
                        
                      },
                      child: Text(
                        emoji,
                        style: TextStyle(fontSize: 45),
                      ),
                    ),
                  ))
              .toList(),
        ),
        Visibility(
          visible: selectedEmoji.isNotEmpty,
         child: SizedBox(
          height: 170,
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 3,
            children: selectedEmoji == '😊'
                ? ["Hopeful", "Free", "Confident", "Excited"].map((text) {
                    return GestureDetector(
                      onTap: () => _toggleItem(text),
                      child: Container(
                        decoration: BoxDecoration(
                          color: extra.contains(text) ? Colors.black : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            text,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: extra.contains(text) ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList()
                : selectedEmoji == '😔'
                    ? ["Disappointed", "Hurt", "Distress", "Grief"].map((text) {
                        return GestureDetector(
                          onTap: () => _toggleItem(text),
                          child: Container(
                            decoration: BoxDecoration(
                              color: extra.contains(text) ? Colors.black : Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                text,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: extra.contains(text) ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList()
                    : selectedEmoji == '😡'
                        ? ["Hate", "Rage", "Disgust", "Jealousy"].map((text) {
                            return GestureDetector(
                              onTap: () => _toggleItem(text),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: extra.contains(text) ? Colors.black : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    text,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: extra.contains(text) ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList()
                        : selectedEmoji == '😮'
                            ? ["Anxious", "Fear", "Frustrated", "Doubtful"].map((text) {
                                return GestureDetector(
                                  onTap: () => _toggleItem(text),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: extra.contains(text) ? Colors.black : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.black,
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        text,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: extra.contains(text) ? Colors.white : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }).toList()
                            : selectedEmoji == '😐'
                                ? ["Indifferent", "Bored", "Agitated", "Ambivalent"].map((text) {
                                    return GestureDetector(
                                      onTap: () => _toggleItem(text),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: extra.contains(text) ? Colors.black : Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            text,
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: extra.contains(text) ? Colors.white : Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList()
                                : [], // Add default children or an empty list
          ),
        ),
        ),
      ],
    ),
  );
}


Widget explanation() {
  //final myController = TextEditingController();
  
  return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            "What made you feel this way?",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          TextField(
         
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Ex: Today the weather was so sunny! ',
            ),
            controller: myController, 
          )
        ],  
      )
      );
}

Widget art(String key) {
  return Container(
    child: Image.network(image!, width: 256, height:256),
    padding: const EdgeInsets.all(20),
  );
}
}



class DashedCircleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(40, 40), // Size of the icon
      painter: DashedCirclePainter(),
    );
  }
}

class DashedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    Paint paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double dashWidth = 5, dashSpace = 5;
    double startAngle = 0;

    final Rect rect =
        Rect.fromCircle(center: Offset(radius, radius), radius: radius);

    while (startAngle < 2 * 3.141592653589793) {
      canvas.drawArc(rect, startAngle, dashWidth / radius, false, paint);
      startAngle += (dashWidth + dashSpace) / radius;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
