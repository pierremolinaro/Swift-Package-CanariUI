//--------------------------------------------------------------------------------------------------
//  Created by Pierre Molinaro on 20/09/2024.
//--------------------------------------------------------------------------------------------------

import Foundation

//--------------------------------------------------------------------------------------------------

public struct CanariAffinity : CustomStringConvertible, Sendable {

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  private var mAffineTransform : AffineTransform

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   Creates an affine transformation matrix with identity values.
   - see also: identity
  */

  public init () {
    self.mAffineTransform = AffineTransform ()
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   Creates an affine transformation matrix from translation values.
   The matrix takes the following form:

       [ 1  0  0 ]
       [ 0  1  0 ]
       [ x  y  1 ]
   */

  public init (translationByX inX : CanariLength, byY inY : CanariLength) {
    self.mAffineTransform = AffineTransform (
      translationByX: inX.pxValue,
      byY: inY.pxValue
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
 Creates an affine transformation matrix from scaling values.
 The matrix takes the following form:

     [ x  0  0 ]
     [ 0  y  0 ]
     [ 0  0  1 ]
 */

  public init (scaleByX inFactorX : CGFloat, byY inFactorY : CGFloat) {
    self.mAffineTransform = AffineTransform (
      scaleByX: inFactorX,
      byY: inFactorY
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   Creates an affine transformation matrix from scaling a single value.
   The matrix takes the following form:

       [ f  0  0 ]
       [ 0  f  0 ]
       [ 0  0  1 ]
  */

  public init (scale inFactor : CGFloat) {
    self.mAffineTransform = AffineTransform (scale: inFactor)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   Creates an affine transformation matrix from rotation value.
   The matrix takes the following form:

       [  cos α   sin α  0 ]
       [ -sin α   cos α  0 ]
       [    0       0    1 ]
   */

  public init (rotation inAngle : CanariAngle) {
    self.mAffineTransform = AffineTransform (rotationByRadians: inAngle.radians)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   Creates an affine transformation matrix from a Foundation AffineTransform.
  */

  public init (_ inAffineTransform : AffineTransform) {
    self.mAffineTransform = inAffineTransform
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   Returns the corresponding Foundation affine transformation matrix.
  */

  var affineTransform : AffineTransform { self.mAffineTransform }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   Creates an affine transformation matrix from a CoreGraphics CGAffineTransform.
  */

  public init (_ inAffineTransform : CGAffineTransform) {
    self.mAffineTransform = AffineTransform (
      m11: inAffineTransform.a,
      m12: inAffineTransform.b,
      m21: inAffineTransform.c,
      m22: inAffineTransform.d,
      tX: inAffineTransform.tx,
      tY: inAffineTransform.ty
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   Returns the corresponding CoreGraphics affine transformation matrix.
  */

  var cgAffineTransform : CGAffineTransform {
    CGAffineTransform (
      a: self.mAffineTransform.m11,
      b: self.mAffineTransform.m12,
      c: self.mAffineTransform.m21,
      d: self.mAffineTransform.m22,
      tx: self.mAffineTransform.tX,
      ty: self.mAffineTransform.tY
    )
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   An identity affine transformation matrix

       [ 1  0  0 ]
       [ 0  1  0 ]
       [ 0  0  1 ]
  */
  public static let identity = CanariAffinity ()

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   Mutates an affine transformation matrix from x and y translation values.
  */

  public mutating func translate (x inDx : CanariLength, y inDy : CanariLength) {
    self.mAffineTransform.translate (x: inDx.pxValue, y: inDy.pxValue)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   Mutates an affine transformation matrix from a rotation value.
  */

  public mutating func rotate (_ inAngle : CanariAngle) {
    self.mAffineTransform.rotate (byRadians: inAngle.radians)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   Mutates an affine transformation matrix from a scale value.
  */

  public mutating func scale (_ inFactor : CGFloat) {
    self.mAffineTransform .scale (inFactor)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   Mutates an affine transformation matrix from a x-scale and y-scale values.
  */

  public mutating func scale (x inFactorX : CGFloat, y inFactorY : CGFloat) {
    self.mAffineTransform.scale (x: inFactorX, y: inFactorY)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   Inverts the transformation matrix if possible. Matrices with a determinant that is less than
   the smallest valid representation of a double value greater than zero are considered to be
   invalid for representing as an inverse. If the input AffineTransform can potentially fall into
   this case then the inverted() method is suggested to be used instead since that will return
   an optional value that will be nil in the case that the matrix cannot be inverted.

   D = (m11 * m22) - (m12 * m21)

   D < ε the inverse is undefined and will be nil
  */
  public mutating func invert () {
    self.mAffineTransform = self.mAffineTransform.inverted ()!
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
   Inverts the transformation matrix if possible. If not possible, returns nil.Matrices with
   a determinant that is less than
   the smallest valid representation of a double value greater than zero are considered to be
   invalid for representing as an inverse.

   D = (m11 * m22) - (m12 * m21)

   D < ε the inverse is undefined and will be nil
  */

  public func inverted () -> CanariAffinity? {
    if let af = self.mAffineTransform.inverted () {
      return CanariAffinity (af)
    }else{
      return nil
    }
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func append (_ inTransform : CanariAffinity) {
    self.mAffineTransform.append (inTransform.mAffineTransform)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public mutating func prepend (_ inTransform : CanariAffinity) {
    self.mAffineTransform.prepend (inTransform.mAffineTransform)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  /**
    A textual representation of this instance.
  */
  
  public var description : String { // CustomStringConvertible protocol
    var s = "m11: \(self.mAffineTransform.m11), m12: \(self.mAffineTransform.m12)"
    s += " m21: \(self.mAffineTransform.m21), m22: \(self.mAffineTransform.m22)"
    s += " tX: \(self.mAffineTransform.tX), tY: \(self.mAffineTransform.tY)"
    return s
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func translating (x inDx : CanariLength = .zero,
                           y inDy : CanariLength = .zero) -> CanariAffinity {
    var af = self
    af.translate (x: inDx, y: inDy)
    return af
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func rotating (_ inAngle : CanariAngle) -> CanariAffinity {
    var af = self
    af.rotate (inAngle)
    return af
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func transforming (_ inPoint : CanariPoint) -> CanariPoint {
    let nsPoint = self.affineTransform.transform (inPoint.pxValue)
    return CanariPoint (px: nsPoint)
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func transforming (_ inPath : CanariPath) -> CanariPath {
    var result = CanariPath ()
    result.mPath = inPath.mPath.applying (self.cgAffineTransform)
    return result
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  public func scaling (_ inFactor : Double) -> CanariAffinity {
    var af = self
    af.scale (inFactor)
    return af
  }

  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

}

//--------------------------------------------------------------------------------------------------
