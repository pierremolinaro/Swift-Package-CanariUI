//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 14/06/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI
import Synchronization

//--------------------------------------------------------------------------------------------------

public final class CanariComputationCache <CachedResult : Equatable & Sendable> : Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private enum InternalState : Equatable {
    case computing (Task <(), Never>)
    case waiting (Task <(), Never>)
    case computed (CachedResult)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private let mState : Mutex <InternalState>
  private let mCriticalSection = DispatchSemaphore (value: 1)
  private let mWaitingStateSemaphore = DispatchSemaphore (value: 0)
  private let mDefaultResult : CachedResult

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public init (defaultResult inDefaultResult : CachedResult) {
    self.mDefaultResult = inDefaultResult
    self.mState = Mutex <InternalState> (.computed (inDefaultResult))
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func launchComputing (withComputeFunction inComputeFunction : @escaping @Sendable () -> CachedResult) {
    self.mState.withLock {
      var aTaskIsWaiting = false
      switch $0 {
      case .computed (_) :
        ()
      case .computing (let task) :
        task.cancel ()
      case .waiting (let task) :
        task.cancel ()
        aTaskIsWaiting = true
      }
      let task = Task.detached {
        enterTracing ("cache.run") ; defer { exitTracing ("cache.run") }
        let result = inComputeFunction ()
        self.mState.withLock {
          if case .waiting (_) = $0 {
            self.mWaitingStateSemaphore.signal ()
          }
          $0 = .computed (result)
        }
      }
      $0 = aTaskIsWaiting ? .waiting (task) : .computing (task)
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func getComputedResult () -> CachedResult {
    enterTracing ("cache.get") ; defer { exitTracing ("cache.get") }
    self.mCriticalSection.wait ()
      var isWaiting = true
      var result = self.mDefaultResult
      while isWaiting {
        self.mState.withLock {
          switch $0 {
          case .computing (let task) :
            isWaiting = true
            $0 = .waiting (task)
          case .waiting :
            ()
          case .computed (let r) :
            isWaiting = false
            result = r
          }
        }
        if isWaiting {
          self.mWaitingStateSemaphore.wait ()
        }
      }
    self.mCriticalSection.signal ()
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

extension CanariComputationCache : Equatable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public static func == (lhs: borrowing CanariComputationCache,
                         rhs: borrowing CanariComputationCache) -> Bool {
    true
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
