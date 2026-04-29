import 'package:get/get.dart';
import 'package:test/scaffolding.dart';

void main() {
  setUp(() {
    Get.testMode = true;

    // Get.lazyPut(() => HomeController());
    // Get.put(APIService()); // if used
    // Add other dependencies used in ChannelGrid
  });

  tearDown(() {
    Get.reset(); // clean up after each test
  });
}
