import 'package:madoapp/models/nft_feed_element.dart';

abstract class NftFeedState {
  const NftFeedState();
}

class NftFeedInitial extends NftFeedState {}

class NftFeedLoading extends NftFeedState {}

class NftFeedLoaded extends NftFeedState {
  final List<NftFeedElement> nftFeedElements;
  final int page;
  final bool isBackup;
  final bool isScrollEnd;
  const NftFeedLoaded(this.nftFeedElements, this.page,
      [this.isBackup = false, this.isScrollEnd = false]);
}

class NftFeedError extends NftFeedState {
  final String? message;
  const NftFeedError(this.message);
}
