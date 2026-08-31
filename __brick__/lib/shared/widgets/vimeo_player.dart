import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class VimeoPlayer extends StatefulWidget {
  const VimeoPlayer({
    Key? key,
    required this.videoId,
    this.initialTimeOffset,
    this.onProgress,
    this.onPause,
    this.onPlay,
    this.onFinished,
    this.onChangeOrientation,
  }) : super(key: key);

  final String videoId;
  final Duration? initialTimeOffset;
  final void Function(Duration timePoint)? onProgress;
  final void Function(bool value)? onPause;
  final void Function(bool isFullScreen)? onChangeOrientation;
  final void Function(bool value)? onPlay;
  final VoidCallback? onFinished;

  @override
  State<VimeoPlayer> createState() => _VimeoPlayerState();
}

class _VimeoPlayerState extends State<VimeoPlayer> {
  final _controller = WebViewController();
  bool _isPlayerReady = false;
  Duration? _pendingSeek;

  @override
  void initState() {
    _pendingSeek = widget.initialTimeOffset;

    _controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            _initializePlayer();
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'VimeoPlayer',
        onMessageReceived: handleJavaScriptMessage,
      )
      ..loadRequest(_videoPage(widget.videoId));

    super.initState();
  }

  Future<void> _initializePlayer() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (_pendingSeek != null) {
      await seekTo(_pendingSeek!);
    }
  }

  Future<void> seekTo(Duration timestamp) async {
    final seconds = timestamp.inSeconds;
    try {
      await _controller.runJavaScript('''
        player.getCurrentTime().then(function(currentTime) {
          if (Math.abs(currentTime - $seconds) > 0.5) {
            return player.setCurrentTime($seconds);
          }
        }).then(function() {
          VimeoPlayer.postMessage(JSON.stringify({
            type: 'seekComplete',
            time: $seconds
          }));
        }).catch(function(error) {
          VimeoPlayer.postMessage(JSON.stringify({
            type: 'seekError',
            error: error.toString()
          }));
        });
      ''');
    } catch (e) {
      print('Error during seek: $e');
    }
  }

  Future<void> handleJavaScriptMessage(JavaScriptMessage message) async {
    try {
      if (message.message != "undefined") {
        final data = jsonDecode(message.message);

        switch (data['type']) {
          case 'ready':
            setState(() {
              _isPlayerReady = true;
            });
            if (_pendingSeek != null) {
              await seekTo(_pendingSeek!);
              _pendingSeek = null;
            }
            break;
          case 'seekComplete':
            break;
          case 'seekError':
            break;
          case 'progress':
            if (widget.onProgress != null) {
              widget.onProgress!(Duration(milliseconds: data['time']));
            }
            break;
          case 'pause':
            if (widget.onPause != null) {
              widget.onPause!(data['paused']);
            }
            break;
          case 'play':
            if (widget.onPlay != null) {
              widget.onPlay!(data['playing']);
            }
            break;
          case 'fullscreen':
            if (widget.onChangeOrientation != null) {
              widget.onChangeOrientation!(data['fullscreen']);
            }
            break;
          case 'finished':
            if (widget.onFinished != null) {
              widget.onFinished!();
            }
            break;
        }
      }
    } catch (e) {
      print('Error handling message: $e');
    }
  }

  Uri _videoPage(String videoId) {
    final html =
        '''
<!DOCTYPE html>
<html>
   <head>
      <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
      <style>
         html, body {
           margin: 0;
           padding: 0;
           width: 100%;
           height: 100%;
           overflow: hidden;
           background-color: white;
         }
         #player-wrapper {
           position: relative;
           padding-bottom: 56.25%;
           height: 0;
           overflow: hidden;
           max-width: 100%;
         }
         #player-wrapper iframe {
           position: absolute;
           top: 0;
           left: 0;
           width: 100%;
           height: 100%;
           border: 0;
         }
      </style>
   </head>
   <body>
      <div id="player-wrapper">
        <iframe 
          id="vimeoPlayer"
          src="https://player.vimeo.com/video/$videoId?loop=0&autoplay=0&controls=1"
          allow="autoplay; fullscreen"
          allowfullscreen
        ></iframe>
      </div>
      <script src="https://player.vimeo.com/api/player.js"></script>
      <script>
         let player;
         
         function initializePlayer() {
           const iframe = document.querySelector('iframe');
           player = new Vimeo.Player(iframe);
           
           player.ready().then(function() {
             VimeoPlayer.postMessage(JSON.stringify({type: 'ready'}));
             setupEventListeners();
           }).catch(function(error) {
             console.error('Player ready error:', error);
           });
         }
         
         function setupEventListeners() {
           player.on('play', function() {
             VimeoPlayer.postMessage(JSON.stringify({type: 'play', playing: true}));
           });
           
           player.on('pause', function() {
             VimeoPlayer.postMessage(JSON.stringify({type: 'pause', paused: true}));
           });
           
           player.on('ended', function() {
             VimeoPlayer.postMessage(JSON.stringify({type: 'finished'}));
           });
           
           player.on('fullscreenchange', function(event) {
             VimeoPlayer.postMessage(JSON.stringify({
               type: 'fullscreen', 
               fullscreen: event.fullscreen
             }));
           });
           
           player.on('timeupdate', function(data) {
             VimeoPlayer.postMessage(JSON.stringify({
               type: 'progress', 
               time: Math.round(data.seconds * 1000)
             }));
           });
         }
         
         if (document.readyState === 'complete' || document.readyState === 'interactive') {
           initializePlayer();
         } else {
           document.addEventListener('DOMContentLoaded', initializePlayer);
         }
      </script>
   </body>
</html>
    ''';
    final String contentBase64 = base64Encode(
      const Utf8Encoder().convert(html),
    );
    return Uri.parse('data:text/html;base64,$contentBase64');
  }

  @override
  void didUpdateWidget(VimeoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTimeOffset != oldWidget.initialTimeOffset &&
        widget.initialTimeOffset != null) {
      seekTo(widget.initialTimeOffset!);
    }
  }

  @override
  void dispose() {
    _controller.clearCache();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: _controller);
  }
}
