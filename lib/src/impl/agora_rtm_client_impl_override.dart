import 'dart:convert';

import 'package:agora_rtc_engine/src/agora_rtc_engine_ext.dart';
import 'package:agora_rtc_engine/src/agora_rtm_client.dart';
import 'package:agora_rtc_engine/src/agora_stream_channel.dart';
import 'package:agora_rtc_engine/src/binding/agora_rtm_client_event_impl.dart';
import 'package:iris_method_channel/iris_method_channel.dart';

class RtmClientImpl extends RtmClient {
  RtmClientImpl._();

  factory RtmClientImpl.create() {
    if (_instance != null) return _instance!;

    _instance = RtmClientImpl._();

    return _instance!;
  }

  static RtmClientImpl? _instance;

  IrisMethodChannel? _irisMethodChannel;

  @override
  Future<StreamChannel> createStreamChannel(String channelName) {
    // TODO: implement createStreamChannel
    throw UnimplementedError();
  }

  @override
  Future<void> initialize(RtmConfig config) async {
    _irisMethodChannel = IrisMethodChannel();
    await _irisMethodChannel!.initilize();

    const apiType = 'RtmClient_initialize';
    final param = {'config': config.toJson()};

    if (config.eventHandler != null) {
      final eventHandlerWrapper = RtmEventHandlerWrapper(config.eventHandler!);
      final callApiResult = await _irisMethodChannel!.registerEventHandler(
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
      final callApiResult = await _irisMethodChannel!
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
  Future<void> release() {
    // TODO: implement release
    throw UnimplementedError();
  }
}
