// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auction_contracts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auction _$AuctionFromJson(Map<String, dynamic> json) => Auction(
      json['AuctionId'] as String,
      json['Authorized'] as bool,
    );

Map<String, dynamic> _$AuctionToJson(Auction instance) => <String, dynamic>{
      'AuctionId': instance.auctionId,
      'Authorized': instance.authorized,
    };

BidPlaced _$BidPlacedFromJson(Map<String, dynamic> json) => BidPlaced(
      amount: (json['Amount'] as num).toInt(),
      user: json['User'] as String,
    );

Map<String, dynamic> _$BidPlacedToJson(BidPlaced instance) => <String, dynamic>{
      'Amount': instance.amount,
      'User': instance.user,
    };

ItemSold _$ItemSoldFromJson(Map<String, dynamic> json) => ItemSold(
      buyer: json['Buyer'] as String,
    );

Map<String, dynamic> _$ItemSoldToJson(ItemSold instance) => <String, dynamic>{
      'Buyer': instance.buyer,
    };
