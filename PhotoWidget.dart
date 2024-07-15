import 'dart:async';

import 'package:flutter/material.dart';

class PhotoWidget extends StatefulWidget {
  const PhotoWidget({super.key});

  @override
  State<PhotoWidget> createState() => _PhotoWidgetState();
}

class _PhotoWidgetState extends State<PhotoWidget> {
  final PageController _pageController = PageController();
  final List<String> _imagePaths = [
    'lib/images/image1.jpg',
    'lib/images/image2.jpg',
    'lib/images/image3.jpg',
  ];
  int _currentPage = 0;
  Timer? _timer; // Timer is nullable now

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startAutoScroll();
    });
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (!mounted) return; // Check if the widget is still mounted
      setState(() {
        if (_currentPage < _imagePaths.length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }

        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: 150, // Specify the height here
            child: PageView.builder(
              controller: _pageController,
              itemCount: _imagePaths.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    _imagePaths[index],
                    fit: BoxFit.cover,
                  ),
                );
              },
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _buildPageIndicator(),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i < _imagePaths.length; i++) {
      indicators.add(
        Container(
          width: 8.0,
          height: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == i
                ? Color.fromARGB(255, 58, 139, 148)
                : Colors.grey,
          ),
        ),
      );
    }
    return indicators;
  }
}
