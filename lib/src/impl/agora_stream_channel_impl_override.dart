import 'package:agora_rtc_engine/src/binding/agora_stream_channel_impl.dart'
    as sci_binding;
import 'package:agora_rtc_engine/src/binding_forward_export.dart';
import 'package:iris_method_channel/iris_method_channel.dart';

class StreamChannelImpl extends sci_binding.StreamChannelImpl
    with DisposableObject {
  StreamChannelImpl(IrisMethodChannel irisMethodChannel, this._channelName)
      : super(irisMethodChannel);

  final String _channelName;

  bool _released = false;

  @override
  Map<String, dynamic> createParams(Map<String, dynamic> param) {
    return {'channelName': _channelName, ...param};
  }

  @override
  Future<void> release() async {
    if (_released) {
      return;
    }

    _released = true;
    return super.release();
  }

  @override
  Future<void> dispose() async {
    await release();
  }
}
