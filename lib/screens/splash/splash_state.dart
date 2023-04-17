import 'package:flutter/material.dart';
import '/screens/splash/splash.dart';
import 'package:provider/provider.dart' as provider;
import '/providers/session_provider.dart';
import 'package:flutter/material.dart';

class SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void initState() {
    super.initState();
  }

}
