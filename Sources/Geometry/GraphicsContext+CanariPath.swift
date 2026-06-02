//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 21/02/2026.
//--------------------------------------------------------------------------------------------------

import SwiftUI

//--------------------------------------------------------------------------------------------------

public extension GraphicsContext {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func stroke (_ inPath : CanariPath,
               with inShading : GraphicsContext.Shading,
               style inStyle : CanariStrokeStyle) {
    self.stroke (inPath.swiftuiPath, with: inShading, style: inStyle.strokeStyle)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func stroke (_ inPath : CanariPath,
               with inShading : GraphicsContext.Shading,
               lineWidth inLineWidth : CanariLength = .px (1)) {
    self.stroke (inPath.swiftuiPath, with: inShading, lineWidth: inLineWidth.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func fill (_ inPath : CanariPath,
             with inShading : GraphicsContext.Shading,
             style inStyle : CanariFillStyle = CanariFillStyle()) {
    self.fill (inPath.swiftuiPath, with: inShading, style: inStyle.fillStyle)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
