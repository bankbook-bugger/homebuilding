/*2022.6.23
wanglingzhi*/

import QtQuick 2.0
import Felgo 3.0

HomeImageButton {
  id: selectableImageButton

  property bool isSelected: false  //选择按钮的属性 同时发出信号
  signal selected

  color: isSelected ? "#c0c0c0" : "#ffffff"  //设置背景
}
