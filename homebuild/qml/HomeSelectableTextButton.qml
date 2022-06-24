/*2022.6.23
wanglingzhi*/

import QtQuick 2.0
import QtQuick.Controls.Styles 1.0
import Felgo 3.0

HomeTextButton {
  id: selectableTextButton

  property bool isSelected: false  //选择按钮的属性 同时发出信号
  signal selected

<<<<<<< HEAD

=======
  // set background and text color depending on if the button is selected or not
  style: ButtonStyle{
      background: Rectangle{
          radius: 3
          color: isSelected ? "#c0c0c0" : "#413d3c"
      }
  }
  textColor: isSelected ? "#000000" : "#f0f0f0"
>>>>>>> e9e528508949a36ba3fe2ccacc920eea90b4b3ef

}
