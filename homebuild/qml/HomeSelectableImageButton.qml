import QtQuick 2.0
import Felgo 3.0
import "../common"

HomeImageButton {
  id: selectableImageButton

  // this property is true, when the button is selected
  property bool isSelected: false

  // this signal is emitted when the button gets selected
  signal selected

  // set background depending on if the button is selected or not
  color: isSelected ? "#c0c0c0" : "#ffffff"
}
