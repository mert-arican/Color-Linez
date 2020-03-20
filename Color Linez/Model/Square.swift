//
//  Square.swift
//  cleanVersion
//
//  Created by Mert Arıcan on 5.10.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import Foundation

class Square: Equatable {
    
    init(position: Position, ballInside: Ball?) {
        self.position = position
        self.ballInside = ballInside
    }
    
    let position: Position
    
    var ballInside: Ball?
    
    static func == (lhs: Square, rhs: Square) -> Bool {
        return lhs.position == rhs.position
    }
    
}
