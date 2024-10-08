import 'dart:io';
import 'dart:typed_data';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:open_file/open_file.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';

import 'full_image.dart';

class ChatFiles extends StatelessWidget {
  const ChatFiles({Key? key, required this.roomId}) : super(key: key);
  final String roomId;
  @override
  Widget build(BuildContext context) {
    String storagePath =
        '/storage/emulated/0/Android/data/my.com.tbs.carser.admin.app/files/';
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.camera_alt)),
              Tab(icon: Icon(Icons.video_collection_rounded)),
              Tab(icon: Icon(Icons.headset)),
              Tab(icon: Icon(Icons.insert_drive_file)),
            ],
          ),
          title: const Text('Media and Files'),
          backgroundColor: Colors.blueAccent,
        ),
        body: TabBarView(
          children: [
            GalleryItems(
                type: 'Images', roomId: roomId, storagePath: storagePath),
            GalleryItems(
                type: 'Videos', roomId: roomId, storagePath: storagePath),
            MyAudioList(roomId: roomId, storagePath: storagePath),
            MyFilesList(roomId: roomId, storagePath: storagePath),
          ],
        ),
      ),
    );
  }
}

class GalleryItems extends StatefulWidget {
  final String type;
  final String roomId;
  final String storagePath;
  const GalleryItems(
      {Key? key,
      required this.type,
      required this.roomId,
      required this.storagePath})
      : super(key: key);

  @override
  State<GalleryItems> createState() => _GalleryItemsState();
}

class _GalleryItemsState extends State<GalleryItems> {
  bool isFolderExist = false;
  @override
  void initState() {
    super.initState();
    String path = '${widget.storagePath}${widget.roomId}/${widget.type}';
    isDirectoryExists(path);
  }

  Future<void> isDirectoryExists(String dirPath) async {
    bool exists = await Directory(dirPath).exists();
    if (exists) {
      setState(() {
        isFolderExist = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isFolderExist) {
      var imageList =
          Directory('${widget.storagePath}${widget.roomId}/${widget.type}')
              .listSync()
              .map((item) => item.path)
              .toList(growable: false);
      if (imageList.isNotEmpty) {
        return GridView.builder(
          itemCount: imageList.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: widget.type == 'Images' ? 2 : 2,
            // crossAxisCount: _getCrossAxisCount(context),
            crossAxisSpacing: 1.0,
            // childAspectRatio: 16 / 9,
            mainAxisSpacing: 1.0,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullScreenImagePage(
                      imageUrl: imageList[index],
                      heroTag: imageList[index].split('/').last,
                    ),
                  ),
                );
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                child: widget.type == 'Images'
                    ? Center(
                        child: Hero(
                          tag: UniqueKey(),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16.0),
                            child: Image.file(
                              File(imageList[index]),
                              fit: BoxFit.cover,
                              height: 300,
                              width: 250,
                            ),
                          ),
                        ),
                      )
                    : VideoItems(filePath: imageList[index]),
              ),
            );
          },
        );
      } else {
        return Center(
            child: Text('No ${widget.type} Found.',
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold)));
      }
    } else {
      return Center(
          child: Text('No ${widget.type} Found.',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
    }
  }
}

class VideoItems extends StatefulWidget {
  final String filePath;
  const VideoItems({Key? key, required this.filePath}) : super(key: key);

  @override
  State<VideoItems> createState() => _VideoItemsState();
}

class _VideoItemsState extends State<VideoItems> {
  late FlickManager flickManager;

  @override
  void initState() {
    super.initState();
    final File file = File(widget.filePath);
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.file(file),
    );
  }

  @override
  void dispose() {
    flickManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.filePath != ''
        ? VisibilityDetector(
            key: ObjectKey(flickManager),
            onVisibilityChanged: (visibility) {
              if (visibility.visibleFraction == 0 && mounted) {
                flickManager.flickControlManager?.autoPause();
              } else if (visibility.visibleFraction == 1) {
                flickManager.flickControlManager?.autoPause();
              }
            },
            child: FlickVideoPlayer(
              flickManager: flickManager,
              flickVideoWithControls: const FlickVideoWithControls(
                videoFit: BoxFit.fitHeight,
                closedCaptionTextStyle: TextStyle(fontSize: 8),
                controls: FlickPortraitControls(),
              ),
              flickVideoWithControlsFullscreen: const FlickVideoWithControls(
                controls: FlickLandscapeControls(),
              ),
            ))
        : const Center(child: Text('No Video From Server'));
  }
}

class MyAudioList extends StatefulWidget {
  const MyAudioList({Key? key, required this.roomId, required this.storagePath})
      : super(key: key);
  final String roomId;
  final String storagePath;
  @override
  State<MyAudioList> createState() => _MyAudioListState();
}

class _MyAudioListState extends State<MyAudioList> {
  bool isFolderExist = false;
  @override
  void initState() {
    super.initState();
    String path = '${widget.storagePath}${widget.roomId}/Audios';
    isDirectoryExists(path);
  }

  Future<void> isDirectoryExists(String dirPath) async {
    bool exists = await Directory(dirPath).exists();
    if (exists) {
      setState(() {
        isFolderExist = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String path = '${widget.storagePath}${widget.roomId}/Audios';
    if (isFolderExist) {
      var imageList = Directory(path)
          .listSync()
          .map((item) => item.path)
          .toList(growable: false);
      if (imageList.isNotEmpty) {
        return ListView.builder(
          itemCount: imageList.length,
          itemBuilder: (context, index) {
            return AudioItems(
              filePath: imageList[index],
            );
          },
        );
      } else {
        return const Center(
            child: Text('No Audio Files Found.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
      }
    } else {
      return const Center(
          child: Text('No Audio Files Found.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
    }
  }
}

class AudioItems extends StatefulWidget {
  final String filePath;
  const AudioItems({Key? key, required this.filePath}) : super(key: key);

  @override
  State<AudioItems> createState() => _AudioItemsState();
}

class _AudioItemsState extends State<AudioItems> {
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  bool _mPlayerIsInited = false;
  @override
  void initState() {
    _mPlayer!.openPlayer().then((value) {
      if (mounted) {
        setState(() {
          _mPlayerIsInited = true;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Text(widget.filePath.split('/').last),
      leading: const Icon(Icons.audiotrack),
      trailing: Icon(
        _mPlayer!.isPlaying ? Icons.pause : Icons.play_arrow,
        color: Colors.redAccent,
      ),
      onTap: () {
        if (!_mPlayerIsInited) {
          return;
        }
        if (_mPlayer!.isStopped) {
          play(widget.filePath);
        } else {
          stopPlayer();
        }
      },
    ));
  }

  Future<void> play(String audioFilPath) async {
    assert(_mPlayerIsInited && _mPlayer!.isStopped);
    File file = File(audioFilPath);
    Uint8List uint8list = await file.readAsBytes();
    _mPlayer!
        .startPlayer(
            // fromURI: audioFilPath,
            fromDataBuffer: uint8list,
            whenFinished: () {
              if (mounted) {
                setState(() {});
              }
            })
        .then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      if (mounted) {
        setState(() {});
      }
    });
  }
}

class FileItems extends StatelessWidget {
  final String filePath;
  const FileItems({Key? key, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Text(
        filePath.split('/').last,
        overflow: TextOverflow.ellipsis,
      ),
      leading: const Icon(Icons.file_copy),
      trailing: const Icon(
        Icons.download,
        color: Colors.redAccent,
      ),
      onTap: () {
        OpenFile.open(filePath);
      },
    ));
  }
}

class MyFilesList extends StatefulWidget {
  const MyFilesList({Key? key, required this.roomId, required this.storagePath})
      : super(key: key);
  final String roomId;
  final String storagePath;
  @override
  State<MyFilesList> createState() => _MyFilesListState();
}

class _MyFilesListState extends State<MyFilesList> {
  bool isFolderExist = false;

  @override
  void initState() {
    super.initState();
    String path = '${widget.storagePath}${widget.roomId}/Files';
    isDirectoryExists(path);
  }

  Future<void> isDirectoryExists(String dirPath) async {
    bool exists = await Directory(dirPath).exists();
    if (exists) {
      setState(() {
        isFolderExist = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String path = '${widget.storagePath}${widget.roomId}/Files';

    if (isFolderExist) {
      var imageList = Directory(path)
          .listSync()
          .map((item) => item.path)
          .toList(growable: false);
      if (imageList.isNotEmpty) {
        return ListView.builder(
          itemCount: imageList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return FileItems(
              filePath: imageList[index],
            );
          },
        );
      } else {
        return const Center(
            child: Text('No Files Found.',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
      }
    } else {
      return const Center(
          child: Text('No Files Found.',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)));
    }
  }
}
