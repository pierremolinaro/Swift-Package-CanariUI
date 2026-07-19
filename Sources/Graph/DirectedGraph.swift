//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/07/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public final class Node <INFO> {
  let id = UUID ()
  let info : INFO

  fileprivate init (_ info: INFO) {
    self.info = info
  }
}

//--------------------------------------------------------------------------------------------------

public struct DirectedGraph <INFO> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mNodeDictionary = [UUID : Node <INFO>] ()
  private var mArrows = [UUID : [UUID]] ()

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addNode (_ inInfo : INFO) -> Node <INFO> {
    let node = Node (inInfo)
    self.mNodeDictionary [node.id] = node
    return node
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addEdge (from inStartNode : Node <INFO>, to inTargetNode : Node <INFO>) {
    self.mArrows [inStartNode.id, default: []].append (inTargetNode.id)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // algorithme de Arthur B. Kahn
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func topologicalSort () -> [INFO]? {
    var inputDegreeDictionary = [UUID : UInt] ()
  //--- Initialisation
    for nodeID in self.mNodeDictionary.keys {
      inputDegreeDictionary [nodeID] = 0
    }
  //--- Calcul des degrés entrants
    for (_, neighbors) in self.mArrows {
      for n in neighbors {
        inputDegreeDictionary [n, default: 0] += 1
      }
    }
  //--- Sommets sans prédécesseur
    var queue = Array (inputDegreeDictionary.filter { $0.value == 0 }.keys)
    var result = [INFO] ()
  //---
    while !queue.isEmpty {
      let nodeID = queue.removeFirst ()
      result.append (self.mNodeDictionary [nodeID]!.info)
      for targetNodeID in self.mArrows [nodeID] ?? [] {
        inputDegreeDictionary [targetNodeID]! -= 1
        if inputDegreeDictionary [targetNodeID] == 0 {
          queue.append (targetNodeID)
        }
      }
    }
  //---
    return (result.count == self.mNodeDictionary.count) ? result : nil
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
