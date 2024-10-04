abstract class WalletEvent {}

class AddPointsEvent extends WalletEvent {
  final String userId;
  final int points;
  final String actionType;
  final String actionId;

  AddPointsEvent(this.userId, this.points, this.actionType, this.actionId);
}

class DeductPointsEvent extends WalletEvent {
  final String userId;
  final int points;
  final String actionType;
  final String actionId;

  DeductPointsEvent(this.userId, this.points, this.actionType, this.actionId);
}
class FetchWalletEvent extends WalletEvent {
  final String userId;

  FetchWalletEvent(this.userId);
}