import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtc_engine_example/config/agora.config.dart' as config;
import 'package:agora_rtc_engine_example/components/example_actions_widget.dart';
import 'package:agora_rtc_engine_example/components/log_sink.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StreamChannelInfo {
  StreamChannelInfo(
    this.channelName,
    this.streamChannel,
    this.joined,
    this.joinedTopic,
    this.subscribeTopic,
    this.userList,
  );

  final String channelName;
  final StreamChannel streamChannel;
  final bool joined;
  final List<String> joinedTopic;
  final List<String> subscribeTopic;
  final List<String> userList;

  StreamChannelInfo copyWith({
    String? channelName,
    StreamChannel? streamChannel,
    bool? joined,
    List<String>? joinedTopic,
    List<String>? subscribeTopic,
    List<String>? userList,
  }) {
    return StreamChannelInfo(
      channelName ?? this.channelName,
      streamChannel ?? this.streamChannel,
      joined ?? this.joined,
      joinedTopic ?? this.joinedTopic,
      subscribeTopic ?? this.subscribeTopic,
      userList ?? this.userList,
    );
  }
}

class StreamChannelInfoMap
    extends StateNotifier<Map<String, StreamChannelInfo>> {
  StreamChannelInfoMap() : super(<String, StreamChannelInfo>{});

  StreamChannelInfo getStreamChannelInfo(String channelName) {
    return state[channelName]!;
  }

  void put(String channelName, StreamChannel streamChannel) {
    state[channelName] =
        StreamChannelInfo(channelName, streamChannel, false, [], [], []);
  }

  void remove(String channelName) {
    state.remove(channelName);
  }

  void updateStreamChannelInfo(
    String channelName, {
    StreamChannel? streamChannel,
    bool? joined,
    List<String>? joinedTopic,
    List<String>? subscribeTopic,
    List<String>? userList,
  }) {
    final pre = state[channelName]!;
    state[channelName] = pre.copyWith(
      joined: joined,
      joinedTopic: joinedTopic,
      subscribeTopic: subscribeTopic,
      userList: userList,
    );
  }
}

class RtmChatModel {
  final streamChannelInfoListProvider = StateNotifierProvider<
      StreamChannelInfoMap, Map<String, StreamChannelInfo>>((ref) {
    return StreamChannelInfoMap();
  });

  final isRtmClientInit = StateProvider<bool>((_) => false);
  void setRtmClientInit(bool isInit) {
    isRtmClientInit.overrideWith((ref) => isInit);
  }
}

/// RtmChat Example
class RtmChatConsumerWidget extends ConsumerStatefulWidget {
  /// Construct the [RtmChat]
  const RtmChatConsumerWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _RtmChatConsumerWidgetState();
}

class _RtmChatConsumerWidgetState extends ConsumerState<RtmChatConsumerWidget> {
  late final RtcEngine _engine;
  late final RtmClient _rtmClient;

  bool _isRtmClientInit = false;

  bool _isReadyPreview = false;

  bool isJoined = false, switchCamera = true, switchRender = true;
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
  late TextEditingController _subtopicController;

  Map<String, StreamChannel> _streamChannel = {};

  late final RtmChatModel _rtmChatModel;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: config.channelId);

    _userIdController = TextEditingController();

    _tokenController = TextEditingController();
    _topicController = TextEditingController();
    _topicMessageController = TextEditingController();
    _subtopicController = TextEditingController();

    _init();

    _rtmChatModel = RtmChatModel();
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

  Future<void> _init() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(
      appId: config.appId,
    ));
    await _engine.setParameters('{"rtc.vos_list":["114.236.138.120:4052"]}');

    _rtmClient = createAgoraRtmClient();

    // _engine.registerEventHandler(RtcEngineEventHandler(
    //   onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
    //     logSink.log(
    //         '[onJoinChannelSuccess] connection: ${connection.toJson()} elapsed: $elapsed');
    //     setState(() {
    //       isJoined = true;
    //     });
    //   },
    //   onUserJoined: (RtcConnection connection, int rUid, int elapsed) {
    //     logSink.log(
    //         '[onUserJoined] connection: ${connection.toJson()} remoteUid: $rUid elapsed: $elapsed');
    //     setState(() {
    //       remoteUid.add(rUid);
    //     });
    //   },
    //   onUserOffline:
    //       (RtcConnection connection, int rUid, UserOfflineReasonType reason) {
    //     logSink.log(
    //         '[onUserOffline] connection: ${connection.toJson()}  rUid: $rUid reason: $reason');
    //     setState(() {
    //       remoteUid.removeWhere((element) => element == rUid);
    //     });
    //   },
    //   onLeaveChannel: (RtcConnection connection, RtcStats stats) {
    //     logSink.log(
    //         '[onLeaveChannel] connection: ${connection.toJson()} stats: ${stats.toJson()}');
    //     setState(() {
    //       isJoined = false;
    //       remoteUid.clear();
    //     });
    //   },
    // ));

    await _engine.enableVideo();

    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 0,
      ),
    );

    await _engine.startPreview();

    setState(() {
      _isReadyPreview = true;
    });
  }

  Future<void> _initRtmClient() async {
    await _rtmClient.initialize(RtmConfig(
      appId: config.rtmAppId,
      userId: _userIdController.text,
      eventHandler: RtmEventHandler(
        onMessageEvent: (MessageEvent event) {
          logSink.log('[onMessageEvent] event: ${event.toJson()}');
        },
        onPresenceEvent: (PresenceEvent event) {
          logSink.log('[onPresenceEvent] event: ${event.toJson()}');
        },
        onJoinResult: (String channelName, String userId,
            StreamChannelErrorCode errorCode) {
          logSink.log(
              '[onJoinResult] channelName: $channelName, userId: $userId, errorCode: $errorCode');
        },
        onLeaveResult: (String channelName, String userId,
            StreamChannelErrorCode errorCode) {
          logSink.log(
              '[onLeaveResult] channelName: $channelName, userId: $userId, errorCode: $errorCode');

          ref
              .read(_rtmChatModel.streamChannelInfoListProvider.notifier)
              .remove(channelName);
        },
        onJoinTopicResult: (String channelName, String userId, String topic,
            String meta, StreamChannelErrorCode errorCode) {
          logSink.log(
              '[onJoinTopicResult] channelName: $channelName, userId: $userId, topic: $topic, meta: $meta, errorCode: $errorCode');

          final pre = ref
              .read(_rtmChatModel.streamChannelInfoListProvider.notifier)
              .getStreamChannelInfo(channelName);
          final joinedTopic = [...pre.joinedTopic, topic];
          ref
              .read(_rtmChatModel.streamChannelInfoListProvider.notifier)
              .updateStreamChannelInfo(channelName, joinedTopic: joinedTopic);
        },
        onLeaveTopicResult: (String channelName, String userId, String topic,
            String meta, StreamChannelErrorCode errorCode) {
          logSink.log(
              '[onTopicSubscribed] channelName: $channelName, userId: $userId, topic: $topic, meta: $meta, errorCode: $errorCode');

          final pre = ref
              .read(_rtmChatModel.streamChannelInfoListProvider.notifier)
              .getStreamChannelInfo(channelName);
          final joinedTopic = pre.joinedTopic;
          joinedTopic.removeWhere((element) => element == topic);

          ref
              .read(_rtmChatModel.streamChannelInfoListProvider.notifier)
              .updateStreamChannelInfo(channelName, joinedTopic: joinedTopic);
        },
        onTopicSubscribed: (String channelName,
            String userId,
            String topic,
            UserList succeedUsers,
            UserList failedUsers,
            StreamChannelErrorCode errorCode) {
          logSink.log(
              '[onTopicSubscribed] channelName: $channelName, userId: $userId, topic: $topic, succeedUsers: ${succeedUsers.toJson()}, failedUsers: ${failedUsers.toJson()}, errorCode: $errorCode');

          final pre = ref
              .read(_rtmChatModel.streamChannelInfoListProvider.notifier)
              .getStreamChannelInfo(channelName);
          final subscribeTopic = [...pre.subscribeTopic, topic];

          ref
              .read(_rtmChatModel.streamChannelInfoListProvider.notifier)
              .updateStreamChannelInfo(channelName,
                  subscribeTopic: subscribeTopic);
        },
        onTopicUnsubscribed: (String channelName,
            String userId,
            String topic,
            UserList succeedUsers,
            UserList failedUsers,
            StreamChannelErrorCode errorCode) {
          logSink.log(
              '[onTopicUnsubscribed] channelName: $channelName, userId: $userId, topic: $topic, succeedUsers: ${succeedUsers.toJson()}, failedUsers: ${failedUsers.toJson()}, errorCode: $errorCode');

          final pre = ref
              .read(_rtmChatModel.streamChannelInfoListProvider.notifier)
              .getStreamChannelInfo(channelName);
          final subscribeTopic = pre.subscribeTopic;
          subscribeTopic.removeWhere((element) => element == topic);

          ref
              .read(_rtmChatModel.streamChannelInfoListProvider.notifier)
              .updateStreamChannelInfo(channelName,
                  subscribeTopic: subscribeTopic);
        },
        onConnectionStateChange: (String channelName, RtmConnectionState state,
            RtmConnectionChangeReason reason) {
          logSink.log(
              '[onConnectionStateChange] channelName: $channelName, state: $state, reason: $reason');
        },
      ),
    ));

    _rtmChatModel.setRtmClientInit(true);
  }

  @override
  Widget build(BuildContext context) {
    return ExampleActionsWidget(
      displayContentBuilder: (context, isLayoutHorizontal) {
        if (!_isReadyPreview) return Container();

        return Consumer(
          builder: (context, ref, child) {
            final streamChannels =
                ref.watch(_rtmChatModel.streamChannelInfoListProvider);

            return ListView.builder(
              itemBuilder: (context, index) {
                final streamChannel = streamChannels.values.elementAt(index);
                return SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(streamChannel.channelName),
                      IconButton(
                        onPressed: () async {
                          await streamChannel.streamChannel.leave();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
      actionsBuilder: (context, isLayoutHorizontal) {
        return Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _tokenController,
                decoration: const InputDecoration(hintText: 'Input rtm Token'),
              ),
              TextField(
                controller: _userIdController,
                decoration: const InputDecoration(hintText: 'Input user id'),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed:
                          ref.read(_rtmChatModel.isRtmClientInit.notifier).state
                              ? null
                              : () {
                                  _initRtmClient();
                                },
                      child: Text('Initialize'),
                    ),
                  )
                ],
              ),
              TextField(
                controller: _rtmChannelNameController,
                decoration:
                    const InputDecoration(hintText: 'Input rtm channel name'),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () async {
                        final channelName = _rtmChannelNameController.text;
                        final streamChannel =
                            await _rtmClient.createStreamChannel(channelName);

                        ref
                            .read(_rtmChatModel
                                .streamChannelInfoListProvider.notifier)
                            .put(channelName, streamChannel);
                      },
                      child: Text('Create StreamChannel'),
                    ),
                  )
                ],
              ),
            ],
          );
        });
      },
    );
    // if (!_isInit) return Container();
  }
}

class StreamChannelPage extends StatefulWidget {
  /// Construct the [StreamChannelPage]
  const StreamChannelPage(
      {Key? key,
      required this.channelName,
      required this.rtmChatModel,
      required this.token})
      : super(key: key);

  final String channelName;

  final RtmChatModel rtmChatModel;

  final String token;

  @override
  State<StatefulWidget> createState() => _StreamChannelPageState();
}

class _StreamChannelPageState extends State<StreamChannelPage> {
  late final RtcEngine _engine;
  bool _isReadyPreview = false;

  late final String _channelName;
  late final RtmChatModel _rtmChatModel;
  late final String _token;

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

    _channelName = widget.channelName;
    _rtmChatModel = widget.rtmChatModel;
    _token = widget.token;
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
        return Consumer(
          builder: (context, ref, child) {
            final streamChannelInfo = ref
                .read(_rtmChatModel.streamChannelInfoListProvider.notifier)
                .getStreamChannelInfo(_channelName);

            final streamChannel = streamChannelInfo.streamChannel;

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
                      decoration: const InputDecoration(
                          hintText: 'Input rtm channel name'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await streamChannel
                            .join(JoinChannelOptions(token: _token));
                        ref
                            .read(_rtmChatModel
                                .streamChannelInfoListProvider.notifier)
                            .updateStreamChannelInfo(_channelName,
                                joined: true);
                      },
                      child: Text(
                          '${streamChannelInfo.joined ? 'Join' : 'Leave'} rtm channel'),
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
                        streamChannel.joinTopic(
                            topic: _topicController.text,
                            options: const JoinTopicOptions());
                      },
                      child: Text('Join topic'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        streamChannel.leaveTopic(_topicController.text);
                      },
                      child: Text('Leave topic'),
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
                          streamChannel.subscribeTopic(
                              topic: _subscribeTopicController.text,
                              options: TopicOptions());
                        },
                        child: Text('Subscribe topic'),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          streamChannel.unsubscribeTopic(
                              topic: _subscribeTopicController.text,
                              options: TopicOptions());
                        },
                        child: Text('unsubscribe topic'),
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
                          streamChannel.publishTopicMessage(
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
      },
    );
    // if (!_isInit) return Container();
  }
}
