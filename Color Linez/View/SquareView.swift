//
//  SquareView.swift
//  Color Linez
//
//  Created by Mert Arıcan on 21.08.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

class SquareView: UIView {
    
    var position: Position!
    
    var ballView: BallView?
    
    var ball: Ball? {
        didSet {
            ballView?.removeFromSuperview()
            if ball != nil {
                ballView = BallView(frame: self.bounds)
                ballView?.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                ballView?.ball = ball
                addSubview(ballView!)
            }
        }
    }
    
}
