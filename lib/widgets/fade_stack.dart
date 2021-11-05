// import 'package:flutter/material.dart';
// import 'package:instagram_final/widgets/sign_in_form.dart';
// import 'package:instagram_final/widgets/sign_up_form.dart';
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
// // 여기는 몰라도 돼 어느정도 포기하자!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
//@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
// class FadeStack extends StatefulWidget {
//   final int selectedForm;
//
//   const FadeStack({Key? key, required this.selectedForm}) : super(key: key);
//   @override
//   _FadeStackState createState() => _FadeStackState();
// }
//
// class _FadeStackState extends State<FadeStack> with SingleTickerProviderStateMixin{ // animation 쓰려고 SingleTickerProviderStateMixin 에서 controller를 가져온다. 만약 animation이 여러개면 MultiTicker~~
//   late AnimationController _animationController;
//   List<Widget> forms = [ SignUpForm(), SignInForm()];
//
//
//   @override
//   void initState() {
//     _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
//     _animationController!.forward();         // 오류떠서 그냥안해
//     super.initState();
//   }
//
//   @override
//   void didUpdateWidget(FadeStack oldWidget) {
//
//     if(widget.selectedForm != oldWidget.selectedForm){
//       _animationController!.forward(from: 0.0); // 오류떠서 그냥안해
//     }
//     super.didUpdateWidget(oldWidget);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FadeTransition(
//       opacity: _animationController,
//       child: IndexedStack(
//         children: forms,
//         index: widget.selectedForm,
//       ),
//     );
//   }
// }
