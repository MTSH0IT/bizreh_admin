import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class MainNavEntry {
  final String title;
  final Widget page;

  const MainNavEntry({required this.title, required this.page});
}

class MainNavController extends GetxController {
  final RxList<MainNavEntry> _stack = <MainNavEntry>[].obs;

  List<MainNavEntry> get stack => _stack;

  bool get canPop => _stack.length > 1;

  Widget get current =>
      _stack.isNotEmpty ? _stack.last.page : const SizedBox.shrink();

  void resetTo(MainNavEntry root) {
    _stack.assignAll([root]);
  }

  void push(MainNavEntry entry) {
    _stack.add(entry);
  }

  void pop() {
    if (_stack.length > 1) {
      _stack.removeLast();
    }
  }

  void popToRoot() {
    if (_stack.isNotEmpty) {
      _stack.assignAll([_stack.first]);
    }
  }
}
