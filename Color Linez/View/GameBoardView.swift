//
//  GameBoardView.swift
//  Color Linez
//
//  Created by Mert Arıcan on 21.08.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

class GameBoardView: UIView {
    
    var squaresOnBoard = [Square]() {
        didSet {
            addSquaresOnScreen()
        }
    }
    
    private(set) var squaresOnScreen = [SquareView]()
    
    func getSquareView(at position: Position) -> SquareView {
        return squaresOnScreen.filter { $0.position == position }.first!
    }
    
    private func addSquaresOnScreen() {
        let unitDistance = self.bounds.width/9
        for square in squaresOnBoard {
            let x = unitDistance * CGFloat(square.position.column)
            let y = unitDistance * CGFloat(square.position.row)
            let squareView = SquareView(frame: CGRect(x: x, y: y, width: unitDistance, height: unitDistance))
            squareView.backgroundColor = UIColor.gray.withAlphaComponent(0.75)
            squareView.layer.borderWidth = 1.0 ; squareView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            squareView.position = square.position ; squareView.ball = square.ballInside
            squaresOnScreen.append(squareView) ; addSubview(squareView)
        }
    }
    
}
