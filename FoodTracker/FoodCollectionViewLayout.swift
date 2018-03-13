//
//  FoodCollectionViewLayout.swift
//  FoodTracker
//
//  Created by Internship on 3/5/18.
//  Copyright © 2018 Internship. All rights reserved.
//

import UIKit

protocol FoodLayoutDelegate: class {
    func collectionView(_ collectionView:UICollectionView, sizeForImageAtIndexPath indexPath:IndexPath) -> (height: CGFloat, width: CGFloat)
}

class FoodCollectionViewLayout: UICollectionViewLayout {

    weak var delegate : FoodLayoutDelegate!
    fileprivate var contentHeight : CGFloat = 0
    fileprivate let columnsAmount = 2
    fileprivate let cellPadding : CGFloat = 6
    fileprivate var cache = [UICollectionViewLayoutAttributes]()
    fileprivate var contentWidth : CGFloat {
        guard let collectionView = collectionView else {
            return 0
        }
        let insets = collectionView.contentInset
        return collectionView.bounds.width - (insets.left + insets.right)
    }
    
    override func prepare() {
        guard let collectionView = collectionView  else {
            return
        }
        
        cache.removeAll()
        contentHeight = 0
        let columnWidth = contentWidth / CGFloat(columnsAmount)
        var xOffset = [CGFloat]()
        
        for column in 0..<columnsAmount {
            xOffset.append(CGFloat(column) * columnWidth)
        }
        
        var column = 0
        var yOffset = [CGFloat](repeating: 0, count: columnsAmount)
        
        for item in 0..<collectionView.numberOfItems(inSection: 0) {
            let indexPath = IndexPath(item : item, section: 0)
            let photoSize = delegate.collectionView(collectionView, sizeForImageAtIndexPath: indexPath)
            let photoHeight = photoSize.height
            let photoWidth = photoSize.width
            let fittedHeight = calculateSizeImage(height: photoHeight, width: photoWidth, columnWidth: columnWidth)
            let heigth = cellPadding * 2 + (fittedHeight) + 27
            let frame = CGRect(x: xOffset[column], y: yOffset[column], width: columnWidth, height: heigth)
            let insetFrame = frame.insetBy(dx: cellPadding, dy: cellPadding)
            
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            attributes.frame = insetFrame
            cache.append(attributes)
            
            contentHeight = max(contentHeight, frame.maxY)
            yOffset[column] = yOffset[column] + heigth
            
            column = column < (columnsAmount - 1) ? (column + 1) : 0
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attribute in cache {
            if attribute.frame.intersects(rect) {
                visibleLayoutAttributes.append(attribute)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache[indexPath.item]
    }
    
    func calculateSizeImage(height: CGFloat, width: CGFloat, columnWidth: CGFloat) -> CGFloat {
        let fittedHeight = height / (width / columnWidth)
        return fittedHeight
    }
}
