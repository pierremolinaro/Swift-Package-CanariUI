//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 30/08/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public nonisolated struct CanariRulerUnitDescriptor : Sendable {
  public let mainUnitLength : CanariLength
  public let mainUnitString : String
  public let displayFactor : Int
}

//--------------------------------------------------------------------------------------------------

public nonisolated let horizontalRulerDescriptor_100mils = CanariRulerUnitDescriptor (
  mainUnitLength: CanariLength.mil (100),
  mainUnitString: "mil",
  displayFactor: 100
)

//--------------------------------------------------------------------------------------------------

public nonisolated let horizontalRulerDescriptor_cm = CanariRulerUnitDescriptor (
  mainUnitLength: CanariLength.cm (1),
  mainUnitString: "cm",
  displayFactor: 1
)

//--------------------------------------------------------------------------------------------------

public nonisolated let horizontalRulerDescriptor_inch = CanariRulerUnitDescriptor (
  mainUnitLength: CanariLength.inch (1),
  mainUnitString: "inch",
  displayFactor: 1
)

//--------------------------------------------------------------------------------------------------
