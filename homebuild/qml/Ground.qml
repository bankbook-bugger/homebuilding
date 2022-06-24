import QtQuick 2.0
import Felgo 3.0

// this is the base class for all Ground objects
HomeEntityBaseDraggable {
  id: ground
  entityType: "ground"

  // define colliderComponent for collision detection while dragging
  colliderComponent: collider

  BoxCollider {
    id: collider

    anchors.fill: parent
    bodyType: Body.Static

    // Category5: solids
    categories: Box.Category5
    // Category1: player body, Category2: player feet sensor,
    // Category3: opponent body, Category4: opponent sensor
    collidesWith: Box.Category1 | Box.Category2 | Box.Category3 | Box.Category4
  }
}
