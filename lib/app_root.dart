import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:alarp/main.dart'; // Import MyApp

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MyApp();
  }
}
