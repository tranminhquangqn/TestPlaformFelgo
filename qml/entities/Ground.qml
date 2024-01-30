import QtQuick 2.0
import Felgo 4.0

TiledEntityBase {
  id: ground
  entityType: "ground"

  size: 2 // must be >= 2, because we got a sprite for the start, one for the end and a repeatable center sprite

  Row {
    id: tileRow
    Tile {
      pos: "left"
      image: Qt.resolvedUrl("../../assets/ground/left.png")
    }
    Repeater {
      model: size-2
      Tile {
        pos: "mid"
        image: Qt.resolvedUrl("../../assets/ground/mid.png")
      }
    }
    Tile {
      pos: "right"
      image: Qt.resolvedUrl("../../assets/ground/right.png")
    }
  }

  BoxCollider {
    anchors.fill: parent
    bodyType: Body.Static
    fixture.onBeginContact: (other, contactNormal) => {
      var otherEntity = other.getBody().target
      if(otherEntity.entityType === "player") player.contacts++
    }
    fixture.onEndContact: other => {
      var otherEntity = other.getBody().target
      if(otherEntity.entityType === "player") player.contacts--
    }
  }
}
