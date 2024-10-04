
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadaa/features/wallet_page/presentation/widgets/walletWidget.dart';
import 'package:tadaa/features/profile_page/presentation/blocs/profile_bloc.dart';
import 'package:tadaa/features/wallet_page/data/model/walletModel.dart';
import 'package:tadaa/features/wallet_page/domain/repository/walletRepository.dart';
import 'package:tadaa/features/wallet_page/presentation/bloc/walletBloc.dart';
import 'package:tadaa/features/wallet_page/presentation/bloc/walletEvent.dart';
import 'package:tadaa/features/wallet_page/presentation/bloc/walletState.dart';

class WalletScreen extends StatelessWidget {
  final String userId;

  WalletScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WalletBloc(
        context.read<WalletRepository>(),
        context.read<ProfileBloc>(),
      )..add(FetchWalletEvent(userId)), // Dispatch event to fetch wallets
      child: Scaffold(
        body: BlocBuilder<WalletBloc, WalletState>(
          builder: (context, state) {
            if (state is WalletLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is WalletLoaded) {
              return ListView.builder(
                itemCount: state.wallets.length,
                itemBuilder: (context, index) {
                  WalletModel wallet = state.wallets[index];
                  return WalletCard(wallet: wallet); 
                },
              );
            } else if (state is WalletError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return Center(child: Text('No transactions found.'));
            }
          },
        ),
      ),
    );
  }
}
