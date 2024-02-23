import 'package:deaf_connect/utils/colors.dart';
import 'package:deaf_connect/utils/translator.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TextToSignScreen extends StatefulWidget {
  const TextToSignScreen({Key? key}) : super(key: key);

  @override
  State<TextToSignScreen> createState() => _TextToSignScreenState();
}

class _TextToSignScreenState extends State<TextToSignScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _textfieldFocusNode = FocusNode();
  late VideoPlayerController _videoController;
  String translatedText = "";
  List<String> seperatedIndexed = [];
  int vidIndex = 0;

  @override
  void initState() {
    super.initState();
    _videoController = VideoPlayerController.asset(
      'assets/videos/Words/Idle.mp4',
    )..initialize().then((_) {
        _videoController.setLooping(false);
        _videoController.addListener(() {
          if (!_videoController.value.isPlaying &&
              _videoController.value.position ==
                  _videoController.value.duration) {
            playNextVideo();
          }
        });
        translateText("");
      });
  }

  List<String> videoUrls = [];
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: avatarBg,
        appBar: AppBar(
          title: const Text(
            'Text to Sign Language',
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // SingleChildScrollView(
            //   scrollDirection: Axis.horizontal,
            //   child: Row(
            //     children: buildWordWidgets(translatedText),
            //   ),
            // ),
            Expanded(
              child: Stack(
                children: buildVideoWidgets(),
              ),
            ),
            Container(
              color: secondaryColor,
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Translate',
                          style: TextStyle(
                            color: mainColor,
                            fontSize: 16,
                          ),
                        ),
                        TextField(
                          controller: _textEditingController,
                          focusNode: _textfieldFocusNode,
                          decoration: const InputDecoration(
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: 'Type to translate...',
                            hintStyle: TextStyle(
                              color: lightGray,
                              fontWeight: FontWeight.w400,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      translateText(_textEditingController.text);
                      _textfieldFocusNode.unfocus();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: mainColor,
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ), // Send icon
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildVideoWidgets() {
    return [
      for (int i = 0; i < videoUrls.length; i++)
        Positioned.fill(
          child: Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints.expand(
                      width: MediaQuery.of(context).size.width,
                    ),
                    child: VideoPlayer(_videoController),
                  ),
                ),
              ],
            ),
          ),
        ),
    ];
  }

  List<Widget> buildWordWidgets(String text) {
    List<Widget> wordWidgets = [];

    // Iterate through each word
    for (String word in seperatedIndexed) {
      Widget wordWidget = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Text(
          "$word ",
          style: TextStyle(
            color: vidIndex < seperatedIndexed.length &&
                    word == seperatedIndexed[vidIndex]
                ? Colors.blue
                : Colors.black,
            fontSize: 30, // Adjust the font size as desired
          ),
        ),
      );
      wordWidgets.add(wordWidget);
    }

    return wordWidgets;
  }

  void translateText(String text) async {
    index = 0;
    videoUrls.clear();
    translatedText = text;
    Translator translator = Translator(text);
    seperatedIndexed = translator.seperatedIndexd;
    videoUrls = translator.translatePhrase();
    await playNextVideo();
  }

  Future<void> playNextVideo() async {
    double playbackSpeed = 1.5;
    print("seperated${seperatedIndexed}");

    if (index < videoUrls.length) {
      vidIndex = index;
      _videoController = VideoPlayerController.asset(
        videoUrls[index],
      )..initialize().then((_) async {
          setState(() {
            _videoController.play();
          });
          _videoController.setPlaybackSpeed(playbackSpeed);
          await Future.delayed(_videoController.value.duration);
          await playNextVideo();
        });
      index++;
    } else {
      _videoController = VideoPlayerController.asset(
        'assets/videos/Words/Idle.mp4',
      )..initialize().then((_) {
          _videoController.setLooping(true);
          _videoController.play();
          setState(() {
            _videoController.seekTo(const Duration(seconds: 0));
          });
        });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _videoController.dispose();
    super.dispose();
  }
}
