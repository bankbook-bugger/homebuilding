/*2022.6.23
wanglingzhi*/

import QtQuick 2.0
import QtQuick.Controls.Styles 1.0
import Felgo 3.0

HomeImageButton {
  id: selectableImageButton

  property bool isSelected: false  //选择按钮的属性 同时发出信号
  signal selected

  style: ButtonStyle{                 //覆盖Text里默认的样式
      background: Rectangle{
          radius: 3
          color: isSelected ? "#413d3c": "#c0c0c0"
      }
  }
}
