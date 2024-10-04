import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/notification_page/data/notificationModel.dart';
import 'package:tadaa/features/notification_page/domain/notificationRepository.dart';
import 'package:tadaa/features/notification_page/presentation/blocs/notification_event.dart';
import 'package:tadaa/features/notification_page/presentation/blocs/notification_state.dart';


class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationBloc(this._notificationRepository) : super(NotificationInitial()) {
    on<AddNotificationEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        await _notificationRepository.addNotification(event.notification);
        emit(NotificationSuccess());
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<FetchNotificationsEvent>((event, emit) async {
      emit(NotificationLoading());
      try {
        List<NotificationModel> notifications = await _notificationRepository.fetchNotifications(event.userId);
        emit(NotificationsLoaded(notifications));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
    
  }
}
