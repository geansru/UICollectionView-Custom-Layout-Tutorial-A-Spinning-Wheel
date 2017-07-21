//
//  CircularCollectionViewLayoutAttributes.swift
//  CircularCollectionView
//
//  Created by Dmitriy Roytman on 21.07.17.
//  Copyright © 2017 Rounak Jain. All rights reserved.
//

import UIKit

final class CircularCollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {
  var anchorPoint = CGPoint(x: 0.5, y: 0.5)
  var angle: CGFloat = 0 {
    didSet {
      zIndex = Int(angle * 1000000)
      transform = CGAffineTransformMakeRotation(angle)
    }
  }
  override func copyWithZone(zone: NSZone) -> AnyObject {
    let copiedAttributes = super.copyWithZone(zone) as! CircularCollectionViewLayoutAttributes
    copiedAttributes.anchorPoint = anchorPoint
    copiedAttributes.angle = angle
    return copiedAttributes
  }
}
