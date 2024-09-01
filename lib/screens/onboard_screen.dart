import 'package:flutter/material.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:kisanseva/constant.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({super.key});

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

final _controller = PageController(
  initialPage: 0,
);

int _currentPage=0;

List<Widget> _page =[
  Column(
    children: [
      Expanded(child: Image.asset("images/Online_Shoping_29.jpg")),
      Text("Set Your Delivery Location",style: kPageViewTextStyle,textAlign: TextAlign.center,),
    ],
  ),

  Column(
    children: [
     Expanded(child: Image.asset("images/Online_Shoping_29.jpg")),
      Text("Order Online from Your Favourite Farmer",style: kPageViewTextStyle,textAlign: TextAlign.center),

    ],
  ),

  Column(
    children: [
      Expanded(child: Image.asset("images/Online_Shoping_29.jpg")),
      Text("Quick Deliver to your Doorstep",style: kPageViewTextStyle,textAlign: TextAlign.center),
    ],
  ),


];

class _OnboardScreenState extends State<OnboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
        children: [Expanded(
          child: PageView(
            controller: _controller,
            children: _page,
            onPageChanged: (index){

              setState(() {
                _currentPage = index;
              });

            },
          ),
        ),
          DotsIndicator(
            dotsCount: _page.length,
            position: _currentPage.toDouble(),
            decorator: DotsDecorator(
                shape: const Border(),
                activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
                activeColor: Colors.deepOrangeAccent
            ),
          )


        ]
    );
  }
}
