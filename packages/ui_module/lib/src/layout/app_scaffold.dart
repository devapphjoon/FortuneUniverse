import 'package:flutter/material.dart';

class AppScaffold extends StatefulWidget {
  final List<Widget> pages;
  final List<BottomNavigationBarItem>? navItems;
  final Widget? drawer;
  final Widget? bottomFixedWidget;
  final bool showBottomNav;
  final bool showAppBar;
  final String title;

  const AppScaffold({
    super.key,
    required this.pages,
    this.navItems,
    this.drawer,
    this.bottomFixedWidget,
    this.showBottomNav = true,
    this.showAppBar = true,
    required this.title,
  });

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index >= 0 && index < widget.pages.length) {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // 안전 장치: navItems가 없거나 페이지 갯수와 안 맞으면 바텀 네비를 그리지 않음
    final bool canShowBottomNav = widget.showBottomNav && 
                                 widget.navItems != null && 
                                 widget.navItems!.length == widget.pages.length;

    return Scaffold(
      appBar: widget.showAppBar ? AppBar(
        title: Text(widget.title),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ) : null,
      drawer: widget.drawer, // 옵션으로 들어온 메뉴(Drawer) 띄우기
      body: widget.pages.isNotEmpty 
          ? widget.pages[_selectedIndex] 
          : const Center(child: Text('페이지가 없습니다.')),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canShowBottomNav)
            BottomNavigationBar(
              items: widget.navItems!,
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).colorScheme.primary,
              onTap: _onItemTapped,
            ),
          if (widget.bottomFixedWidget != null)
            SafeArea(
              top: false,
              child: widget.bottomFixedWidget!,
            ),
        ],
      ),
    );
  }
}
