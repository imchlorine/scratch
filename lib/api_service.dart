import 'dart:math';



/*
* Stub API Service
*/

class APIService {
  int totalScratch = 100;
  int minPoints = 100;
  int maxPoints = 250;
  Future<bool> getScratchCard() async {
    if (totalScratch > 0) {
      int n = getRandomNumber(1, 10);
      if (n < 5) {
        totalScratch--;
      }
      return n < 5 ? true : false;
    } else {
      return false;
    }
  }

  Future<int> getScratchPoints() async {
    return getRandomNumber(minPoints, maxPoints);
  }

  int getRandomNumber(int min, int max) {
    int res = min + Random().nextInt(max - min + 1);
    return res;
  }
}
