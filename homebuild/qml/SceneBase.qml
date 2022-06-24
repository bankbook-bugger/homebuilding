/*2022.6.23
  wanglingzhi*/

import QtQuick 2.0
import Felgo 3.0

Scene {
  width: 480
  height: 320

  opacity: 0     //不透明度 //默认不透明度
  visible: opacity > 0   //检测透明度是否为0 看可见性

  enabled: visible         //场景访问此属性检测透明度
}
