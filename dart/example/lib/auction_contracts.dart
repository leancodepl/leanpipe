import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:leancode_pipe/leancode_pipe.dart';

part 'auction_contracts.g.dart';

@JsonSerializable(fieldRename: FieldRename.pascal)
class Auction with EquatableMixin implements Topic<AuctionNotification> {
  Auction(this.auctionId, this.authorized);

  @override
  AuctionNotification? castNotification(String tag, dynamic json) =>
      switch (tag) {
        'LeanPipe.Example.Contracts.BidPlaced' =>
          AuctionNotificationBidPlaced.fromJson(json as Map<String, dynamic>),
        'LeanPipe.Example.Contracts.ItemSold' =>
          AuctionNotificationItemSold.fromJson(json as Map<String, dynamic>),
        _ => null
      } as AuctionNotification?;

  final String auctionId;
  final bool authorized;

  @override
  String getFullName() => 'LeanPipe.Example.Contracts.Auction';

  @override
  Map<String, dynamic> toJson() => _$AuctionToJson(this);

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [auctionId, authorized];

  @override
  Topic<AuctionNotification> fromJson(Map<String, dynamic> json) =>
      _$AuctionFromJson(json);
}

sealed class AuctionNotification {}

@JsonSerializable(fieldRename: FieldRename.pascal)
class BidPlaced with EquatableMixin {
  BidPlaced({
    required this.amount,
    required this.user,
  });

  factory BidPlaced.fromJson(Map<String, dynamic> json) =>
      _$BidPlacedFromJson(json);

  final int amount;

  final String user;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [amount, user];

  Map<String, dynamic> toJson() => _$BidPlacedToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.pascal)
class ItemSold with EquatableMixin {
  ItemSold({
    required this.buyer,
  });

  factory ItemSold.fromJson(Map<String, dynamic> json) =>
      _$ItemSoldFromJson(json);

  final String buyer;

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [buyer];

  Map<String, dynamic> toJson() => _$ItemSoldToJson(this);
}

class AuctionNotificationBidPlaced
    with EquatableMixin
    implements AuctionNotification {
  const AuctionNotificationBidPlaced(this.value);

  factory AuctionNotificationBidPlaced.fromJson(Map<String, dynamic> json) =>
      AuctionNotificationBidPlaced(BidPlaced.fromJson(json));

  final BidPlaced value;
  Map<String, dynamic> toJson() => value.toJson();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [value];
}

class AuctionNotificationItemSold
    with EquatableMixin
    implements AuctionNotification {
  const AuctionNotificationItemSold(this.value);

  factory AuctionNotificationItemSold.fromJson(Map<String, dynamic> json) =>
      AuctionNotificationItemSold(ItemSold.fromJson(json));

  final ItemSold value;
  Map<String, dynamic> toJson() => value.toJson();

  @override
  bool? get stringify => true;

  @override
  List<Object?> get props => [value];
}
