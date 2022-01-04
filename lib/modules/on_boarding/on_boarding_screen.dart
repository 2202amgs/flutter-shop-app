import 'package:flutter/material.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/global_components.dart';
import 'package:shop_app/shared/local/cache_helper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  void submit(context) {
    CacheHelper.save(key: 'onBoarding', value: false).then((value) {
      navigateAndReplace(
        context,
        const LoginScreen(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    PageController pageController = PageController();
    List<BoardingModel> pages = [
      BoardingModel('1.png', 'tilte', 'body'),
      BoardingModel('2.jpg', 'tilte', 'body'),
      BoardingModel('3.png', 'tilte', 'body'),
    ];
    bool isLast = false;

    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              submit(context);
            },
            child: const Text('Skip'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemBuilder: (context, index) => buildBoardItem(pages[index]),
                itemCount: pages.length,
                onPageChanged: (index) {
                  if (index == pages.length - 1) {
                    isLast = true;
                  } else {
                    isLast = false;
                  }
                },
              ),
            ),
            const SizedBox(
              height: 40.0,
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: pageController,
                  count: pages.length,
                  effect: const ExpandingDotsEffect(),
                ),
                const Spacer(),
                FloatingActionButton(
                  onPressed: () {
                    if (isLast) {
                      submit(context);
                    } else {
                      pageController.nextPage(
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.linearToEaseOut,
                      );
                    }
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBoardItem(BoardingModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
            image: AssetImage('assets/images/${model.image}'),
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          model.tiltle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
        const SizedBox(
          height: 30,
        ),
        Text(
          model.body,
          style: const TextStyle(
            fontSize: 14.0,
          ),
        ),
      ],
    );
  }
}

class BoardingModel {
  final String image;
  final String tiltle;
  final String body;

  BoardingModel(this.image, this.tiltle, this.body);
}
