import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/reels/presentation/bloc/reels_bloc.dart';

extension ContextExtension on BuildContext {
  ReelsBloc get reelsBloc => read<ReelsBloc>();
}
