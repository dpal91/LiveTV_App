import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testlive/HomePage/home_view_controller.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatelessWidget {
  final HomeController controller = Get.find();

  VideoPlayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        await controller.stopVideo();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Obx(() {
          final videoController = controller.currentVideoController;

          if (videoController == null) {
            return const Center(
              child: Text(
                'No video selected',
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          if (!videoController.value.isInitialized) {
            return const Center(child: CircularProgressIndicator());
          }

          return Stack(
            children: [
              // ================= VIDEO =================
              Center(
                child: GestureDetector(
                  onTap: () {
                    controller.showPlayController.value =
                        !controller.showPlayController.value;
                  },
                  child: AspectRatio(
                    aspectRatio: controller.aspectRation.value,
                    child: VideoPlayer(videoController),
                  ),
                ),
              ),

              // ================= LEFT SIDE (BRIGHTNESS) =================
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width / 6,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onVerticalDragUpdate: (details) {
                    controller.changeBrightness(details.delta.dy);
                  },
                  child: Obx(() {
                    if (!controller.showBrightnessUI.value) {
                      return const SizedBox();
                    }

                    return Center(
                      child: _brightnessWidget(controller),
                    );
                  }),
                ),
              ),

              // ================= RIGHT SIDE (PLACEHOLDER / FUTURE VOLUME) =================
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                width: MediaQuery.of(context).size.width / 6,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onVerticalDragUpdate: (details) {
                    controller.changeVolume(details.delta.dy);
                  },
                  child: Obx(() {
                    if (!controller.showVolumeUI.value) {
                      return const SizedBox();
                    }

                    return Center(
                      child: _volumeWidget(
                          controller), // create this similar to brightness widget
                    );
                  }),
                ),
              ),

              // ================= PLAY CONTROLS =================
              Obx(() {
                if (!controller.showPlayController.value) {
                  return const SizedBox();
                }

                return Positioned(
                  bottom: 50,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          videoController.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 50,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          videoController.value.isPlaying
                              ? videoController.pause()
                              : videoController.play();
                        },
                      ),
                      IconButton(
                        onPressed: controller.nextAspectRation,
                        icon: const Icon(
                          Icons.fullscreen,
                          size: 50,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }
}

Widget _brightnessWidget(HomeController controller) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.7),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.brightness_6, color: Colors.white),

        const SizedBox(height: 10),

        // 🔥 Vertical progress bar
        SizedBox(
          height: 120,
          child: RotatedBox(
            quarterTurns: -1, // makes LinearProgressIndicator vertical
            child: LinearProgressIndicator(
              value: controller.currentBrightness,
              backgroundColor: Colors.white24,
              color: Colors.white,
              minHeight: 6,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "${(controller.currentBrightness * 100).toInt()}%",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    ),
  );
}

Widget _volumeWidget(HomeController controller) {
  return Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.black.withOpacity(0.7),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.volume_up, color: Colors.white),

        const SizedBox(height: 10),

        // 🔥 Vertical progress bar
        SizedBox(
          height: 120,
          child: RotatedBox(
            quarterTurns: -1, // makes LinearProgressIndicator vertical
            child: LinearProgressIndicator(
              value: controller.currentVolume,
              backgroundColor: Colors.white24,
              color: Colors.white,
              minHeight: 6,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Text(
          "${(controller.currentVolume * 100).toInt()}%",
          style: const TextStyle(color: Colors.white, fontSize: 12),
        ),
      ],
    ),
  );
}
