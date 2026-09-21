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
    self.stroke (path.mPath, with: inShading, lineWidth: inLineWidth.ptValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func stroke (_ inPath : CanariPath,
               with inShading : GraphicsContext.Shading,
               dottedLineWidth inLineWidth : CanariLength) {
    let w = inLineWidth.ptValue
    let style = StrokeStyle (lineWidth: w, dash: [5 * w, 5 * w], dashPhase: 0.0)
    self.stroke (inPath.mPath, with: inShading, style: style)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  func fill (_ inPath : CanariPath,
             with inShading : GraphicsContext.Shading,
             style inStyle : CanariFillStyle) {
    self.fill (inPath.mPath, with: inShading, style: inStyle.fillStyle)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
