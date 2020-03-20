//
//  GameModel.swift
//  cleanVersion
//
//  Created by Mert Arıcan on 5.10.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import Foundation

struct GameModel {
    
    private var gameBoard = GameBoard()
    
    private var recentlyAddedBalls: [Ball]?
    
    var selectedBall: Ball? {
        return gameBoard.selectedBall
    }
    
    func getPosition(of ball: Ball) -> Position {
        return gameBoard.getPosition(of: ball)
    }
    
    var thereIsASelectedBall: Bool {
        return selectedBall != nil
    }
    
    var allSquares: [Square] {
        return gameBoard.allSquares
    }
    
    var nextThreeBalls: [Ball] {
        return gameBoard.nextBalls
    }
    
    mutating func moveAttempt(to position: Position) -> (isSuccessful: Bool, path: [Position]?) {
        guard selectedBall != nil else { return (false, nil) }
        let startingPosition = gameBoard.getPosition(of: selectedBall!)
        if !gameBoard.isPossibleToMove(from: startingPosition, to: position) { return (false, nil) }
        let pathThroughNewPosition = gameBoard.moveBall(from: startingPosition, to: position)
        return (true, pathThroughNewPosition)
    }
    
    func selectBall(ball: Ball) {
        ball.isSelected = true
    }
    
    func deselectBall() {
        selectedBall?.isSelected = false
    }
    
    mutating func updateBoardAfterMove(recentlyAddedBall: Ball?=nil) {
        /* Updates the board after move. If there is a match, then it is going to remove the matched ones. If there is
         no match, it is going to add three new balls and also check if there is a match with any one of the recently added three.
         */
        let resultAfterMove = gameBoard.areThereAnyMatch(recentlyAddedBall: recentlyAddedBall)
        if resultAfterMove.isMatch {
            resultAfterMove.matchedBalls.forEach {
                gameBoard.remove(matchedBalls: $0)
            }
        } else if recentlyAddedBall == nil {
            recentlyAddedBalls = gameBoard.addThreeBalls()
            if let balls = recentlyAddedBalls {
                recentlyAddedBalls = nil
                for ball in balls {
                    updateBoardAfterMove(recentlyAddedBall: ball)
                }
            }
        }
        deselectBall()
    }
    
}
