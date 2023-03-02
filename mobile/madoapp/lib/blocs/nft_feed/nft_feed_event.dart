import 'package:equatable/equatable.dart';
import 'package:madoapp/models/nft_feed_element.dart';

abstract class NftFeedEvent extends Equatable {
  const NftFeedEvent();

  @override
  List<Object> get props => [];
}

class GetNftFeed extends NftFeedEvent {}

class ResetNftFeed extends NftFeedEvent {
  final List<NftFeedElement> nftFeedElements;
  const ResetNftFeed(this.nftFeedElements);
}
