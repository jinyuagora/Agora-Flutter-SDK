/// GENERATED BY testcase_gen. DO NOT MODIFY BY HAND.

// ignore_for_file: deprecated_member_use,constant_identifier_names

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/foundation.dart';
import 'package:integration_test_app/main.dart' as app;

void localSpatialAudioEngineSmokeTestCases() {
  testWidgets(
    'initialize',
    (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      String engineAppId = const String.fromEnvironment('TEST_APP_ID',
          defaultValue: '<YOUR_APP_ID>');

      RtcEngine rtcEngine = createAgoraRtcEngine();
      await rtcEngine.initialize(RtcEngineContext(
        appId: engineAppId,
        areaCode: AreaCode.areaCodeGlob.value(),
      ));

      final localSpatialAudioEngine = rtcEngine.getLocalSpatialAudioEngine();

      try {
        await localSpatialAudioEngine.initialize();
      } catch (e) {
        if (e is! AgoraRtcException) {
          debugPrint('[initialize] error: ${e.toString()}');
        }
        expect(e is AgoraRtcException, true);
        debugPrint('[initialize] errorcode: ${(e as AgoraRtcException).code}');
      }

      await localSpatialAudioEngine.release();
      await rtcEngine.release();
    },
//  skip: !(),
  );

  testWidgets(
    'updateRemotePosition',
    (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      String engineAppId = const String.fromEnvironment('TEST_APP_ID',
          defaultValue: '<YOUR_APP_ID>');

      RtcEngine rtcEngine = createAgoraRtcEngine();
      await rtcEngine.initialize(RtcEngineContext(
        appId: engineAppId,
        areaCode: AreaCode.areaCodeGlob.value(),
      ));

      final localSpatialAudioEngine = rtcEngine.getLocalSpatialAudioEngine();

      try {
        const int uid = 10;
        const List<double> posInfoPosition = [];
        const List<double> posInfoForward = [];
        const RemoteVoicePositionInfo posInfo = RemoteVoicePositionInfo(
          position: posInfoPosition,
          forward: posInfoForward,
        );
        await localSpatialAudioEngine.updateRemotePosition(
          uid: uid,
          posInfo: posInfo,
        );
      } catch (e) {
        if (e is! AgoraRtcException) {
          debugPrint('[updateRemotePosition] error: ${e.toString()}');
        }
        expect(e is AgoraRtcException, true);
        debugPrint(
            '[updateRemotePosition] errorcode: ${(e as AgoraRtcException).code}');
      }

      await localSpatialAudioEngine.release();
      await rtcEngine.release();
    },
//  skip: !(),
  );

  testWidgets(
    'updateRemotePositionEx',
    (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      String engineAppId = const String.fromEnvironment('TEST_APP_ID',
          defaultValue: '<YOUR_APP_ID>');

      RtcEngine rtcEngine = createAgoraRtcEngine();
      await rtcEngine.initialize(RtcEngineContext(
        appId: engineAppId,
        areaCode: AreaCode.areaCodeGlob.value(),
      ));

      final localSpatialAudioEngine = rtcEngine.getLocalSpatialAudioEngine();

      try {
        const int uid = 10;
        const List<double> posInfoPosition = [];
        const List<double> posInfoForward = [];
        const RemoteVoicePositionInfo posInfo = RemoteVoicePositionInfo(
          position: posInfoPosition,
          forward: posInfoForward,
        );
        const String connectionChannelId = "hello";
        const int connectionLocalUid = 10;
        const RtcConnection connection = RtcConnection(
          channelId: connectionChannelId,
          localUid: connectionLocalUid,
        );
        await localSpatialAudioEngine.updateRemotePositionEx(
          uid: uid,
          posInfo: posInfo,
          connection: connection,
        );
      } catch (e) {
        if (e is! AgoraRtcException) {
          debugPrint('[updateRemotePositionEx] error: ${e.toString()}');
        }
        expect(e is AgoraRtcException, true);
        debugPrint(
            '[updateRemotePositionEx] errorcode: ${(e as AgoraRtcException).code}');
      }

      await localSpatialAudioEngine.release();
      await rtcEngine.release();
    },
//  skip: !(),
  );

  testWidgets(
    'removeRemotePosition',
    (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      String engineAppId = const String.fromEnvironment('TEST_APP_ID',
          defaultValue: '<YOUR_APP_ID>');

      RtcEngine rtcEngine = createAgoraRtcEngine();
      await rtcEngine.initialize(RtcEngineContext(
        appId: engineAppId,
        areaCode: AreaCode.areaCodeGlob.value(),
      ));

      final localSpatialAudioEngine = rtcEngine.getLocalSpatialAudioEngine();

      try {
        const int uid = 10;
        await localSpatialAudioEngine.removeRemotePosition(
          uid,
        );
      } catch (e) {
        if (e is! AgoraRtcException) {
          debugPrint('[removeRemotePosition] error: ${e.toString()}');
        }
        expect(e is AgoraRtcException, true);
        debugPrint(
            '[removeRemotePosition] errorcode: ${(e as AgoraRtcException).code}');
      }

      await localSpatialAudioEngine.release();
      await rtcEngine.release();
    },
//  skip: !(),
  );

  testWidgets(
    'removeRemotePositionEx',
    (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      String engineAppId = const String.fromEnvironment('TEST_APP_ID',
          defaultValue: '<YOUR_APP_ID>');

      RtcEngine rtcEngine = createAgoraRtcEngine();
      await rtcEngine.initialize(RtcEngineContext(
        appId: engineAppId,
        areaCode: AreaCode.areaCodeGlob.value(),
      ));

      final localSpatialAudioEngine = rtcEngine.getLocalSpatialAudioEngine();

      try {
        const int uid = 10;
        const String connectionChannelId = "hello";
        const int connectionLocalUid = 10;
        const RtcConnection connection = RtcConnection(
          channelId: connectionChannelId,
          localUid: connectionLocalUid,
        );
        await localSpatialAudioEngine.removeRemotePositionEx(
          uid: uid,
          connection: connection,
        );
      } catch (e) {
        if (e is! AgoraRtcException) {
          debugPrint('[removeRemotePositionEx] error: ${e.toString()}');
        }
        expect(e is AgoraRtcException, true);
        debugPrint(
            '[removeRemotePositionEx] errorcode: ${(e as AgoraRtcException).code}');
      }

      await localSpatialAudioEngine.release();
      await rtcEngine.release();
    },
//  skip: !(),
  );

  testWidgets(
    'clearRemotePositions',
    (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      String engineAppId = const String.fromEnvironment('TEST_APP_ID',
          defaultValue: '<YOUR_APP_ID>');

      RtcEngine rtcEngine = createAgoraRtcEngine();
      await rtcEngine.initialize(RtcEngineContext(
        appId: engineAppId,
        areaCode: AreaCode.areaCodeGlob.value(),
      ));

      final localSpatialAudioEngine = rtcEngine.getLocalSpatialAudioEngine();

      try {
        await localSpatialAudioEngine.clearRemotePositions();
      } catch (e) {
        if (e is! AgoraRtcException) {
          debugPrint('[clearRemotePositions] error: ${e.toString()}');
        }
        expect(e is AgoraRtcException, true);
        debugPrint(
            '[clearRemotePositions] errorcode: ${(e as AgoraRtcException).code}');
      }

      await localSpatialAudioEngine.release();
      await rtcEngine.release();
    },
//  skip: !(),
  );

  testWidgets(
    'clearRemotePositionsEx',
    (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      String engineAppId = const String.fromEnvironment('TEST_APP_ID',
          defaultValue: '<YOUR_APP_ID>');

      RtcEngine rtcEngine = createAgoraRtcEngine();
      await rtcEngine.initialize(RtcEngineContext(
        appId: engineAppId,
        areaCode: AreaCode.areaCodeGlob.value(),
      ));

      final localSpatialAudioEngine = rtcEngine.getLocalSpatialAudioEngine();

      try {
        const String connectionChannelId = "hello";
        const int connectionLocalUid = 10;
        const RtcConnection connection = RtcConnection(
          channelId: connectionChannelId,
          localUid: connectionLocalUid,
        );
        await localSpatialAudioEngine.clearRemotePositionsEx(
          connection,
        );
      } catch (e) {
        if (e is! AgoraRtcException) {
          debugPrint('[clearRemotePositionsEx] error: ${e.toString()}');
        }
        expect(e is AgoraRtcException, true);
        debugPrint(
            '[clearRemotePositionsEx] errorcode: ${(e as AgoraRtcException).code}');
      }

      await localSpatialAudioEngine.release();
      await rtcEngine.release();
    },
//  skip: !(),
  );
}

