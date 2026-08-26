//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 10/08/2026.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------

public struct CanariShapeIssue : Identifiable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public struct Identifier : Equatable, Hashable {
    public let shapeID : UUID
    public let index : UInt
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public struct NamedAction {
    public let name : String
    public let action : () -> Void
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public enum Kind : Hashable {
    case warning
    case error
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public let id : Self.Identifier
  public let title : String
  public let absoluteOutline : CanariPath
  public let kind : Kind
  public let namedAction : NamedAction

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
