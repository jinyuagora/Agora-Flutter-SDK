import 'package:agora_rtc_engine/src/binding/agora_stream_channel_impl.dart'
    as sci_binding;
import 'package:iris_method_channel/iris_method_channel.dart';

class StreamChannelImpl extends sci_binding.StreamChannelImpl
    implements DisposableObject {
  StreamChannelImpl(IrisMethodChannel irisMethodChannel, this._channelName)
      : super(irisMethodChannel);

  final String _channelName;

  @override
  Map<String, dynamic> createParams(Map<String, dynamic> param) {
    return {'channelName': _channelName};
  }

  @override
  Future<void> dispose() async {
    await release();
  }
}
