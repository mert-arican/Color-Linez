//
//  BallView.swift
//  Color Linez
//
//  Created by Mert Arıcan on 21.08.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

class BallView: UIView {
    
    var ball: Ball? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    var isSelected = false {
        didSet {
            if isSelected { self.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) }
            else { self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0) }
        }
    }
    
    var completionHandler: ((SquareView, SquareView)  -> ())?
    
    private func drawBall() -> UIBezierPath {
        let centerOfSelf = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        let radius = self.bounds.width * 0.3
        let ballView = UIBezierPath(arcCenter: centerOfSelf, radius: radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        switch ball!.color {
        case .blue:
            UIColor.blue.setFill()
        case .brown:
            UIColor.brown.setFill()
        case .green:
            UIColor.green.setFill()
        case .pink:
            UIColor.purple.setFill()
        case .red:
            UIColor.red.setFill()
        case .yellow:
            UIColor.yellow.setFill()
        }
        ballView.fill()
        return ballView
    }
    
    func animateBallMovement(ball: BallView, locations: [CGRect], startingSquare: SquareView, endSquare: SquareView ) {
        consecutiveRecursiveAnimation(ball: ball, locations: locations, index: 0, startingSquare: startingSquare, endSquare: endSquare)
    }
    
    override func draw(_ rect: CGRect) {
        if ball != nil { _ = drawBall() }
    }
    
    private func consecutiveRecursiveAnimation(ball: BallView, locations: [CGRect], index: Int, startingSquare: SquareView, endSquare: SquareView ) {
        // Animates the movement of the ball, one square each time
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.12, delay: 0.0, options: [], animations: {
            self.frame = locations[index]
        })
        {
            [unowned self] finished in
            if locations[index] != endSquare.frame {
                self.consecutiveRecursiveAnimation(ball: ball, locations: locations, index: index+1, startingSquare: startingSquare, endSquare: endSquare)
            } else {
                self.completionHandler?(startingSquare, endSquare)
                self.removeFromSuperview()
            }
        }
    }
    
}
