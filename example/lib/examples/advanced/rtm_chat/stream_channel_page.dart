import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtc_engine_example/config/agora.config.dart' as config;
import 'package:agora_rtc_engine_example/components/example_actions_widget.dart';
import 'package:agora_rtc_engine_example/components/log_sink.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// StreamChannelPage Example
class StreamChannelPage extends StatefulWidget {
  /// Construct the [StreamChannelPage]
  const StreamChannelPage({Key? key, required this.streamChannel})
      : super(key: key);

  final StreamChannel streamChannel;

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<StreamChannelPage> {
  late final RtcEngine _engine;
  bool _isReadyPreview = false;

  late final StreamChannel _streamChannel;

  bool isJoined = false, switchCamera = true, switchRender = true;
  bool _isJoinedTopic = false;
  Set<int> remoteUid = {};
  late TextEditingController _controller;
  bool _isUseFlutterTexture = false;
  bool _isUseAndroidSurfaceView = false;
  ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;

  late TextEditingController _userIdController;
  late TextEditingController _tokenController;

  late TextEditingController _rtmChannelNameController;
  late TextEditingController _topicController;
  late TextEditingController _topicMessageController;
  late TextEditingController _subscribeTopicController;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: config.channelId);

    _userIdController = TextEditingController();

    _tokenController = TextEditingController();
    _topicController = TextEditingController();
    _topicMessageController = TextEditingController();
    _subscribeTopicController = TextEditingController();

    _streamChannel = widget.streamChannel;
  }

  @override
  void dispose() {
    super.dispose();
    _dispose();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  @override
  Widget build(BuildContext context) {
    return ExampleActionsWidget(
      displayContentBuilder: (context, isLayoutHorizontal) {
        if (!_isReadyPreview) return Container();
        return Stack(
          children: [],
        );
      },
      actionsBuilder: (context, isLayoutHorizontal) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _rtmChannelNameController,
                  decoration:
                      const InputDecoration(hintText: 'Input rtm channel name'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _streamChannel.join(JoinChannelOptions(token: ''));
                  },
                  child: Text('Join rtm channel'),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _topicController,
                  decoration:
                      const InputDecoration(hintText: 'Input topic name'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _streamChannel.joinTopic(
                        topic: _topicController.text,
                        options: const JoinTopicOptions());
                  },
                  child: Text('Join topic'),
                ),
              ],
            ),
            TextField(
              controller: _subscribeTopicController,
              decoration: const InputDecoration(
                  hintText: 'Intput subscribe topic name'),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      _streamChannel.subscribeTopic(
                          topic: _subscribeTopicController.text,
                          options: TopicOptions());
                    },
                    child: Text('Subscribe topic'),
                  ),
                )
              ],
            ),
            TextField(
              controller: _topicMessageController,
              decoration:
                  const InputDecoration(hintText: 'Input topic message'),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      _streamChannel.publishTopicMessage(
                        topic: _topicController.text,
                        message: _topicMessageController.text,
                        length: _topicMessageController.text.length,
                      );
                    },
                    child: Text('Send topic message'),
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
    // if (!_isInit) return Container();
  }
}
