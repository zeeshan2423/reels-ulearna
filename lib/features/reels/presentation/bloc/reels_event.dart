import 'package:equatable/equatable.dart';

abstract class ReelsEvent extends Equatable {
  const ReelsEvent();

  @override
  List<Object> get props => [];
}

class LoadReelsEvent extends ReelsEvent {
  final int page;
  final bool isRefresh;

  const LoadReelsEvent({required this.page, this.isRefresh = false});

  @override
  List<Object> get props => [page, isRefresh];
}

class RefreshReelsEvent extends ReelsEvent {}

class LoadMoreReelsEvent extends ReelsEvent {}
