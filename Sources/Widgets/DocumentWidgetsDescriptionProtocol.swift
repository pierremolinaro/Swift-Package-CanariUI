//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 26/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public protocol DocumentWidgetsDescriptionProtocol {

  associatedtype WidgetTypesDescription : DocumentWidgetsDescriptionProtocol

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated static var widgetTypeArray : [(any WidgetUIProtocol <WidgetTypesDescription>.Type, String)] { get }

//  @MainActor static func limitTranslation (_ ioTranslation : inout CanariPoint, _ inCanvasSize : CanariSize)
//  static func limitTranslation2 ()

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

extension DocumentWidgetsDescriptionProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  static func documentEncodedTypeName (_ inWidget : any WidgetUIProtocol) -> String {
    let type = type(of: inWidget)
    for (widgetType, typeName) in Self.widgetTypeArray {
      if widgetType == type {
        return typeName
      }
    }
    return "???"
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
