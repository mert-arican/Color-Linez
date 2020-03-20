//
//  GameViewController.swift
//  Color Linez
//
//  Created by Mert Arıcan on 21.08.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {
    
    private var model = GameModel()
    
    private var allSquares: [Square] {
        return model.allSquares
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if gameBoardView.squaresOnBoard.count == 0 {
            gameBoardView.squaresOnBoard = allSquares
            addTapGestures() ; drawNextThreeBalls()
            getNewNextThreeBalls()
        }
    }
    
    @IBOutlet weak var nextBallsView: UIView!
    
    @IBOutlet weak var gameBoardView: GameBoardView!
    
    @objc func touchSquare(sender: UITapGestureRecognizer) {
        /* If touch location contains the ball, then deselect the last ball (if there is a selected ball)
         and select the ball in the touch location, else send the selected ball to the touched square.
         */
        let squareView = sender.view as! SquareView
        if let ball = squareView.ball {
            model.deselectBall()
            model.selectBall(ball: ball)
            updateViewFromModel()
        }
        else {
            guard model.thereIsASelectedBall else { return }
            let moveAttempt = model.moveAttempt(to: squareView.position)
            if moveAttempt.isSuccessful {
                let path = moveAttempt.path!
                animateMovementOfBall(through: path)
            } else {
                model.deselectBall()
                updateSelection()
            }
        }
    }
    
    private func updateSelection() {
        gameBoardView.squaresOnScreen.forEach { $0.ballView?.isSelected = false }
        if let selectedBall = model.selectedBall {
            let selectedPosition = model.getPosition(of: selectedBall)
            gameBoardView.getSquareView(at: selectedPosition).ballView?.isSelected = true
        }
    }
    
    private func drawNextThreeBalls() {
        let unit = nextBallsView.frame.width / 3
        for index in 0...2 {
            let x = (unit * CGFloat(index))
            let squareView = SquareView(frame: CGRect(x: x, y: 0.0, width: unit, height: unit))
            squareView.layer.borderWidth = 1.0
            squareView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            nextBallsView.addSubview(squareView)
            nextBallViews.append(squareView)
        }
    }
    
    private var nextBallViews = [SquareView]()
    
    private func getNewNextThreeBalls() {
        for (index, ball) in model.nextThreeBalls.enumerated() {
            nextBallViews[index].ball = ball
        }
    }
    
    private func updateViewFromModel() {
        updateSelection()
        for (index, squareView) in gameBoardView.squaresOnScreen.enumerated() {
            if squareView.ball != allSquares[index].ballInside {
                squareView.ball = allSquares[index].ballInside
            }
            squareView.ball?.isSelected = allSquares[index].ballInside!.isSelected
        }
        getNewNextThreeBalls()
    }
    
    private var completionHandler: (SquareView, SquareView) -> () {
        // Code block that executes after the animation
        func animateBallMovement(startingSquare: SquareView, endSquare: SquareView) {
            endSquare.ball = startingSquare.ball ; startingSquare.ball = nil
            self.model.updateBoardAfterMove()
            gameBoardView.isUserInteractionEnabled = true
            updateViewFromModel()
        }
        return animateBallMovement(startingSquare:endSquare:)
    }
    
    private func animateMovementOfBall(through positions: [Position]) {
        let startingSquare = gameBoardView.getSquareView(at: positions[0])
        let endSquare = gameBoardView.getSquareView(at: positions.last!)
        startingSquare.ballView?.isHidden = true
        let ballToAnimate = BallView(frame: startingSquare.frame) ; ballToAnimate.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        ballToAnimate.ball = model.selectedBall! ; gameBoardView.addSubview(ballToAnimate)
        var squaresThroughNewPath = [SquareView]()
        positions.forEach { squaresThroughNewPath.append(gameBoardView.getSquareView(at: $0)) }
        let locations = squaresThroughNewPath.compactMap { $0.frame }
        ballToAnimate.completionHandler = completionHandler
        gameBoardView.isUserInteractionEnabled = false
        ballToAnimate.animateBallMovement(ball: ballToAnimate, locations: locations, startingSquare: startingSquare, endSquare: endSquare)
    }
    
    private func addTapGestures() {
        for square in gameBoardView.squaresOnScreen {
            let tap = UITapGestureRecognizer(target: self, action: #selector(touchSquare(sender:)))
            square.addGestureRecognizer(tap)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
