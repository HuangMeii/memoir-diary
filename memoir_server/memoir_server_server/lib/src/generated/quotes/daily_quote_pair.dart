/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:memoir_server_server/src/generated/protocol.dart' as _is9lv3rz;
import 'package:serverpod/serverpod.dart' as _is;
import '../quotes/quote.dart' as _iuqb9zkt;
import '../quotes/self_message.dart' as _izvfht5u;

/// The stored daily pair expanded with its quote rows.
abstract class DailyQuotePair
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DailyQuotePair._({
    required this.id,
    required this.quoteDate,
    this.quote,
    this.quote2,
    this.selfMessage,
  });

  factory DailyQuotePair({
    required _is.UuidValue id,
    required DateTime quoteDate,
    _iuqb9zkt.Quote? quote,
    _iuqb9zkt.Quote? quote2,
    _izvfht5u.SelfMessage? selfMessage,
  }) = _DailyQuotePairImpl;

  factory DailyQuotePair.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailyQuotePair(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      quoteDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['quoteDate'],
      ),
      quote: jsonSerialization['quote'] == null
          ? null
          : _is9lv3rz.Protocol().deserialize<_iuqb9zkt.Quote>(
              jsonSerialization['quote'],
            ),
      quote2: jsonSerialization['quote2'] == null
          ? null
          : _is9lv3rz.Protocol().deserialize<_iuqb9zkt.Quote>(
              jsonSerialization['quote2'],
            ),
      selfMessage: jsonSerialization['selfMessage'] == null
          ? null
          : _is9lv3rz.Protocol().deserialize<_izvfht5u.SelfMessage>(
              jsonSerialization['selfMessage'],
            ),
    );
  }

  _is.UuidValue id;

  DateTime quoteDate;

  _iuqb9zkt.Quote? quote;

  _iuqb9zkt.Quote? quote2;

  _izvfht5u.SelfMessage? selfMessage;

  /// Returns a shallow copy of this [DailyQuotePair]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DailyQuotePair copyWith({
    _is.UuidValue? id,
    DateTime? quoteDate,
    _iuqb9zkt.Quote? quote,
    _iuqb9zkt.Quote? quote2,
    _izvfht5u.SelfMessage? selfMessage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailyQuotePair',
      'id': id.toJson(),
      'quoteDate': quoteDate.toJson(),
      if (quote != null) 'quote': quote?.toJson(),
      if (quote2 != null) 'quote2': quote2?.toJson(),
      if (selfMessage != null) 'selfMessage': selfMessage?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailyQuotePair',
      'id': id.toJson(),
      'quoteDate': quoteDate.toJson(),
      if (quote != null) 'quote': quote?.toJsonForProtocol(),
      if (quote2 != null) 'quote2': quote2?.toJsonForProtocol(),
      if (selfMessage != null) 'selfMessage': selfMessage?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DailyQuotePairImpl extends DailyQuotePair {
  _DailyQuotePairImpl({
    required _is.UuidValue id,
    required DateTime quoteDate,
    _iuqb9zkt.Quote? quote,
    _iuqb9zkt.Quote? quote2,
    _izvfht5u.SelfMessage? selfMessage,
  }) : super._(
         id: id,
         quoteDate: quoteDate,
         quote: quote,
         quote2: quote2,
         selfMessage: selfMessage,
       );

  /// Returns a shallow copy of this [DailyQuotePair]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DailyQuotePair copyWith({
    _is.UuidValue? id,
    DateTime? quoteDate,
    Object? quote = _Undefined,
    Object? quote2 = _Undefined,
    Object? selfMessage = _Undefined,
  }) {
    return DailyQuotePair(
      id: id ?? this.id,
      quoteDate: quoteDate ?? this.quoteDate,
      quote: quote is _iuqb9zkt.Quote? ? quote : this.quote?.copyWith(),
      quote2: quote2 is _iuqb9zkt.Quote? ? quote2 : this.quote2?.copyWith(),
      selfMessage: selfMessage is _izvfht5u.SelfMessage?
          ? selfMessage
          : this.selfMessage?.copyWith(),
    );
  }
}
