import Felgo 4.0
import QtQuick 2.0
import "../entities"
import "." as Levels

Levels.LevelBase {
    id: level
    // we need to specify the width to get correct debug draw for our physics
    // the PhysicsWorld component fills it's parent by default, which is the viewPort Item of the gameScene and this item uses the size of the level
    // NOTE: thy physics will also work without defining the width here, so no worries, you can ignore it untill you want to do some physics debugging
    width: 42 * gameScene.gridSize // 42 because our last tile is a size 30 Ground at row 12
    // you could draw your level on a graph paper and then add the tiles here only by defining their row, column and size
    Ground {
        row: 0
        column: 0
        size: 6
    }
    Ground {
        row: 8
        column: 0
        size: 2
    }


    Platform {
        row: 11
        column: 3
        size: 2
    }

    Ground {
        row: 12
        column: 0
        size: 30
    }
    Platform {
        row: 17
        column: 3
        size: 10
    }
    Blocker {
        row: 30
        column: 5
        size: 10
    }
    Blocker {
        row: 10
        column: 15
        size: 10
    }
}
