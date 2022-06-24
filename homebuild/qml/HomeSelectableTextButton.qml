/*2022.6.23
wanglingzhi*/

import QtQuick 2.0
import Felgo 3.0

HomeTextButton {
  id: selectableTextButton

  property bool isSelected: false  //选择按钮的属性 同时发出信号
  signal selected

  color: isSelected ? "#c0c0c0" : "#ffffff" //选择按钮设置背景和文本颜色
  textColor: isSelected ? "#f0f0f0" : "#000000"

}
