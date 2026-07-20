//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 18/07/2026.
//--------------------------------------------------------------------------------------------------

public struct CanariSimplePolygon {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let vertices : [CanariPoint]

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (vertices inPoints : [CanariPoint]) {
    self.vertices = inPoints
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public var path : CanariPath {
    CanariPath (points: self.vertices, isClosed: true)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func isVertex (point inP : CanariPoint) -> Bool {
    for p in self.vertices where p == inP {
      return true
    }
    return false
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Algorithme de Dan Sunday, ATTENTION : résultat imprévisible si le point testé est sur le contour
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func contains (point inP : CanariPoint) -> Bool {
    return self.windingNumber (point: inP) != 0
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  // Retourne le winding number.
  // 0  : extérieur
  // !=0: intérieur
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func windingNumber (point inP : CanariPoint) -> Int {
    var wn = 0
    for i in 0 ..< self.vertices.count {
      let v0 = self.vertices [i]
      let v1 = self.vertices [(i + 1) % self.vertices.count]
      if v0.y <= inP.y { // Traversée vers le haut
        if (v1.y > inP.y) && (isLeft (v0, v1, inP) > 0) {
          wn += 1
        }
      }else{ // Traversée vers le bas
        if (v1.y <= inP.y) && (isLeft(v0, v1, inP) < 0) {
          wn -= 1
        }
      }
    }
    return wn
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private func nearestVertex (to inPoint : CanariPoint) -> (CanariLength, Int) {
    var length : CanariLength = .max
    var index : Int = 0
    for (i, p) in self.vertices.enumerated() {
      let d = inPoint.distance (to: p)
      if d < length {
        length = d
        index = i
      }
    }
    return (length, index)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func nearestVertexDistance (to inPoint : CanariPoint) -> CanariLength {
    self.nearestVertex (to: inPoint).0
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func nearestVertexIndex (to inPoint : CanariPoint) -> Int {
    self.nearestVertex (to: inPoint).1
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

// Produit vectoriel (P0->P1) x (P0->P2)
nonisolated private func isLeft (_ inP0 : CanariPoint,
                                 _ inP1 : CanariPoint,
                                 _ inP2 : CanariPoint) -> Int {
  return (inP1.x.cuValue - inP0.x.cuValue) * (inP2.y.cuValue - inP0.y.cuValue)
       - (inP2.x.cuValue - inP0.x.cuValue) * (inP1.y.cuValue - inP0.y.cuValue)
}

//--------------------------------------------------------------------------------------------------
