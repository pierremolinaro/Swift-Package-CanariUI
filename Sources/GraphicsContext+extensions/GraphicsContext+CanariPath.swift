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
    self.stroke (inPath.mPath, with: inShading, style: inStyle.swiftui)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func stroke (_ inPath : CanariPath,
               with inShading : GraphicsContext.Shading,
               lineWidth inLineWidth : CanariLength) {
    let style = CanariStrokeStyle (lineWidth: inLineWidth)
    self.stroke (inPath.mPath, with: inShading, style: style.swiftui)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func stroke (rect inRect : CanariRect,
               with inShading : GraphicsContext.Shading,
               lineWidth inLineWidth : CanariLength) {
    let path = CanariPath (rect: inRect)
    self.stroke (path.mPath, with: inShading, lineWidth: inLineWidth.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func fill (_ inPath : CanariPath,
             with inShading : GraphicsContext.Shading,
             style inStyle : CanariFillStyle = CanariFillStyle()) {
    self.fill (inPath.mPath, with: inShading, style: inStyle.fillStyle)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
