import 'package:get/get.dart';

class EmailVerficationTimeout extends GetxController {
  RxInt timeOut = 60.obs;
  decrement() {
    timeOut.value--;
  }
}
