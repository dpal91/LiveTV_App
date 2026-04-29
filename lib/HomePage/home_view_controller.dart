import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:testlive/APIService/api_service.dart';
import 'package:testlive/HomePage/models.dart';
import 'package:video_player/video_player.dart';
import 'package:volume_controller/volume_controller.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class HomeController extends GetxController {
  var playlist = "".obs;
  RxList<Categories> categories = <Categories>[].obs;
  RxList<Categories> filteredCategories = <Categories>[].obs;
  var showCategories = true.obs;
  var selectedCategoryIndex = 0.obs;
  var selectedChannelIndex = (-1).obs;
  var showPlayController = true.obs;
  Rx<VideoPlayerController?> videoController = Rx<VideoPlayerController?>(null);
  RxString searchText = ''.obs;
  List<double> aspectList = [];
  double currentBrightness = 0.0;
  double currentVolume = 0.0;
  var showBrightnessUI = false.obs;
  var showVolumeUI = false.obs;

  var aspectIndex = 0;
  var aspectRation = 0.0.obs;

  HomeController() {
    getText();
  }

  getText() async {
    playlist.value = await APIService.fetchPlaylist(
        "https://raw.githubusercontent.com/bugsfreeweb/LiveTVCollector/main/LiveTV/India/LiveTV.m3u");
    playlist.value += "\n";
    playlist.value += await APIService.fetchPlaylist(
        "https://raw.githubusercontent.com/iptv-org/iptv/master/streams/in.m3u");
    categories.value = setupChannelsByCategory(playlist.value);
    filteredCategories.value = categories;
    if (kDebugMode) {
      print(categories.length.toString());
    }
  }

  List<Categories> setupChannelsByCategory(String playlist) {
    final Map<String, List<Channel>> categoryMap = {};

    String? title;
    String? imageUrl;
    String? groupTitle;

    final logoRegex = RegExp(r'tvg-logo="(.*?)"');
    final groupRegex = RegExp(r'group-title="(.*?)"');

    for (final rawLine in playlist.split('\n')) {
      final line = rawLine.trim();

      if (line.startsWith('#EXTINF')) {
        title = line.split(',').last.trim();

        imageUrl = logoRegex.firstMatch(line)?.group(1);
        groupTitle = groupRegex.firstMatch(line)?.group(1) ?? 'Other';
      } else if (line.startsWith('http') && title != null) {
        final channel = buildChannel(
          title: title,
          description: title,
          studio: groupTitle ?? 'Other',
          videoUrl: line,
          cardImageUrl: imageUrl ?? '',
          backgroundImageUrl: imageUrl ?? '',
        );

        final category = groupTitle ?? 'Other';
        categoryMap.putIfAbsent(category, () => []).add(channel);

        // reset for next entry
        title = null;
        imageUrl = null;
        groupTitle = null;
      }
    }

    final blockedKeywords = [
      'adult',
      'relag',
      'reli',
      'legis',
      'promo',
      'jago',
      'isla',
      'cultu',
      'cook',
      'busin',
      'kid',
      'news',
      'bangla',
      'anima',
      'comedy',
      'docu',
      'edu',
      'fami',
      'weat',
    ];

    return categoryMap.entries.where((e) {
      final name = e.key.toLowerCase();
      return !blockedKeywords.any(name.contains);
    }).map((entry) {
      final name = entry.key;

      return Categories(
        name: name.isEmpty
            ? 'AA'
            : name.replaceAll(';', ' ').toLowerCase().replaceFirst(
                  name[0],
                  name[0].toUpperCase(),
                ),
        channels: entry.value
          ..sort(
              (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase())),
      );
    }).toList()
      ..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
  }

  void openGrid(int index) {
    selectedCategoryIndex.value = index;
    showCategories.value = true;
  }

  void showCategoryPanel() {
    showCategories.value = true;
  }

  Categories get selectedCategory => filteredCategories.isEmpty
      ? Categories(name: 'Empty', channels: [])
      : filteredCategories[selectedCategoryIndex.value];

  VideoPlayerController? get currentVideoController => videoController.value;

  void selectChannel(int channelIndex) {
    selectedChannelIndex.value = channelIndex;
    final channel = selectedCategory.channels[channelIndex];

    // Initialize video player controller with the stream URL
    videoController.value =
        VideoPlayerController.networkUrl(Uri.parse(channel.videoUrl))
          ..initialize().then((_) {
            // Start playing as soon as the video is initialized
            videoController.value!.play();
            videoController.refresh();
          });
    enablePlayController();
  }

  void updateSearchText(String text) {
    if (kDebugMode) {
      print(text);
    }
    searchText.value = text;
    filterCategories();
  }

  void filterCategories() {
    if (searchText.value.isEmpty) {
      filteredCategories.value =
          categories; // Show all categories if no search text
    } else {
      filteredCategories.value = categories.map((category) {
        // Filter the channels within each category by the channel name
        List<Channel> filteredChannels = category.channels.where((channel) {
          // Ensure the channel.name is a String, and check if it contains the searchText
          return channel.title
              .toLowerCase()
              .contains(searchText.value.toLowerCase());
        }).toList();

        if (kDebugMode) {
          print(filteredChannels.length);
        }
        // Return a new category with filtered channels
        return Categories(
          name: category.name, // Keep the original category name
          channels: filteredChannels,
        );
      }).where((category) {
        // Only include categories that have at least one matching channel
        return category.channels.isNotEmpty;
      }).toList();
    }
    if (kDebugMode) {
      print(filteredCategories.length);
    }

    if (selectedCategoryIndex.value > filteredCategories.length - 1) {
      selectedCategoryIndex.value = filteredCategories.length - 1;
    }
    if (selectedCategoryIndex.value < 0 && filteredCategories.isNotEmpty) {
      selectedCategoryIndex.value = 0;
    }
    update(); // Trigger UI update
  }

  Future<void> stopVideo() async {
    final controller = videoController.value;
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    if (controller != null) {
      await controller.pause();
      await controller.dispose();
      videoController.value = null;
      WakelockPlus.disable();
    }
  }

  enablePlayController() {
    showPlayController.value = true;
    Future.delayed(const Duration(seconds: 3), () {
      showPlayController.value = false;
    });
  }

  initAspectList(context) async {
    aspectList = [
      16 / 9,
      // 16 / MediaQuery.of(context).size.height,
      // MediaQuery.of(context).size.width / 9,
      MediaQuery.of(context).size.width / MediaQuery.of(context).size.height,
    ];
    aspectRation.value = aspectList[aspectIndex];
    currentBrightness = await ScreenBrightness().current;
    currentVolume = await VolumeController().getVolume();
  }

  nextAspectRation() {
    aspectIndex++;
    aspectIndex = aspectIndex % aspectList.length;
    aspectRation.value = aspectList[aspectIndex];
  }

  changeBrightness(delta) async {
    showBrightnessUI.value = true;
    const sensitivity = 0.01;

    if (delta > 0) {
      // dragging DOWN → decrease
      currentBrightness -= sensitivity;
    } else {
      // dragging UP → increase
      currentBrightness += sensitivity;
    }
    currentBrightness = currentBrightness.clamp(0.0, 1.0);
    await ScreenBrightness().setScreenBrightness(currentBrightness);
    Future.delayed(const Duration(seconds: 1), () {
      showBrightnessUI.value = false;
    });
  }

  changeVolume(double delta) async {
    showVolumeUI.value = true;
    const sensitivity = 0.01;

    if (delta > 0) {
      currentVolume -= sensitivity;
    } else {
      currentVolume += sensitivity;
    }
    currentVolume = currentVolume.clamp(0.0, 1.0);

    VolumeController().setVolume(currentVolume);

    Future.delayed(const Duration(seconds: 1), () {
      showVolumeUI.value = false;
    });
  }
}
