//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 12/02/2026.
//--------------------------------------------------------------------------------------------------

import Foundation
import os.signpost

//--------------------------------------------------------------------------------------------------

fileprivate let kLog = OSLog (
  subsystem: Bundle.main.bundleIdentifier!,
  category: .pointsOfInterest
)

//--------------------------------------------------------------------------------------------------

fileprivate let kSignpostID = OSSignpostID (log: kLog)

//--------------------------------------------------------------------------------------------------

public func enterTracing (_ inString : StaticString) {
  unsafe os_signpost (.begin, log: kLog, name: inString, signpostID: kSignpostID)
}

//--------------------------------------------------------------------------------------------------

public func exitTracing (_ inString : StaticString) {
  unsafe os_signpost (.end, log: kLog, name: inString, signpostID: kSignpostID)
}

//--------------------------------------------------------------------------------------------------
