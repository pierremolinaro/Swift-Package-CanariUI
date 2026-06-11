//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 12/02/2026.
//--------------------------------------------------------------------------------------------------

import Foundation
import os.signpost

//--------------------------------------------------------------------------------------------------

public let TRACING_IS_ENABLED_USER_DEFAULT_KEY = "tracing.is.enabled"

//--------------------------------------------------------------------------------------------------

nonisolated(unsafe) fileprivate var gTracingIsEnabled = UserDefaults.standard.bool (forKey: TRACING_IS_ENABLED_USER_DEFAULT_KEY)

//--------------------------------------------------------------------------------------------------

public func setTracingIsEnabled (_ inFlag : Bool) {
  // print ("setTracingIsEnabled \(gTracingIsEnabled) -> \(inFlag)")
  gTracingIsEnabled = inFlag
}

//--------------------------------------------------------------------------------------------------

fileprivate let kLog = OSLog (
  subsystem: Bundle.main.bundleIdentifier!,
  category: .pointsOfInterest
)

//--------------------------------------------------------------------------------------------------

fileprivate let kSignpostID = OSSignpostID (log: kLog)

//--------------------------------------------------------------------------------------------------

nonisolated public func enterTracing (_ inString : StaticString) {
  if gTracingIsEnabled {
    unsafe os_signpost (.begin, log: kLog, name: inString, signpostID: kSignpostID)
  }
}

//--------------------------------------------------------------------------------------------------

nonisolated public func exitTracing (_ inString : StaticString) {
  if gTracingIsEnabled {
    unsafe os_signpost (.end, log: kLog, name: inString, signpostID: kSignpostID)
  }
}

//--------------------------------------------------------------------------------------------------
