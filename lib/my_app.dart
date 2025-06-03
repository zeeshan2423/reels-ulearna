import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/services/injection_container.dart' as di;
import 'features/reels/presentation/bloc/reels_bloc.dart';
import 'features/reels/presentation/pages/reels_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ulearna Reels',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: BlocProvider(
        create: (_) => di.sl<ReelsBloc>(),
        child: const ReelsPage(),
      ),
    );
  }
}
