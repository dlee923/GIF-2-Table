//
//  MainVCScrollMods.swift
//  Gif 2 Table
//
//  Created by Daniel Lee on 5/13/17.
//  Copyright © 2017 DLEE. All rights reserved.
//

import UIKit

extension MainVC {
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.x
        
        let page = Int(round(offset / viewWidth!))
        let cellNum = Int(offset / viewWidth!)
        
        let fadeCellAlpha = abs(offset - (pageXReference! + (viewWidth! * CGFloat(cellNum)))) / (pageXReference! * animateOpacityStart)
        
        let currentCell = self.collectionView?.cellForItem(at: IndexPath(item: page, section: 0))
        
        for cell in (collectionView?.visibleCells)! {
            cell.alpha = 0
        }
        currentCell?.alpha = fadeCellAlpha
    }
    
    func establishScrollProperties() {
        viewWidth = collectionView?.frame.width
        pageXReference = viewWidth!/2
    }
}
