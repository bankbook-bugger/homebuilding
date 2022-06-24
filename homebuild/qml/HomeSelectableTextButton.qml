import QtQuick 2.0
import QtQuick.Controls.Styles 1.0
import Felgo 3.0

HomeTextButton {
  id: selectableTextButton

  // this property is true, when the button is selected
  property bool isSelected: false

  // this signal is emitted when the button gets selected
  signal selected

  // set background and text color depending on if the button is selected or not
  style: ButtonStyle{
      background: Rectangle{
          radius: 3
          color: isSelected ? "#c0c0c0" : "#413d3c"
      }
  }
  textColor: isSelected ? "#000000" : "#f0f0f0"

}
