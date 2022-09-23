import 'dart:convert';
import 'dart:typed_data';

import 'package:agora_rtc_engine/src/agora_media_base.dart';
import 'package:agora_rtc_engine/src/agora_media_player.dart';
import 'package:agora_rtc_engine/src/agora_media_player_source.dart';
import 'package:agora_rtc_engine/src/agora_rtc_engine.dart';
import 'package:agora_rtc_engine/src/agora_rtc_engine_ext.dart';
import 'package:agora_rtc_engine/src/binding/agora_media_base_event_impl.dart'
    as media_base_event_binding;
import 'package:agora_rtc_engine/src/binding/agora_media_player_event_impl.dart'
    as media_player_event_binding;
import 'package:agora_rtc_engine/src/binding/agora_media_player_impl.dart'
    as agora_media_player_impl_binding;
import 'package:agora_rtc_engine/src/binding/agora_media_player_source_event_impl.dart'
    as media_player_source_event_binding;
import 'package:agora_rtc_engine/src/impl/agora_rtc_engine_impl.dart'
    as rtc_engine_impl;
import 'package:agora_rtc_engine/src/impl/disposable_object.dart';
import 'package:agora_rtc_engine/src/impl/event_loop.dart';
import 'package:agora_rtc_engine/src/render/media_player_controller.dart';
import 'package:flutter/material.dart';

import 'api_caller.dart';

class MediaPlayerEventHandlerKey extends EventLoopEventHandlerKey {
  const MediaPlayerEventHandlerKey(Type type, this.mediaPlayerId) : super(type);

  final int mediaPlayerId;

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is MediaPlayerEventHandlerKey &&
        other.type == type &&
        other.mediaPlayerId == mediaPlayerId;
  }

  @override
  int get hashCode => hashValues(type, mediaPlayerId);
}

class MediaPlayerAudioFrameObserverWrapper
    extends media_player_event_binding.MediaPlayerAudioFrameObserverWrapper {
  const MediaPlayerAudioFrameObserverWrapper(this.mediaPlayerId,
      MediaPlayerAudioFrameObserver mediaPlayerAudioFrameObserver)
      : super(mediaPlayerAudioFrameObserver);

  final int mediaPlayerId;

  @override
  bool handleEvent(
      String eventName, String eventData, List<Uint8List> buffers) {
    final jsonMap = Map<String, dynamic>.from(jsonDecode(eventData));
    if (jsonMap.containsKey('playerId') &&
        jsonMap['playerId'] == mediaPlayerId) {
      return super.handleEvent(eventName, eventData, buffers);
    }

    return false;
  }
}

class MediaPlayerVideoFrameObserverWrapper
    extends media_player_event_binding.MediaPlayerVideoFrameObserverWrapper {
  MediaPlayerVideoFrameObserverWrapper(this.mediaPlayerId,
      MediaPlayerVideoFrameObserver mediaPlayerVideoFrameObserver)
      : super(mediaPlayerVideoFrameObserver);

  final int mediaPlayerId;

  @override
  bool handleEvent(
      String eventName, String eventData, List<Uint8List> buffers) {
    final jsonMap = Map<String, dynamic>.from(jsonDecode(eventData));
    if (jsonMap.containsKey('playerId') &&
        jsonMap['playerId'] == mediaPlayerId) {
      return super.handleEvent(eventName, eventData, buffers);
    }

    return false;
  }
}

class MediaPlayerSourceObserverWrapper
    extends media_player_source_event_binding.MediaPlayerSourceObserverWrapper {
  MediaPlayerSourceObserverWrapper(
    this.mediaPlayerId,
    MediaPlayerSourceObserver mediaPlayerSourceObserver,
  ) : super(mediaPlayerSourceObserver);

  final int mediaPlayerId;

  @override
  bool handleEvent(
      String eventName, String eventData, List<Uint8List> buffers) {
    final jsonMap = Map<String, dynamic>.from(jsonDecode(eventData));
    if (jsonMap.containsKey('playerId') &&
        jsonMap['playerId'] == mediaPlayerId) {
      return super.handleEvent(eventName, eventData, buffers);
    }

    return false;
  }
}

class AudioSpectrumObserverWrapper
    extends media_base_event_binding.AudioSpectrumObserverWrapper {
  const AudioSpectrumObserverWrapper(
      this.mediaPlayerId, AudioSpectrumObserver audioSpectrumObserver)
      : super(audioSpectrumObserver);

  final int mediaPlayerId;

  @override
  bool handleEvent(
      String eventName, String eventData, List<Uint8List> buffers) {
    final jsonMap = Map<String, dynamic>.from(jsonDecode(eventData));
    if (jsonMap.containsKey('playerId') &&
        jsonMap['playerId'] == mediaPlayerId) {
      return super.handleEvent(eventName, eventData, buffers);
    }
    return false;
  }
}

/// Implementation of [MediaPlayerController]
class MediaPlayerImpl extends agora_media_player_impl_binding.MediaPlayerImpl
    implements MediaPlayer {
  MediaPlayerImpl._(this._mediaPlayerId, this._eventLoop);

  final int _mediaPlayerId;

  final EventLoop _eventLoop;

  /// Create the [MediaPlayerImpl]
  factory MediaPlayerImpl.create(int mediaPlayerId, EventLoop eventLoop) {
    final instance = MediaPlayerImpl._(mediaPlayerId, eventLoop);

    return instance;
  }

  @protected
  @override
  Map<String, dynamic> createParams(Map<String, dynamic> param) {
    return {
      'playerId': _mediaPlayerId,
      ...param,
    };
  }

  @override
  int getMediaPlayerId() {
    return _mediaPlayerId;
  }

  @override
  void registerPlayerSourceObserver(MediaPlayerSourceObserver observer) async {
    final param = createParams({});
    await apiCaller.callIrisEventAsync(
        const IrisEventObserverKey(
            op: CallIrisEventOp.create,
            registerName: 'MediaPlayer_registerPlayerSourceObserver',
            unregisterName: 'MediaPlayer_unregisterPlayerSourceObserver'),
        jsonEncode(param));

    _eventLoop.addEventHandler(
      MediaPlayerEventHandlerKey(MediaPlayerImpl, getMediaPlayerId()),
      MediaPlayerSourceObserverWrapper(getMediaPlayerId(), observer),
    );
  }

  @override
  void unregisterPlayerSourceObserver(
      MediaPlayerSourceObserver observer) async {
    final param = createParams({});
    await apiCaller.callIrisEventAsync(
        const IrisEventObserverKey(
            op: CallIrisEventOp.dispose,
            registerName: 'MediaPlayer_registerPlayerSourceObserver',
            unregisterName: 'MediaPlayer_unregisterPlayerSourceObserver'),
        jsonEncode(param));

    _eventLoop.removeEventHandler(
      MediaPlayerEventHandlerKey(MediaPlayerImpl, getMediaPlayerId()),
      MediaPlayerSourceObserverWrapper(getMediaPlayerId(), observer),
    );
  }

  void destroy() {
    _eventLoop.removeEventHandlers(
      MediaPlayerEventHandlerKey(MediaPlayerImpl, getMediaPlayerId()),
    );
  }

  @override
  Future<void> setPlayerOptionInInt(
      {required String key, required int value}) async {
    const apiType = 'MediaPlayer_setPlayerOption';
    final param = createParams({'key': key, 'value': value});
    final callApiResult =
        await apiCaller.callIrisApi(apiType, jsonEncode(param));
    if (callApiResult.irisReturnCode < 0) {
      throw AgoraRtcException(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throw AgoraRtcException(code: result);
    }
  }

  @override
  Future<void> setPlayerOptionInString(
      {required String key, required String value}) async {
    const apiType = 'MediaPlayer_setPlayerOption2';
    final param = createParams({'key': key, 'value': value});
    final callApiResult =
        await apiCaller.callIrisApi(apiType, jsonEncode(param));
    if (callApiResult.irisReturnCode < 0) {
      throw AgoraRtcException(code: callApiResult.irisReturnCode);
    }
    final rm = callApiResult.data;
    final result = rm['result'];
    if (result < 0) {
      throw AgoraRtcException(code: result);
    }
  }

  @override
  void registerAudioFrameObserver(
      MediaPlayerAudioFrameObserver observer) async {
    final param = createParams({});
    await apiCaller.callIrisEventAsync(
        const IrisEventObserverKey(
            op: CallIrisEventOp.create,
            registerName: 'MediaPlayer_registerAudioFrameObserver',
            unregisterName: 'MediaPlayer_unregisterAudioFrameObserver'),
        jsonEncode(param));

    _eventLoop.addEventHandler(
      MediaPlayerEventHandlerKey(MediaPlayerImpl, getMediaPlayerId()),
      MediaPlayerAudioFrameObserverWrapper(getMediaPlayerId(), observer),
    );
  }

  @override
  void unregisterAudioFrameObserver(
      MediaPlayerAudioFrameObserver observer) async {
    final param = createParams({});
    await apiCaller.callIrisEventAsync(
        const IrisEventObserverKey(
            op: CallIrisEventOp.dispose,
            registerName: 'MediaPlayer_registerAudioFrameObserver',
            unregisterName: 'MediaPlayer_unregisterAudioFrameObserver'),
        jsonEncode(param));

    _eventLoop.removeEventHandler(
      MediaPlayerEventHandlerKey(MediaPlayerImpl, getMediaPlayerId()),
      MediaPlayerAudioFrameObserverWrapper(getMediaPlayerId(), observer),
    );
  }

  @override
  void registerVideoFrameObserver(
      MediaPlayerVideoFrameObserver observer) async {
    final param = createParams({});
    await apiCaller.callIrisEventAsync(
        const IrisEventObserverKey(
            op: CallIrisEventOp.create,
            registerName: 'MediaPlayer_registerVideoFrameObserver',
            unregisterName: 'MediaPlayer_unregisterVideoFrameObserver'),
        jsonEncode(param));

    _eventLoop.addEventHandler(
      MediaPlayerEventHandlerKey(MediaPlayerImpl, getMediaPlayerId()),
      MediaPlayerVideoFrameObserverWrapper(getMediaPlayerId(), observer),
    );
  }

  @override
  void unregisterVideoFrameObserver(
      MediaPlayerVideoFrameObserver observer) async {
    final param = createParams({});
    await apiCaller.callIrisEventAsync(
        const IrisEventObserverKey(
            op: CallIrisEventOp.dispose,
            registerName: 'MediaPlayer_registerVideoFrameObserver',
            unregisterName: 'MediaPlayer_unregisterVideoFrameObserver'),
        jsonEncode(param));

    _eventLoop.removeEventHandler(
      MediaPlayerEventHandlerKey(MediaPlayerImpl, getMediaPlayerId()),
      MediaPlayerVideoFrameObserverWrapper(getMediaPlayerId(), observer),
    );
  }

  @override
  void registerMediaPlayerAudioSpectrumObserver(
      {required AudioSpectrumObserver observer,
      required int intervalInMS}) async {
    final param = createParams({'intervalInMS': intervalInMS});
    await apiCaller.callIrisEventAsync(
        const IrisEventObserverKey(
            op: CallIrisEventOp.create,
            registerName:
                'MediaPlayer_registerMediaPlayerAudioSpectrumObserver',
            unregisterName:
                'MediaPlayer_unregisterMediaPlayerAudioSpectrumObserver'),
        jsonEncode(param));

    _eventLoop.addEventHandler(
      MediaPlayerEventHandlerKey(MediaPlayerImpl, getMediaPlayerId()),
      AudioSpectrumObserverWrapper(getMediaPlayerId(), observer),
    );
  }

  @override
  void unregisterMediaPlayerAudioSpectrumObserver(
      AudioSpectrumObserver observer) async {
    final param = createParams({});
    await apiCaller.callIrisEventAsync(
        const IrisEventObserverKey(
            op: CallIrisEventOp.dispose,
            registerName:
                'MediaPlayer_registerMediaPlayerAudioSpectrumObserver',
            unregisterName:
                'MediaPlayer_unregisterMediaPlayerAudioSpectrumObserver'),
        jsonEncode(param));

    _eventLoop.removeEventHandler(
      MediaPlayerEventHandlerKey(MediaPlayerImpl, getMediaPlayerId()),
      AudioSpectrumObserverWrapper(getMediaPlayerId(), observer),
    );
  }
}

class MediaPlayerCacheManagerImpl extends agora_media_player_impl_binding
    .MediaPlayerCacheManagerImpl implements AsyncDisposableObject {
  MediaPlayerCacheManagerImpl._();

  factory MediaPlayerCacheManagerImpl.create(RtcEngine rtcEngine) {
    return rtcEngine.objectPool.putIfAbsent(
        MediaPlayerCacheManagerImpl, () => MediaPlayerCacheManagerImpl._());
  }

  @override
  Future<void> disposeAsync() async {}
}
