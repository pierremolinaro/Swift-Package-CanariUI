//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 26/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public protocol DocumentWidgetsDescriptionProtocol {

  associatedtype WidgetTypesDescription : DocumentWidgetsDescriptionProtocol

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated static var widgetTypeArray : [(any DecoratorUIProtocol <WidgetTypesDescription>.Type, String)] { get }

//  @MainActor static func limitTranslation (_ ioTranslation : inout CanariPoint, _ inCanvasSize : CanariSize)
//  static func limitTranslation2 ()

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

extension DocumentWidgetsDescriptionProtocol {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  static func documentEncodedTypeName (_ inDecorator : any DecoratorUIProtocol) -> String {
    let type = type(of: inDecorator)
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
