import 'package:animate_do/animate_do.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:music_player/src/helpers/helpers.dart';
import 'package:music_player/src/models/audioplayer_model.dart';
import 'package:music_player/src/widgets/custom_appbar.dart';
import 'package:provider/provider.dart';

class MusicPlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(),
          Column(
            children: <Widget>[
              CustomAppbar(),
              DurationDisk(),
              PlayTitle(),
              Expanded(child: Lyrics()),
            ],
          ),
        ],
      ),
    );
  }
}

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: screenSize.height * 0.73,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60)),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.center,
              colors: [
                Color(0xff33333E),
                Color(0xff201E28),
              ])),
    );
  }
}

class Lyrics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final lyrics = getLyrics();

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        margin: EdgeInsets.only(top: 35),
        child: ListWheelScrollView(
            physics: BouncingScrollPhysics(),
            itemExtent: 42,
            diameterRatio: 1.5,
            children: lyrics
                .map((linea) => Text(linea,
                    style: TextStyle(
                        fontSize: 18, color: Colors.white.withOpacity(0.6))))
                .toList()));
  }
}

class PlayTitle extends StatefulWidget {
  @override
  _PlayTitleState createState() => _PlayTitleState();
}

class _PlayTitleState extends State<PlayTitle>
    with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool firstTime = true;
  AnimationController playAnimation;

  final assetAudioPlayer = new AssetsAudioPlayer();

  @override
  void initState() {
    playAnimation =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    this.playAnimation.dispose();
    super.dispose();
  }

  void open() {
    final audioPlayerModel =
        Provider.of<AudioPlayerModel>(context, listen: false);

    assetAudioPlayer
        .open(Audio('assets/Queen - Radio Ga Ga (Official Video).mp3'));

    assetAudioPlayer.currentPosition.listen((duration) {
      audioPlayerModel.current = duration;
    });

    assetAudioPlayer.current.listen((playingAudio) {
      audioPlayerModel.songDuration = playingAudio.audio.duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 15, left: 30),
      margin: EdgeInsets.only(top: 30),
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Text('Radio Ga Ga',
                  style: TextStyle(
                      fontSize: 25, color: Colors.white.withOpacity(0.8))),
              Text('Queen',
                  style: TextStyle(
                      fontSize: 15, color: Colors.white.withOpacity(0.6))),
            ],
          ),
          Spacer(),
          FloatingActionButton(
              elevation: 0,
              highlightElevation: 0,
              backgroundColor: Colors.yellowAccent[700],
              child: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: playAnimation,
              ),
              onPressed: () {
                final audioPlayerModel =
                    Provider.of<AudioPlayerModel>(context, listen: false);

                if (this.isPlaying) {
                  playAnimation.reverse();
                  this.isPlaying = false;
                  audioPlayerModel.controller.stop();
                } else {
                  playAnimation.forward();
                  this.isPlaying = true;
                  audioPlayerModel.controller.repeat();
                }

                if (firstTime) {
                  this.open();
                  firstTime = false;
                } else {
                  assetAudioPlayer.playOrPause();
                }
              }),
        ],
      ),
    );
  }
}

class DurationDisk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        margin: EdgeInsets.only(top: 40),
        child: Row(
          children: <Widget>[
            DiskCover(),
            SizedBox(width: 35),
            TrackDuration(),
            SizedBox(width: 10),
          ],
        ));
  }
}

class TrackDuration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final estilo = TextStyle(color: Colors.white.withOpacity(0.4));

    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);
    final porcentaje = audioPlayerModel.porcentaje;

    return Container(
      child: Column(
        children: <Widget>[
          Text('${audioPlayerModel.songTotalDuration}', style: estilo),
          Stack(
            children: <Widget>[
              Container(
                width: 3,
                height: 230,
                color: Colors.white.withOpacity(0.1),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 3,
                  height: 230 * porcentaje,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text('${audioPlayerModel.currentSecond}', style: estilo),
        ],
      ),
    );
  }
}

class DiskCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayerModel = Provider.of<AudioPlayerModel>(context);

    return Container(
      padding: EdgeInsets.all(20),
      width: 250,
      height: 250,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              SpinPerfect(
                  animate: false,
                  duration: Duration(seconds: 13),
                  infinite: true,
                  manualTrigger: true,
                  controller: (animationController) =>
                      audioPlayerModel.controller = animationController,
                  child: Image(image: AssetImage('assets/radio.jpg'))),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(100)),
              ),
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(100)),
              ),
              Container(
                width: 5,
                height: 5,
                decoration: BoxDecoration(
                    color: Colors.white60,
                    borderRadius: BorderRadius.circular(100)),
              )
            ],
          )),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(200),
          gradient: LinearGradient(begin: Alignment.topRight, colors: [
            Color(0xff484750),
            Color(0xff1E1C24),
          ])),
    );
  }
}
