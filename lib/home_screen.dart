import 'package:allen_ai/colors.dart';
import 'package:allen_ai/services/gemini_ai_service.dart';
import 'package:allen_ai/services/open_ai_service.dart';
import 'package:allen_ai/widgets/feature_box.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final speechToText = SpeechToText();
  String lastWords = "Good Morning, what task can i do for you";
  final OpenAIService openAIService = OpenAIService();
  final GeminiAIService geminiAIService = GeminiAIService();
  final FlutterTts flutterTts = FlutterTts();
  String generateContent = "";
  String generateImageUrl = "";
  bool isTalking = false;
  int start = 200;
  int delay = 200;

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async {
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
    debugPrint("Words: ${result.recognizedWords}");
  }

  Future<void> systemSpeak(String content) async {
    await flutterTts.speak(content);
  }

  Future<void> stopSpeech() async {
    await flutterTts.stop();
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
          ),
        ),
        title: BounceInDown(
          child: const Text("Allen"),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Virtual Assistaance Picture
            ZoomIn(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      width: size.width * 0.45,
                      height: 200,
                      margin: const EdgeInsets.only(
                        top: 4,
                      ),
                      decoration: const BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Center(
                    child: Container(
                      width: size.width * 0.46,
                      height: 210,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/images/virtualAssistant.png",
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            // Chat buble
            FadeInRight(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 40,
                ).copyWith(
                  top: 30,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Pallete.borderColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20).copyWith(
                    topLeft: Radius.zero,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    lastWords,
                    style: TextStyle(
                      color: Pallete.mainFontColor,
                      fontSize: generateContent.isEmpty ? 24 : 18,
                      fontFamily: "Cera Pro",
                    ),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: generateContent.isNotEmpty,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                margin: const EdgeInsets.symmetric(
                  horizontal: 40,
                ).copyWith(
                  top: 30,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Pallete.borderColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20).copyWith(
                    topRight: Radius.zero,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Text(
                    generateContent,
                    style: const TextStyle(
                      color: Pallete.mainFontColor,
                      fontSize: 24,
                      fontFamily: "Cera Pro",
                    ),
                  ),
                ),
              ),
            ),
            if (generateImageUrl.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    generateImageUrl,
                  ),
                ),
              ),
            SlideInLeft(
              child: Visibility(
                visible: generateContent.isEmpty && generateImageUrl.isEmpty,
                child: Container(
                  padding: const EdgeInsets.all(
                    10,
                  ),
                  margin: const EdgeInsets.only(
                    top: 10,
                    left: 22,
                  ),
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "Here are few features",
                    style: TextStyle(
                      fontFamily: "Cera Pro",
                      fontSize: 20,
                      color: Pallete.mainFontColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            // Features List
            Visibility(
              visible: generateContent.isEmpty && generateImageUrl.isEmpty,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(
                      milliseconds: start,
                    ),
                    child: const FeatureBox(
                      color: Pallete.firstSuggestionBoxColor,
                      headerText: "Chat GPT",
                      descText:
                          "A smarter way to stay organised and informed with ChatGPT",
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: const FeatureBox(
                      color: Pallete.secondSuggestionBoxColor,
                      headerText: "Dall-E",
                      descText:
                          "Get inspired and stay creative with your personal assistant powered by Dall-E",
                    ),
                  ),
                  SlideInLeft(
                    delay: Duration(milliseconds: start + 2*delay),
                    child: const FeatureBox(
                      color: Pallete.secondSuggestionBoxColor,
                      headerText: "Smart Voice Assistant",
                      descText:
                          "Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT",
                    ),
                  ),
                  // GeminiResponseTypeView(builder: builder)
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: isTalking
          ? FloatingActionButton.small(
              backgroundColor: Pallete.firstSuggestionBoxColor,
              onPressed: () async {
                stopSpeech();
                isTalking = false;
                setState(() {});
              },
              child: const Icon(
                Icons.stop,
              ),
            )
          : ZoomIn(
            delay: Duration(milliseconds: start + delay*3),
            child: FloatingActionButton(
                backgroundColor: Pallete.firstSuggestionBoxColor,
                onPressed: () async {
                  if (await speechToText.hasPermission &&
                      speechToText.isNotListening) {
                    startListening();
                  } else if (speechToText.isListening) {
                    // Work with OPEN AI API
                    // final openAISpeech =
                    //     await openAIService.isArtPromptAPI(lastWords);
                    // debugPrint("Open AI: $openAISpeech");
            
                    // if (openAISpeech.contains("https")) {
                    //   generateImageUrl = openAISpeech;
                    //   generateContent = "";
                    //   setState(() {});
                    // } else {
                    //   generateContent = openAISpeech;
                    //   generateImageUrl = "";
                    //   setState(() {});
                    // }
            
                    // Work with Bard API
                    final bardSpeech =
                        await geminiAIService.generateText(lastWords);
                    generateContent = bardSpeech;
                    debugPrint("Bard: $bardSpeech");
            
                    // speech system
                    await systemSpeak(bardSpeech);
            
                    isTalking = true;
            
                    setState(() {});
                    await stopListening();
                    // debugPrint("Listening stoped Finished");
                  } else {
                    initTextToSpeech();
                  }
                },
                child: Icon(
                  speechToText.isListening ? Icons.stop : Icons.mic,
                ),
              ),
          ),
    );
  }
}
