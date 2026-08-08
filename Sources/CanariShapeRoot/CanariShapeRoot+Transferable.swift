//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import UniformTypeIdentifiers

//--------------------------------------------------------------------------------------------------

fileprivate extension UTType {
  static nonisolated let shapeUTType = UTType (exportedAs: Bundle.main.bundleIdentifier! + ".shape")
}

//--------------------------------------------------------------------------------------------------

extension CanariShapeRoot : Transferable {

 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static var transferRepresentation: some TransferRepresentation {
    CodableRepresentation (contentType: .shapeUTType)
  }

 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
