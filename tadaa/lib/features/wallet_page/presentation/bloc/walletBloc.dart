import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_bloc.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_event.dart';
import 'package:tadaa/features/wallet_page/data/model/walletModel.dart';
import 'package:tadaa/features/wallet_page/domain/repository/walletRepository.dart';
import 'package:tadaa/features/wallet_page/presentation/bloc/walletEvent.dart';
import 'package:tadaa/features/wallet_page/presentation/bloc/walletState.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository _walletRepository;
  final ProfileBloc _profileBloc;

  WalletBloc(this._walletRepository, this._profileBloc) : super(WalletInitial()) {
    on<AddPointsEvent>((event, emit) async {
      emit(WalletLoading());
      try {
        await _walletRepository.addPoints(event.userId, event.points, event.actionType, event.actionId);
        emit(WalletSuccess());
        _profileBloc.add(FetchProfile(event.userId));       
      } catch (e) {
        emit(WalletError(e.toString()));
      }
    });
    
    on<DeductPointsEvent>((event, emit) async {
      emit(WalletLoading());
      try {
        await _walletRepository.deductPoints(event.userId, event.points, event.actionType, event.actionId);
        emit(WalletSuccess());
        _profileBloc.add(FetchProfile(event.userId)); 
      } catch (e) {
        emit(WalletError(e.toString()));
      }
    });
  

    on<FetchWalletEvent>((event, emit) async {
            emit(WalletLoading());
            try {
              List<WalletModel> wallets = await _walletRepository.getWallets(event.userId);
              emit(WalletLoaded(wallets));
            } catch (e) {
              emit(WalletError(e.toString()));
            }
          });
        }
}
