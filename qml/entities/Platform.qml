import QtQuick 2.0
import Felgo 4.0

TiledEntityBase {
  id: platform
  entityType: "platform"

  size: 2 // must be >= 2 and even (2,4,6,...), because we got a sprite for the start, one for the end and 2 center sprites that are only repeatable if both are used

  Row {
    id: tileRow
    Tile {
      pos: "left"
      image: Qt.resolvedUrl("../../assets/platform/left.png")
    }
    Repeater {
      model: size-2
      Tile {
        pos: "mid"
        image: Qt.resolvedUrl("../../assets/platform/mid" + index%2 + ".png")
      }
    }
    Tile {
      pos: "right"
      image: Qt.resolvedUrl("../../assets/platform/right.png")
    }
  }

  BoxCollider {
    id: collider
    anchors.fill: parent
    bodyType: Body.Static
    categories: Box.Category2
    fixture.onBeginContact: (other, contactNormal) => {
      var otherEntity = other.getBody().target
      if(otherEntity.entityType === "player") {
        console.debug("contact platform begin")

        // increase the number of active contacts the player has
        player.contactsY=1
      }
    }

    fixture.onEndContact: other => {
      var otherEntity = other.getBody().target
      if(otherEntity.entityType === "player") {
        console.debug("contact platform end")

        // if the player leaves a platform, we decrease its number of active contacts
        player.contactsY=0
      }
    }
  }
}
