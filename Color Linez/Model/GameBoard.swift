//
//  GameBoard.swift
//  cleanVersion
//
//  Created by Mert Arıcan on 5.10.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import Foundation

struct GameBoard {
    
    init() {
        for row in 0...8 {
            for column in 0...8 {
                allSquares.append(Square(position: Position(column: column, row: row), ballInside: nil))
            }
        }
        for _ in 1...4 {
            getSquare(at: randomAvailablePosition).ballInside = Ball(color: Ball.Color.random)
        }
//        for pos in Constantstinopolis.pathologicalCase {
//            getSquare(at: pos).ballInside = Ball(color: Ball.Color.random)
//        }
        _ = determineNextThreeBalls()
    }
    
    private(set) var allSquares = [Square]()
    
    private var ballsOnTheBoard: [Ball] {
        return allSquares.compactMap { $0.ballInside }
    }
    
    private var randomAvailablePosition: Position {
        return allSquares.filter { $0.ballInside ==  nil }.compactMap { $0.position }.randomElement()!
    }
    
    var selectedBall: Ball? {
        return allSquares.filter { $0.ballInside?.isSelected == true }.first?.ballInside
    }
    
    func getPosition(of ball: Ball) -> Position {
        return allSquares.filter { $0.ballInside == ball }.first!.position
    }
    
    private func getSquare(at position: Position) -> Square {
        return allSquares.filter { $0.position == position }.first!
    }
    
    private mutating func determineNextThreeBalls() {
        // Determines next three balls
        var nextBalls = [Ball]()
        for _ in 1...3 {
            nextBalls.append(Ball.init(color: Ball.Color.random))
        }
        self.nextBalls = nextBalls
    }
    
    private(set) var nextBalls: [Ball]!
    
    mutating func addThreeBalls() -> [Ball] {
        // Adds three new balls to the board
        let nextBalls = self.nextBalls!
        for ballIndex in 0...2 {
            getSquare(at: randomAvailablePosition).ballInside = nextBalls[ballIndex]
        }
        determineNextThreeBalls()
        ballsOnTheBoard.forEach { $0.isSelected = false }
        return nextBalls
    }
    
    func areThereAnyMatch(recentlyAddedBall: Ball?=nil) -> (isMatch: Bool, matchedBalls: [[Ball]]) {
        // Checks if there are any match in any direction--horizontal, vertical or diagonal.
        let selectedBall = recentlyAddedBall != nil ? recentlyAddedBall : self.selectedBall
        guard ballsOnTheBoard.contains(selectedBall!) else { return (false, [[]]) }
        var matchedBalls = [[Ball]]() ; var matchResults = [Bool]()
        let ballsThatHaveSameColorWithSelectedOne = ballsOnTheBoard.filter { $0.color == selectedBall!.color }
        let diagonalLines = Position.getDiagonalLine(for: getPosition(of: selectedBall!))
        for line in diagonalLines {
            let (isMatch, matchedOnes) = thereIsDiagonalMatch(balls: ballsThatHaveSameColorWithSelectedOne, direction: line, recentlyAddedBall: recentlyAddedBall)
            if isMatch { matchedBalls.append(matchedOnes) }
            matchResults.append(isMatch)
        }
        let horizontalMatch = thereIsHorizontalMatch(balls: ballsThatHaveSameColorWithSelectedOne, recentlyAddedBall: recentlyAddedBall)
        if horizontalMatch.isMatch { matchedBalls.append(horizontalMatch.matchedBalls) }
        matchResults.append(horizontalMatch.isMatch)
        let verticalMatch = thereIsVerticalMatch(balls: ballsThatHaveSameColorWithSelectedOne, recentlyAddedBall: recentlyAddedBall)
        if verticalMatch.isMatch { matchedBalls.append(verticalMatch.matchedBalls)}
        matchResults.append(verticalMatch.isMatch)
        return (matchResults.contains(true), matchedBalls)
    }
    
    mutating func remove(matchedBalls: [Ball]) {
        allSquares.filter { $0.ballInside != nil && matchedBalls.contains($0.ballInside!) }.forEach { $0.ballInside = nil }
    }
    
    private func thereIsHorizontalMatch(balls: [Ball], recentlyAddedBall: Ball?=nil) -> (isMatch: Bool, matchedBalls: [Ball]) {
        let ball = recentlyAddedBall != nil ? recentlyAddedBall : selectedBall
        let selectedPosition = getPosition(of: ball!)
        var columnsOfSameColorBallsInSameRow = [selectedPosition.column]
        balls.filter { getPosition(of: $0).row == selectedPosition.row }.forEach { columnsOfSameColorBallsInSameRow.append(getPosition(of: $0).column) }
        var temp = [[Position]]() ; var sequence = [Position]()
        for column in 0...8 {
            if columnsOfSameColorBallsInSameRow.contains(column) {
                sequence.append(Position(column: column, row: selectedPosition.row))
            } else {
                sequence = []
            }
            temp.append(sequence)
        }
        let biggestSequence = temp.sorted { $0.count < $1.count }.last!
        let matchedBalls = biggestSequence.compactMap { getSquare(at: $0).ballInside }
        return (biggestSequence.count >= 5, matchedBalls)
    }
    
    private func thereIsVerticalMatch(balls: [Ball], recentlyAddedBall: Ball?=nil) -> (isMatch: Bool, matchedBalls: [Ball]) {
        let ball = recentlyAddedBall != nil ? recentlyAddedBall : selectedBall
        let selectedPosition = getPosition(of: ball!)
        var rowsOfSameColorBallsInSameColumn = [selectedPosition.row]
        balls.filter { getPosition(of: $0).column == selectedPosition.column }.forEach { rowsOfSameColorBallsInSameColumn.append(getPosition(of: $0).row) }
        var temp = [[Position]]() ; var sequence = [Position]()
        for row in 0...8 {
            if rowsOfSameColorBallsInSameColumn.contains(row) {
                sequence.append(Position(column: selectedPosition.column, row: row))
            } else {
                sequence = []
            }
            temp.append(sequence)
        }
        let biggestSequence = temp.sorted { $0.count < $1.count }.last!
        let matchedBalls = biggestSequence.compactMap { getSquare(at: $0).ballInside }
        return (biggestSequence.count >= 5, matchedBalls)
    }
    
    private func thereIsDiagonalMatch(balls: [Ball], direction: [Position], recentlyAddedBall: Ball?) -> (isMatch: Bool, matchedBalls: [Ball]) {
        let ball = recentlyAddedBall != nil ? recentlyAddedBall : selectedBall
        let selectedPosition = getPosition(of: ball!)
        // They had to be sorted. Realized after couple hours.
        let orderedDirections = Set(direction).sorted { $0.row < $1.row }
        var positionsOfSameColorBallsInSameDiagonalLine = [selectedPosition]
        balls.filter { direction.contains(getPosition(of: $0)) }.forEach { sed in
            positionsOfSameColorBallsInSameDiagonalLine.append(getPosition(of: sed))
        }
        var temp = [[Position]]() ; var sequence = [Position]()
        for position in orderedDirections {
            if positionsOfSameColorBallsInSameDiagonalLine.contains(position) {
                sequence.append(position)
            } else {
                sequence = []
            }
            temp.append(sequence)
        }
        let biggestSequence = temp.sorted { $0.count < $1.count }.last!
        let matchedBalls = biggestSequence.compactMap { getSquare(at: $0).ballInside }
        return (biggestSequence.count >= 5, matchedBalls)
    }
    
    func isPossibleToMove(from: Position, to: Position) -> Bool {
        var accessablePositions = [from]; var count = 0
        while count < accessablePositions.count {
            let position = accessablePositions[count]
            for neighbor in position.neighborPositions {
                if !accessablePositions.contains(neighbor) && getSquare(at: neighbor).ballInside ==  nil {
                    accessablePositions.append(neighbor)
                }
            }
            count += 1
        }
        return accessablePositions.contains(to)
    }
    
    func countChangeInDirections(of path: [Position]) -> Int {
        // Change in direction can be detected by looking at consequtive 3 positions in path.
        var count = 1
        for index in 1..<path.count-1 {
            let first = path[index-1]
            let end = path[index+1]
            if first.column != end.column && first.row != end.row {
                count += 1
            }
        }
        return count + path.count
    }
    
    mutating func moveBall(from: Position, to: Position) -> [Position] {
        // removeLast is O(1) where removeFirst is O(n) so this function is augmented A* with that implementation detail.
        let path = [from] ; var queue = [path] ; var goal_reached = from == to
        var extendedNodes = Set<Position>()
        while queue.count > 0 && !goal_reached {
            let first_path = queue.removeLast()
            let last_square = first_path.last!
            guard !extendedNodes.contains(last_square) else { goal_reached = queue.count > 0 && queue.last!.last! == to; continue }
            let availableNeighborSquares = last_square.neighborPositions.filter { self.getSquare(at: $0).ballInside == nil }.filter { (position) -> Bool in
                !first_path.contains(position)
            }
            var extended_paths = [[Position]](); extendedNodes.insert(last_square)
            availableNeighborSquares.forEach { extended_paths.append(first_path+[$0]) }
            queue = queue + extended_paths
            let minPath = queue.min { countChangeInDirections(of: $0) + Position.getDistanceBetween(position1: $0.last!, position2: to) < countChangeInDirections(of: $1) + Position.getDistanceBetween(position1: $1.last!, position2: to) }!
            let minPathIndex = queue.firstIndex(of: minPath)!
            queue.swapAt(minPathIndex, queue.indices.last!)
            goal_reached = queue.count > 0 && queue.last!.last! == to
        }
        getSquare(at: to).ballInside = getSquare(at: from).ballInside
        getSquare(at: from).ballInside = nil
        return queue.last!
    }
    
}
