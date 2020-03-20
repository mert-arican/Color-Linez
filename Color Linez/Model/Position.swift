//
//  Position.swift
//  cleanVersion
//
//  Created by Mert Arıcan on 5.10.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import Foundation

struct Position: Equatable, Hashable {
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.column == rhs.column && lhs.row == rhs.row
    }
    
    let column: Int
    
    let row: Int
    
    var neighborPositions : [Position] {
        // Returns the neighbor positions of a position.
        let first = Position(column: column, row: row+1)
        let second = Position(column: column, row: row-1)
        let third = Position(column: column+1, row: row)
        let fourth = Position(column: column-1, row: row)
        return [first, second, third, fourth].filter { ![-1, 9].contains($0.row) && ![-1, 9].contains($0.column) }
    }
    
    static func getDiagonalLine(for position: Position) -> [[Position]] {
        // Returns the diagonal lines (left and right diagonals) that containes the given position.
        let x = position.column ; let y = position.row ; var leftDiagonalLine = [Position]() ; var rightDiagonalLine = [Position]()
        let validRangeForRowsNColumns = 0...8
        let areas: [(name: String, increments: [Int])] = [("leftUpDiagonal", [-1, -1]), ("leftDownDiagonal", [1, 1]), ("rightUpDiagonal", [-1, 1]), ("rightDownDiagonal", [1, -1])]
        for area in areas {
            var mutatingX = x ; var mutatingY = y
            while validRangeForRowsNColumns.contains(mutatingX) && validRangeForRowsNColumns.contains(mutatingY) {
                if area.name.contains("left") {
                    leftDiagonalLine.append(Position(column: mutatingX, row: mutatingY))
                }
                else {
                    rightDiagonalLine.append(Position(column: mutatingX, row: mutatingY))
                }
                mutatingX += area.increments[0] ; mutatingY += area.increments[1]
            }
        }
        return [leftDiagonalLine, rightDiagonalLine]
    }
    
    static func getDistanceBetween(position1: Position, position2: Position) -> Int {
        let distance = sqrt((pow(Double(position1.column - position2.column), 2.0) + pow(Double(position1.row - position2.row), 2.0)))
        return Int(distance)
    }
    
}

struct Constantstinopolis {
    
    /* Moving ball at position(0,7) to position(5,3)
    takes 27098 iterations in moveBall func's while
    loop without extended list. With using extended list
    it only takes 42 iterations. */
    
    static let pathologicalCase = [
        Position(column: 1, row: 1),
        Position(column: 1, row: 2),
        Position(column: 0, row: 7),
        Position(column: 1, row: 5),
        Position(column: 2, row: 3),
        Position(column: 3, row: 4),
        Position(column: 4, row: 3),
        Position(column: 4, row: 4),
        Position(column: 5, row: 4),
        Position(column: 6, row: 4),
        Position(column: 7, row: 3),
        Position(column: 8, row: 2),
        Position(column: 7, row: 5),
        Position(column: 8, row: 5),
        Position(column: 6, row: 6),
        Position(column: 8, row: 6),
        Position(column: 3, row: 8),
        Position(column: 8, row: 8)
    ]
    
}
