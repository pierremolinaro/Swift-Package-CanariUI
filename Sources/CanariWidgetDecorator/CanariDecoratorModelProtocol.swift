//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 27/03/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public protocol CanariDecoratorModelProtocol <WidgetTypesDescription> : Identifiable, Sendable, Codable {

  associatedtype WidgetTypesDescription : DocumentWidgetsDescriptionProtocol

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var id : UUID { get }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func duplicated () -> (any CanariDecoratorUIProtocol <WidgetTypesDescription>)?

 // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
