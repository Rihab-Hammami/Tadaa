import 'package:tadaa/features/wallet_page/data/model/walletModel.dart';

abstract class WalletState {}

class WalletInitial extends WalletState {}

class WalletLoading extends WalletState {}

class WalletSuccess extends WalletState {}

class WalletError extends WalletState {
  final String message;

  WalletError(this.message);
}
class WalletLoaded extends WalletState {
  final List<WalletModel> wallets;

  WalletLoaded(this.wallets);
}