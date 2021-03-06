import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/models/notification_model.dart';
import '../data/repositories/settings_repo.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({required ISettingsRepo settingsRepo})
      : _settingRepo = settingsRepo,
        super(const NotificationsState());

  final ISettingsRepo _settingRepo;

  void clearOffset() {
    emit(state.copyWith(
      offset: 1,
      hasReachedMax: false,
      notifications: [],
    ));
  }

  Future<void> fetchNotifications() async {
    if (!state.isLoading && !state.hasReachedMax) {
      emit(state.copyWith(isLoading: true));

      final response = await _settingRepo.fetchNotifications(params: {
        'offset': state.offset,
        'limit': state.limit,
        'orderBy': 'created_at',
        'sortedBy': 'desc',
      });

      emit(state.copyWith(
        isLoading: false,
        notifications: [...state.notifications, ...response.result ?? []],
        offset: response.status ? state.offset + state.limit : null,
        hasReachedMax:
            response.result != null ? response.result!.isEmpty : null,
      ));
    }
  }
}
