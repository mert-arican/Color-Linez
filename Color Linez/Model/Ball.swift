//
//  Ball.swift
//  cleanVersion
//
//  Created by Mert Arıcan on 5.10.2019.
//  Copyright © 2019 Mert Arıcan. All rights reserved.
//

import Foundation

class Ball: Equatable, CustomStringConvertible {
    
    internal var description: String {
        return "\(color)" + "\(hashValue)"
    }
    
    enum Color {
        
        case red
        case blue
        case yellow
        case brown
        case green
        case pink
        
        static var random: Color {
            return [.red, .blue, .yellow, .brown, .green, .pink].randomElement()!
        }
        
    }
    
    init(color: Color) {
        hashValue = Ball.getUniqueIdentifier()
        self.color = color ; isSelected = false
    }
    
    private static var uniqueIdentifier = 0
    
    private static func getUniqueIdentifier() -> Int {
        uniqueIdentifier += 1
        return uniqueIdentifier
    }
    
    private var hashValue: Int
    
    static func == (lhs: Ball, rhs: Ball) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
    
    let color: Color
    
    var isSelected = false
    
}
