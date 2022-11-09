import 'package:agora_rtc_engine/src/agora_rtm_client.dart';
import 'package:agora_rtc_engine/src/agora_stream_channel.dart';

class RtmClientImpl extends RtmClient {
  RtmClientImpl._();

  factory RtmClientImpl.create() {
    if (_instance != null) return _instance!;

    _instance = RtmClientImpl._();

    return _instance!;
  }

  static RtmClientImpl? _instance;

  final IrisMethodChannel? _irisMethodChannel;

  @override
  Future<StreamChannel> createStreamChannel(String channelName) {
    // TODO: implement createStreamChannel
    throw UnimplementedError();
  }

  @override
  Future<void> initialize(RtmConfig config) {
    // TODO: implement initialize
    throw UnimplementedError();
  }

  @override
  Future<void> release() {
    // TODO: implement release
    throw UnimplementedError();
  }
}
