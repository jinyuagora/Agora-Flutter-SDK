import 'package:agora_rtc_engine/src/binding_forward_export.dart';
part 'agora_stream_channel.g.dart';

@JsonEnum(alwaysCreate: true)
enum RtmMessageQos {
  @JsonValue(0)
  rtmMessageQosUnordered,

  @JsonValue(1)
  rtmMessageQosOrdered,
}

/// Extensions functions of [RtmMessageQos].
extension RtmMessageQosExt on RtmMessageQos {
  /// @nodoc
  static RtmMessageQos fromValue(int value) {
    return $enumDecode(_$RtmMessageQosEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmMessageQosEnumMap[this]!;
  }
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class JoinChannelOptions {
  const JoinChannelOptions({this.token});

  @JsonKey(name: 'token')
  final String? token;
  factory JoinChannelOptions.fromJson(Map<String, dynamic> json) =>
      _$JoinChannelOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$JoinChannelOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class JoinTopicOptions {
  const JoinTopicOptions({this.qos, this.meta, this.metaLength});

  @JsonKey(name: 'qos')
  final RtmMessageQos? qos;

  @JsonKey(name: 'meta')
  final String? meta;

  @JsonKey(name: 'metaLength')
  final int? metaLength;
  factory JoinTopicOptions.fromJson(Map<String, dynamic> json) =>
      _$JoinTopicOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$JoinTopicOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class TopicOptions {
  const TopicOptions({this.users, this.userCount});

  @JsonKey(name: 'users')
  final List<String>? users;

  @JsonKey(name: 'userCount')
  final int? userCount;
  factory TopicOptions.fromJson(Map<String, dynamic> json) =>
      _$TopicOptionsFromJson(json);
  Map<String, dynamic> toJson() => _$TopicOptionsToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class UserList {
  const UserList({this.users, this.userCount});

  @JsonKey(name: 'users')
  final List<String>? users;

  @JsonKey(name: 'userCount')
  final int? userCount;
  factory UserList.fromJson(Map<String, dynamic> json) =>
      _$UserListFromJson(json);
  Map<String, dynamic> toJson() => _$UserListToJson(this);
}

abstract class StreamChannel {
  Future<void> join(JoinChannelOptions options);

  Future<void> leave();

  Future<String> getChannelName();

  Future<void> joinTopic(
      {required String topic, required JoinTopicOptions options});

  Future<void> publishTopicMessage(
      {required String topic, required String message, required int length});

  Future<void> leaveTopic(String topic);

  Future<void> subscribeTopic(
      {required String topic, required TopicOptions options});

  Future<void> unsubscribeTopic(
      {required String topic, required TopicOptions options});

  Future<UserList> getSubscribedUserList(String topic);

  Future<void> release();
}
