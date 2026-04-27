import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:testlive/APIService/APIService.dart';
import 'package:testlive/HomePage/HomeViewController.dart';
import 'package:testlive/HomePage/models.dart';
import 'package:get/get.dart';
import 'package:testlive/VideoPlayerScreen.dart/VideoPlayer.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class ChannelGrid extends StatelessWidget {
  final List<Channel> channels;
  final FocusNode focusNode;

  HomeController controller = Get.find();

  ChannelGrid({
    super.key,
    required this.channels,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return FocusableActionDetector(
        autofocus: false,
        onShowFocusHighlight: (focused) {
          // rebuild to show border/glow
        },
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (intent) {
              // This is OK button press
              return null;
            },
          ),
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 1,
          ),
          itemCount: channels.length,
          itemBuilder: (context, index) {
            return GestureDetector(
                onTap: () {
                  // Select the channel and open the video player screen
                  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
                  WakelockPlus.enable();
                  controller.selectChannel(index);
                  controller.initAspectList(context);
                  Get.to(() => VideoPlayerScreen());
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blueAccent, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Expanded(
                          child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(
                                  channels[index].backgroundImageUrl == ""
                                      ? APIService.noImage
                                      : channels[index].backgroundImageUrl),
                              fit: BoxFit.cover),
                        ),
                      )),
                      Text(
                        channels[index].title,
                        textAlign: TextAlign.center,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 14),
                      )
                    ],
                  ),
                ));
          },
        ));
  }
}

// onTap: () {
//                   // Select the channel and open the video player screen
//                   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
//                   WakelockPlus.enable();
//                   controller.selectChannel(index);

//                   Get.to(() => VideoPlayerScreen());
//                 },