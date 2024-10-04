import 'package:equatable/equatable.dart';
import 'package:tadaa/features/notification_page/data/notificationModel.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationSuccess extends NotificationState {}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);

  @override
  List<Object> get props => [message];
}

class NotificationsLoaded extends NotificationState {
  final List<NotificationModel> notifications;

  NotificationsLoaded(this.notifications);

  @override
  List<Object> get props => [notifications];
}
