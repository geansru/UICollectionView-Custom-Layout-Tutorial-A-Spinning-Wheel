//
//  CircularCollectionViewLayout.swift
//  CircularCollectionView
//
//  Created by Dmitriy Roytman on 21.07.17.
//  Copyright © 2017 Rounak Jain. All rights reserved.
//

import UIKit

final class CircularCollectionViewLayout: UICollectionViewLayout {
  let itemSize = CGSize(width: 133, height: 173)
  var angleAtExtreme: CGFloat {
    guard let numberOfItemsInSection = collectionView?.numberOfItemsInSection(0) where numberOfItemsInSection > 0 else { return 0 }
    return -CGFloat(numberOfItemsInSection - 1) * anglePerItem
  }
  var angle: CGFloat {
    guard let collectionView = collectionView else { return 0}
    return angleAtExtreme * collectionView.contentOffset.x / (collectionViewContentSize().width - collectionView.bounds.width)
  }
  var radius: CGFloat = 500.0 {
    didSet {
      invalidateLayout()
    }
  }
  var anglePerItem: CGFloat {
    return atan(itemSize.width / radius)
  }
  var attributesList: [CircularCollectionViewLayoutAttributes] = []
  
  override func collectionViewContentSize() -> CGSize {
    let width = CGFloat(collectionView!.numberOfItemsInSection(0)) * itemSize.width
    let height = collectionView!.bounds.height
    return CGSize(width: width, height: height)
  }
  override class func layoutAttributesClass() -> AnyClass {
    return CircularCollectionViewLayoutAttributes.self
  }
  override func prepareLayout() {
    super.prepareLayout()
    guard let collectionView = collectionView else { return }
    let centerX = collectionView.contentOffset.x + collectionView.bounds.width / 2.0
    let anchorPointY = ((itemSize.height / 2) + radius) / itemSize.height
    let theta = atan2(collectionView.bounds.width/2, radius + (itemSize.height/2) - collectionView.bounds.height/2)
    var startIndex = 0
    var endIndex = collectionView.numberOfItemsInSection(0) - 1
    if angle < -theta {
      startIndex = Int(floor((-theta - angle) / anglePerItem))
    }
    endIndex = min(endIndex, Int(ceil((theta - angle)/anglePerItem)))
    if endIndex < startIndex {
      endIndex = 0
      startIndex = 0
    }
    attributesList = (startIndex..<endIndex).flatMap {
      [weak self] i in
      guard let sself = self else { return nil }
      let attributes = CircularCollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forItem: i, inSection: 0))
      attributes.size = sself.itemSize
      attributes.center = CGPoint(x: centerX, y: CGRectGetMidY(sself.collectionView!.bounds))
      attributes.angle = sself.angle + sself.anglePerItem * CGFloat(i)
      attributes.anchorPoint = CGPoint(x: 0.5, y: anchorPointY)
      return attributes
    }
  }
  
  override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    return attributesList
  }
  override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
    return true
  }
  override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
    return attributesList[indexPath.row]
  }
  
}
