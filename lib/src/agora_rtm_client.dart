import 'package:agora_rtc_engine/src/binding_forward_export.dart';
part 'agora_rtm_client.g.dart';

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class RtmConfig {
  const RtmConfig({this.appId, this.userId, this.eventHandler, this.logConfig});

  @JsonKey(name: 'appId')
  final String? appId;

  @JsonKey(name: 'userId')
  final String? userId;

  @JsonKey(name: 'eventHandler', ignore: true)
  final RtmEventHandler? eventHandler;

  @JsonKey(name: 'logConfig')
  final LogConfig? logConfig;
  factory RtmConfig.fromJson(Map<String, dynamic> json) =>
      _$RtmConfigFromJson(json);
  Map<String, dynamic> toJson() => _$RtmConfigToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class TopicInfo {
  const TopicInfo(
      {this.topic,
      this.numOfPublisher,
      this.publisherUserIds,
      this.publisherMetas});

  @JsonKey(name: 'topic')
  final String? topic;

  @JsonKey(name: 'numOfPublisher')
  final int? numOfPublisher;

  @JsonKey(name: 'publisherUserIds')
  final List<String>? publisherUserIds;

  @JsonKey(name: 'publisherMetas')
  final List<String>? publisherMetas;
  factory TopicInfo.fromJson(Map<String, dynamic> json) =>
      _$TopicInfoFromJson(json);
  Map<String, dynamic> toJson() => _$TopicInfoToJson(this);
}

@JsonEnum(alwaysCreate: true)
enum RtmErrorCode {
  @JsonValue(10001)
  rtmErrTopicAlreadyJoined,

  @JsonValue(10002)
  rtmErrExceedJoinTopicLimitation,

  @JsonValue(10003)
  rtmErrInvalidTopicName,

  @JsonValue(10004)
  rtmErrPublishTopicMessageFailed,

  @JsonValue(10005)
  rtmErrExceedSubscribeTopicLimitation,

  @JsonValue(10006)
  rtmErrExceedUserLimitation,

  @JsonValue(10007)
  rtmErrExceedChannelLimitation,

  @JsonValue(10008)
  rtmErrAlreadyJoinChannel,

  @JsonValue(10009)
  rtmErrNotJoinChannel,
}

/// Extensions functions of [RtmErrorCode].
extension RtmErrorCodeExt on RtmErrorCode {
  /// @nodoc
  static RtmErrorCode fromValue(int value) {
    return $enumDecode(_$RtmErrorCodeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmErrorCodeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmConnectionState {
  @JsonValue(1)
  rtmConnectionStateDisconnected,

  @JsonValue(2)
  rtmConnectionStateConnecting,

  @JsonValue(3)
  rtmConnectionStateConnected,

  @JsonValue(4)
  rtmConnectionStateReconnecting,

  @JsonValue(5)
  rtmConnectionStateFailed,
}

/// Extensions functions of [RtmConnectionState].
extension RtmConnectionStateExt on RtmConnectionState {
  /// @nodoc
  static RtmConnectionState fromValue(int value) {
    return $enumDecode(_$RtmConnectionStateEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmConnectionStateEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmConnectionChangeReason {
  @JsonValue(0)
  rtmConnectionChangedConnecting,

  @JsonValue(1)
  rtmConnectionChangedJoinSuccess,

  @JsonValue(2)
  rtmConnectionChangedInterrupted,

  @JsonValue(3)
  rtmConnectionChangedBannedByServer,

  @JsonValue(4)
  rtmConnectionChangedJoinFailed,

  @JsonValue(5)
  rtmConnectionChangedLeaveChannel,

  @JsonValue(6)
  rtmConnectionChangedInvalidAppId,

  @JsonValue(7)
  rtmConnectionChangedInvalidChannelName,

  @JsonValue(8)
  rtmConnectionChangedInvalidToken,

  @JsonValue(9)
  rtmConnectionChangedTokenExpired,

  @JsonValue(10)
  rtmConnectionChangedRejectedByServer,

  @JsonValue(11)
  rtmConnectionChangedSettingProxyServer,

  @JsonValue(12)
  rtmConnectionChangedRenewToken,

  @JsonValue(13)
  rtmConnectionChangedClientIpAddressChanged,

  @JsonValue(14)
  rtmConnectionChangedKeepAliveTimeout,

  @JsonValue(15)
  rtmConnectionChangedRejoinSuccess,

  @JsonValue(16)
  rtmConnectionChangedLost,

  @JsonValue(17)
  rtmConnectionChangedEchoTest,

  @JsonValue(18)
  rtmConnectionChangedClientIpAddressChangedByUser,

  @JsonValue(19)
  rtmConnectionChangedSameUidLogin,

  @JsonValue(20)
  rtmConnectionChangedTooManyBroadcasters,
}

/// Extensions functions of [RtmConnectionChangeReason].
extension RtmConnectionChangeReasonExt on RtmConnectionChangeReason {
  /// @nodoc
  static RtmConnectionChangeReason fromValue(int value) {
    return $enumDecode(_$RtmConnectionChangeReasonEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmConnectionChangeReasonEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmChannelType {
  @JsonValue(0)
  rtmChannelTypeMessage,

  @JsonValue(1)
  rtmChannelTypeStream,
}

/// Extensions functions of [RtmChannelType].
extension RtmChannelTypeExt on RtmChannelType {
  /// @nodoc
  static RtmChannelType fromValue(int value) {
    return $enumDecode(_$RtmChannelTypeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmChannelTypeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum RtmPresenceType {
  @JsonValue(0)
  rtmPresenceTypeRemoteJoinChannel,

  @JsonValue(1)
  rtmPresenceTypeRemoteLeaveChannel,

  @JsonValue(2)
  rtmPresenceTypeRemoteConnectionTimeout,

  @JsonValue(3)
  rtmPresenceTypeRemoteJoinTopic,

  @JsonValue(4)
  rtmPresenceTypeRemoteLeaveTopic,

  @JsonValue(5)
  rtmPresenceTypeSelfJoinChannel,
}

/// Extensions functions of [RtmPresenceType].
extension RtmPresenceTypeExt on RtmPresenceType {
  /// @nodoc
  static RtmPresenceType fromValue(int value) {
    return $enumDecode(_$RtmPresenceTypeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$RtmPresenceTypeEnumMap[this]!;
  }
}

@JsonEnum(alwaysCreate: true)
enum StreamChannelErrorCode {
  @JsonValue(0)
  streamChannelErrorOk,

  @JsonValue(1)
  streamChannelErrorExceedLimitation,

  @JsonValue(2)
  streamChannelErrorUserNotExist,
}

/// Extensions functions of [StreamChannelErrorCode].
extension StreamChannelErrorCodeExt on StreamChannelErrorCode {
  /// @nodoc
  static StreamChannelErrorCode fromValue(int value) {
    return $enumDecode(_$StreamChannelErrorCodeEnumMap, value);
  }

  /// @nodoc
  int value() {
    return _$StreamChannelErrorCodeEnumMap[this]!;
  }
}

class RtmEventHandler {
  /// Construct the [RtmEventHandler].
  const RtmEventHandler({
    this.onMessageEvent,
    this.onPresenceEvent,
    this.onJoinResult,
    this.onLeaveResult,
    this.onJoinTopicResult,
    this.onLeaveTopicResult,
    this.onTopicSubscribed,
    this.onTopicUnsubscribed,
    this.onConnectionStateChange,
  });

  final void Function(MessageEvent event)? onMessageEvent;

  final void Function(PresenceEvent event)? onPresenceEvent;

  final void Function(
          String channelName, String userId, StreamChannelErrorCode errorCode)?
      onJoinResult;

  final void Function(
          String channelName, String userId, StreamChannelErrorCode errorCode)?
      onLeaveResult;

  final void Function(String channelName, String userId, String topic,
      String meta, StreamChannelErrorCode errorCode)? onJoinTopicResult;

  final void Function(String channelName, String userId, String topic,
      String meta, StreamChannelErrorCode errorCode)? onLeaveTopicResult;

  final void Function(
      String channelName,
      String userId,
      String topic,
      UserList succeedUsers,
      UserList failedUsers,
      StreamChannelErrorCode errorCode)? onTopicSubscribed;

  final void Function(
      String channelName,
      String userId,
      String topic,
      UserList succeedUsers,
      UserList failedUsers,
      StreamChannelErrorCode errorCode)? onTopicUnsubscribed;

  final void Function(String channelName, RtmConnectionState state,
      RtmConnectionChangeReason reason)? onConnectionStateChange;
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class MessageEvent {
  const MessageEvent(
      {this.channelType,
      this.channelName,
      this.channelTopic,
      this.message,
      this.messageLength,
      this.publisher});

  @JsonKey(name: 'channelType')
  final RtmChannelType? channelType;

  @JsonKey(name: 'channelName')
  final String? channelName;

  @JsonKey(name: 'channelTopic')
  final String? channelTopic;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'messageLength')
  final int? messageLength;

  @JsonKey(name: 'publisher')
  final String? publisher;
  factory MessageEvent.fromJson(Map<String, dynamic> json) =>
      _$MessageEventFromJson(json);
  Map<String, dynamic> toJson() => _$MessageEventToJson(this);
}

@JsonSerializable(explicitToJson: true, includeIfNull: false)
class PresenceEvent {
  const PresenceEvent(
      {this.channelType,
      this.type,
      this.channelName,
      this.topicInfos,
      this.topicInfoNumber,
      this.userId});

  @JsonKey(name: 'channelType')
  final RtmChannelType? channelType;

  @JsonKey(name: 'type')
  final RtmPresenceType? type;

  @JsonKey(name: 'channelName')
  final String? channelName;

  @JsonKey(name: 'topicInfos')
  final List<TopicInfo>? topicInfos;

  @JsonKey(name: 'topicInfoNumber')
  final int? topicInfoNumber;

  @JsonKey(name: 'userId')
  final String? userId;
  factory PresenceEvent.fromJson(Map<String, dynamic> json) =>
      _$PresenceEventFromJson(json);
  Map<String, dynamic> toJson() => _$PresenceEventToJson(this);
}

abstract class RtmClient {
  Future<void> initialize(RtmConfig config);

  Future<void> release();

  Future<StreamChannel> createStreamChannel(String channelName);
}
