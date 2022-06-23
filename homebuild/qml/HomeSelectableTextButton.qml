import QtQuick 2.0
import Felgo 3.0

HomeTextButton {
  id: selectableTextButton

  // this property is true, when the button is selected
  property bool isSelected: false

  // this signal is emitted when the button gets selected
  signal selected

  // set background and text color depending on if the button is selected or not
  color: isSelected ? "#c0c0c0" : "#ffffff"
  textColor: isSelected ? "#f0f0f0" : "#000000"

}
