//wanglingzhi 2022.6.22
import Felgo 3.0
import QtQuick 2.0
import QtMultimedia 5.0


//qml 是背景音乐和音效的文件
Item {
  id: musicManager

  Component.onCompleted: handleMusic()          //后面的函数

  /*Background Music */

  BackgroundMusic {
    id: menuMusic                    //菜单的音乐
    autoPlay: false           // 默认不播放
    source: "../../assets/audio/music/menuMusic.mp3"
  }

  BackgroundMusic {
    id: playMusic                    //玩游戏时的音乐
    autoPlay: false
    source: "../../assets/audio/music/playMusic.mp3"
  }

  BackgroundMusic {
    id: editMusic                     //编辑界面的bgm
    autoPlay: false
    source: "../../assets/audio/music/editMusic.mp3"
  }

  /*音效*/

  SoundEffect {
    id: playerJump                   //跳
    source: "../../assets/audio/sounds/phaseJump1.wav"
  }

  SoundEffect {
    id: playerHit
    source: "../../assets/audio/sounds/whizz.wav"
  }

  SoundEffect {
    id: playerDie                   //die
    source: "../../assets/audio/sounds/lose.wav"
  }

  SoundEffect {
    id: collectMaterials              //收集物资(塑料瓶）
    source: "../../assets/audio/sounds/coin_3.wav"
  }

  SoundEffect {
    id: collectHeart                  //生命
    source: "../../assets/audio/sounds/zapThreeToneUp.wav"
  }

  SoundEffect {
    id: finish                          //完成
    source: "../../assets/audio/sounds/coin-04.wav"
  }

  SoundEffect {
    id: opponentWalkerDie             //走路对手die
    source: "../../assets/audio/sounds/bird-chirp.wav"
  }

  SoundEffect {
    id: opponentJumperDie             //跳跃对手die
    source: "../../assets/audio/sounds/twitch.wav"
  }

  SoundEffect {
    id: start                         //开始
    source: "../../assets/audio/sounds/yahoo.wav"
  }

  SoundEffect {
    id: click                         //点击
    source: "../../assets/audio/sounds/click1.wav"
  }

  SoundEffect {
    id: dragEntity                  //拖动实体
    source: "../../assets/audio/sounds/slide-network.wav"
  }

  SoundEffect {
    id: createOrDropEntity          //实体创建或掉落
    source: "../../assets/audio/sounds/tap_professional.wav"
  }

  SoundEffect {
    id: removeEntity                 //移动实体
    source: "../../assets/audio/sounds/tap_mellow.wav"
  }


function handleMusic() {           //根据状态设置音乐
    if(activeScene === gameScene) {
      if(gameScene.state == "play" || gameScene.state == "test")
        audioManager.startMusic(playMusic)
      else if(gameScene.state == "edit")
        audioManager.startMusic(editMusic)
    }
    else {
      audioManager.startMusic(menuMusic)
    }
  }

  // starts the given music
  function startMusic(music) {
    // if music is already playing, we don't have to do anything
    if(music.playing)
      return

    // otherwise stop all music tracks
    menuMusic.stop()
    playMusic.stop()
    editMusic.stop()

    // play the music
    music.play()
  }

  // play the sound effect with the given name
  function playSound(sound) {
    if(sound === "playerJump")
      playerJump.play()
      else if(sound === "playerHit")
      playerHit.play()
    else if(sound === "playerDie")
      playerDie.play()
    else if(sound === "playerInvincible")
      playerInvincible.play()
    else if(sound === "collectMaterials")
      collectMaterials.play()
      else if(sound === "collectMushroom")
      collectMushroom.play()
    else if(sound === "finish")
      finish.play()
    else if(sound === "opponentWalkerDie")
      opponentWalkerDie.play()
    else if(sound === "opponentJumperDie")
      opponentJumperDie.play()
    else if(sound === "start")
      start.play()
    else if(sound === "click")
      click.play()
    else if(sound === "dragEntity")
      dragEntity.play()
    else if(sound === "createOrDropEntity")
      createOrDropEntity.play()
    else if(sound === "removeEntity")
      removeEntity.play()
    else
      console.debug("unknown sound name:", sound)
  }

  // stop the sound effect with the given name
  function stopSound(sound) {
    if(sound === "playerInvincible")
      playerInvincible.stop()
    else
      console.debug("unknown sound name:", sound)
  }
}
