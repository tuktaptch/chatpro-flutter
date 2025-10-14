import 'package:chat_pro/provider/authentication_provider.dart';
import 'package:flutter/widgets.dart';

class HomeScreenProvider with ChangeNotifier {
  final AuthenticationProvider _authProvider;

  final PageController pageController = PageController();
  int currentIndex = 0;
  double scrollOffset = 0;

  HomeScreenProvider(this._authProvider);

  void onPageChanged(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void onTapNavBar(int index) {
    currentIndex = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }

  void onScroll(double offset) {
    scrollOffset = offset;
    notifyListeners();
  }
}
