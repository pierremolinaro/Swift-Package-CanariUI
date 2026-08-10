//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 19/09/2025.
//--------------------------------------------------------------------------------------------------

import AppKit

//--------------------------------------------------------------------------------------------------

extension CanariLength {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  var valueEncodedWithUnit : String {
    if self == .zero {
      return "0"
    }else if self.isAligned (CanariLength.Unit.cm.length) {
      return "\(self.cuValue / CanariLength.Unit.cm.length.cuValue)cm"
    }else if self.isAligned (CanariLength.Unit.mm.length) {
      return "\(self.cuValue / CanariLength.Unit.mm.length.cuValue)mm"
    }else if self.isAligned (CanariLength.Unit.µm.length) {
      return "\(self.cuValue / CanariLength.Unit.µm.length.cuValue)µm"
    }else if self.isAligned (CanariLength.Unit.inch.length) {
      return "\(self.cuValue / CanariLength.Unit.inch.length.cuValue)in"
    }else if self.isAligned (CanariLength.Unit.mil.length) {
      return "\(self.cuValue / CanariLength.Unit.mil.length.cuValue)mil"
    }else if self.isAligned (CanariLength.Unit.px.length) {
      return "\(self.cuValue / CanariLength.Unit.px.length.cuValue)px"
    }else{
      return "\(self.cuValue)"
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

extension Scanner {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func scanCanariLengthEncodedWithUnit () -> CanariLength? {
    if let v = self.scanInt () {
      if self.scanString ("mm") != nil {
        return .mm (v)
      }else if self.scanString ("cm") != nil {
        return .cm (v)
      }else if self.scanString ("µm") != nil {
        return .µm (v)
      }else if self.scanString ("in") != nil {
        return .inch (v)
      }else if self.scanString ("mil") != nil {
        return .mil (v)
      }else if self.scanString ("px") != nil {
        return .px (v)
      }else{
        return .cu (v)
      }
    }else{
      return nil
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------

extension String {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func decodedCanariLengthWithUnit () -> CanariLength? {
    let scanner = Scanner (string: self)
    return scanner.scanCanariLengthEncodedWithUnit ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
