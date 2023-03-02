import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:madoapp/api/course_api.dart';
import 'package:madoapp/api/nft_feed_api.dart';
import 'package:madoapp/blocs/balance/balance_bloc.dart';
import 'package:madoapp/blocs/balance/balance_event.dart';
import 'package:madoapp/configs/nft_feed_server_config.dart';
import 'package:madoapp/models/nft_feed_element.dart';
import 'package:madoapp/models/wallet_connect_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'nft_feed_event.dart';
import 'nft_feed_state.dart';

class NftFeedBloc extends Bloc<NftFeedEvent, NftFeedState> {
  NftFeedBloc() : super(NftFeedInitial()) {
    on<ResetNftFeed>((event, emit) async {
      try {
        late List<NftFeedElement> fetchedNftFeed = event.nftFeedElements;
        NftFeedApi.saveNftFeedLocally(fetchedNftFeed);
        emit(NftFeedLoaded(fetchedNftFeed, 0, false, fetchedNftFeed.isEmpty));
      } catch (e) {
        print(e);
        emit(NftFeedError(e.toString()));
      }
    });
    on<GetNftFeed>((event, emit) async {
      try {
        final currentState = nftFeedBloc.state;
        if (currentState is NftFeedLoading) return;
        emit(NftFeedLoading());
        int latestLoadedPage = -1;
        List<NftFeedElement> latestLoadedList = [];
        if (currentState is NftFeedLoaded) {
          latestLoadedPage = currentState.page;
          latestLoadedList = currentState.nftFeedElements;
        }
        List<NftFeedElement> latestSavedNftFeed = [];
        if (currentState is NftFeedInitial) {
          latestSavedNftFeed = (await NftFeedApi.getNftFeedLocally()) ?? [];

          if (latestSavedNftFeed.isNotEmpty) {
            emit(NftFeedLoaded(latestSavedNftFeed, -1, true));
          }
        }
        late List<NftFeedElement> fetchedNftFeed;
        try {
          fetchedNftFeed = await NftFeedApi.fetchNftFeed(
              latestLoadedPage + 1, NftFeedServerConfig.totalFeedCount);
        } catch (e) {
          print(e);
          fetchedNftFeed = [];
        }
        List<NftFeedElement> loadedNftFeed = latestLoadedList + fetchedNftFeed;
        if (loadedNftFeed.isEmpty && latestSavedNftFeed.isNotEmpty) {
          return;
        }
        NftFeedApi.saveNftFeedLocally(loadedNftFeed);

        emit(NftFeedLoaded(loadedNftFeed, latestLoadedPage + 1, false,
            fetchedNftFeed.isEmpty));
      } catch (e) {
        print(e);
        emit(NftFeedError(e.toString()));
      }
    });
  }
}

final nftFeedBloc = NftFeedBloc();
