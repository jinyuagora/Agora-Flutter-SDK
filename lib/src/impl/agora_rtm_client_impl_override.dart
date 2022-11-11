import 'dart:convert';

import 'package:agora_rtc_engine/src/agora_rtc_engine_ext.dart';
import 'package:agora_rtc_engine/src/agora_rtm_client.dart';
import 'package:agora_rtc_engine/src/agora_stream_channel.dart';
import 'package:agora_rtc_engine/src/binding/agora_rtm_client_event_impl.dart';
import 'package:agora_rtc_engine/src/binding/agora_rtm_client_impl.dart'
    as rtmc_binding;
import 'package:iris_method_channel/iris_method_channel.dart';
import 'package:agora_rtc_engine/src/impl/agora_stream_channel_impl_override.dart';

class _StreamChannelScopedKey implements ScopedKey {
  const _StreamChannelScopedKey(this.channelName);
  final String channelName;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _StreamChannelScopedKey && other.channelName == channelName;
  }

  @override
  int get hashCode => channelName.hashCode;
}

class RtmClientImpl extends rtmc_binding.RtmClientImpl {
  RtmClientImpl._(IrisMethodChannel irisMethodChannel)
      : super(irisMethodChannel);

  factory RtmClientImpl.create() {
    if (_instance != null) return _instance!;

    _instance = RtmClientImpl._(IrisMethodChannel());

    return _instance!;
  }

  static RtmClientImpl? _instance;

  final ScopedObjects _scopedObjects = ScopedObjects();

  final DisposableScopedObjects _streamChannelObjects =
      DisposableScopedObjects();

  @override
  Future<StreamChannel> createStreamChannel(String channelName) async {
    final apiType =
        '${isOverrideClassName ? className : 'RtmClient'}_createStreamChannel';
    final param = createParams({'channelName': channelName});

    final callApiResult = await irisMethodChannel.invokeMethod(
        IrisMethodCall(apiType, jsonEncode(param), buffers: null));

    if (callApiResult.irisReturnCode < 0) {
      throw AgoraRtcException(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throw AgoraRtcException(code: result);
    }

    return _scopedObjects.putIfAbsent(
      _StreamChannelScopedKey(channelName),
      () {
        StreamChannelImpl streamChannel =
            StreamChannelImpl(irisMethodChannel, channelName);
        return streamChannel;
      },
    );
  }

  @override
  Future<void> initialize(RtmConfig config) async {
    await irisMethodChannel.initilize();
    _scopedObjects.putIfAbsent(
      const TypedScopedKey(RtmClientImpl),
      () => _streamChannelObjects,
    );

    const apiType = 'RtmClient_initialize';
    final param = {'config': config.toJson()};

    if (config.eventHandler != null) {
      final eventHandlerWrapper = RtmEventHandlerWrapper(config.eventHandler!);
      final callApiResult = await irisMethodChannel.registerEventHandler(
          ScopedEvent(
              ownerType: RtmClientImpl,
              registerName: 'RtmClient_initialize',
              unregisterName: '',
              params: jsonEncode(param),
              handler: eventHandlerWrapper));

      if (callApiResult.irisReturnCode < 0) {
        throw AgoraRtcException(code: callApiResult.irisReturnCode);
      }
      final rm = callApiResult.data;

      final result = rm['result'];

      if (result < 0) {
        throw AgoraRtcException(code: result);
      }
    } else {
      final callApiResult = await irisMethodChannel
          .invokeMethod(IrisMethodCall(apiType, jsonEncode(param)));
      if (callApiResult.irisReturnCode < 0) {
        throw AgoraRtcException(code: callApiResult.irisReturnCode);
      }
      final rm = callApiResult.data;
      final result = rm['result'];

      if (result < 0) {
        throw AgoraRtcException(code: result);
      }
    }
  }

  @override
  Future<void> release() async {
    await _scopedObjects.clear();

    try {
      await super.release();
    } catch (e) {
      // Do nothing
    }

    await irisMethodChannel.dispose();
  }
}
