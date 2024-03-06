import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Video Player with PageView Demo",
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SamplePageView(),
    );
  }
}

class SamplePageView extends StatefulWidget {
  const SamplePageView({super.key});

  @override
  State<SamplePageView> createState() => _SamplePageViewState();
}

class _SamplePageViewState extends State<SamplePageView> {
  List<String> videos = [];
  List<String> videoThumbnails = [];

  @override
  void initState() {
    super.initState();

    /// generate a list of 100 random videos
    setState(() {
      for (var i = 0; i < 100; i++) {
        switch (i % 3) {
          case 0:
            videos.add(
                "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4");
            break;
          case 1:
            videos.add(
                "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4");
            break;
          case 2:
            videos.add(
                "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4");
            break;
        }
      }
    });

    /// generate a list of 100 random video thumbnails
    setState(() {
      for (var i = 0; i < 100; i++) {
        switch (i % 3) {
          case 0:
            videoThumbnails.add(
                "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ElephantsDream.jpg");
            break;
          case 1:
            videoThumbnails.add(
                "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/ForBiggerBlazes.jpg");
            break;
          case 2:
            videoThumbnails.add(
                "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg");
            break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        itemCount: 100,
        itemBuilder: (context, index) {
          return CentralVideoPlayer(
            videoUrl: videos[index],
            videoThumbnail: videoThumbnails[index],
            isMuted: false,
          );
        },
      ),
    );
  }
}

class CentralVideoPlayer extends StatefulWidget {
  const CentralVideoPlayer(
      {required this.videoUrl,
      required this.videoThumbnail,
      this.videoFile,
      this.isDiscover = false,
      this.isMuted = false,
      super.key});

  final String videoUrl;
  final String videoThumbnail;
  final File? videoFile;
  final bool isDiscover;
  final bool isMuted;

  @override
  State<CentralVideoPlayer> createState() => _CentralVideoPlayerState();
}

class _CentralVideoPlayerState extends State<CentralVideoPlayer> {
  VideoPlayerController? videoController;
  bool isVideoInitialized = false;

  initializeVideo() async {
    if (widget.isMuted) {
      /// video not in view direct view so:

      /// cache video as a file with the DefaultCacheManager for later consumption
      /// video is only cached once then file is used for all future plays
      var file = await DefaultCacheManager().getSingleFile(widget.videoUrl);

      /// ... play cached video
      videoController = VideoPlayerController.file(
        file,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
        ),
      )
        ..setLooping(true)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
          }

          videoController!.setVolume(0);

          videoController!.play();
        });
    } else {
      /// ... do something with volume

      /// cache video as a file with the DefaultCacheManager for later consumption
      /// video is only cached once then file is used for all future plays
      var file = await DefaultCacheManager().getSingleFile(widget.videoUrl);

      /// ... play cached video
      videoController = VideoPlayerController.file(
        file,
        videoPlayerOptions: VideoPlayerOptions(
          mixWithOthers: true,
        ),
      )
        ..setLooping(true)
        ..initialize().then((_) {
          if (mounted) {
            setState(() {});
          }
          if (mounted) {
            /// ... do something with volume
          }
          if (widget.isMuted) {
            videoController!.setVolume(0);
          } else {
            /// ... do something with volume
          }

          /// ... do something with volume
          videoController!.play();
        });
    }
  }

  @override
  void initState() {
    super.initState();

    initializeVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (widget.videoThumbnail.isNotEmpty)
            Positioned.fill(
              child: Image.network(
                widget.videoThumbnail,
                fit: BoxFit.cover,
              ),
            ),
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: videoController != null
                  ? SizedBox(
                      width: videoController!.value.size.width,
                      height: videoController!.value.size.height,
                      child: VideoPlayer(videoController!),
                    )
                  : widget.videoThumbnail.isNotEmpty
                      ? Image.network(
                          widget.videoThumbnail,
                          fit: BoxFit.cover,
                        )
                      : Container(),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    videoController?.dispose();
    super.dispose();
  }
}