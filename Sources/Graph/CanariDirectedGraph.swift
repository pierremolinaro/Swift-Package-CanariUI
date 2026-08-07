//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 06/07/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public struct CanariDirectedGraph <INFO> {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public final class Node {
    let id = UUID ()
    public let info : INFO

    fileprivate init (_ info: INFO) {
      self.info = info
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mNodeDictionary = [UUID : Self.Node] ()
  private var mArrows = [UUID : [UUID]] ()

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init () {
  }
  
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addNode (_ inInfo : INFO) -> Self.Node {
    let node = Self.Node (inInfo)
    self.mNodeDictionary [node.id] = node
    return node
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func addEdge (from inStartNode : Self.Node, to inTargetNode : Self.Node) {
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
  // algorithme de Arthur B. Kahn
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func topologicalSort (_ inCallBack : ([INFO]) -> [Int]) {
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
  //---
    while !queue.isEmpty {
      let removedIndexes = inCallBack (queue.map { self.mNodeDictionary [$0]!.info } )
      for removedIndex in removedIndexes.sorted ().reversed () {
        let removedNodeID = queue.remove (at: removedIndex)
        for targetNodeID in self.mArrows [removedNodeID] ?? [] {
          inputDegreeDictionary [targetNodeID]! -= 1
          if inputDegreeDictionary [targetNodeID] == 0 {
            queue.append (targetNodeID)
          }
        }
      }
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
