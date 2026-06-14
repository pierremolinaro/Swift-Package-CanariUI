//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 26/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public protocol DocumentWidgetsDescriptionProtocol {

  associatedtype WidgetTypesDescription : DocumentWidgetsDescriptionProtocol

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  nonisolated static var widgetTypeArray : [any WidgetUIProtocol <WidgetTypesDescription>.Type] { get }

//  @MainActor static func limitTranslation (_ ioTranslation : inout CanariPoint, _ inCanvasSize : CanariSize)
//  nonisolated static func limitTranslation2 ()

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
