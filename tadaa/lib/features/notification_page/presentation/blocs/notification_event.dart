import 'package:equatable/equatable.dart';
import 'package:tadaa/features/notification_page/data/notificationModel.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class AddNotificationEvent extends NotificationEvent {
  final NotificationModel notification;

  AddNotificationEvent(this.notification);

  @override
  List<Object> get props => [notification];
}

class FetchNotificationsEvent extends NotificationEvent {
  final String userId;

  FetchNotificationsEvent({required this.userId,});

  @override
  List<Object> get props => [userId];
}
