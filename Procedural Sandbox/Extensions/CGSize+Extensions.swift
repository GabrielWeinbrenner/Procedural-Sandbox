//
//  CGSize+Extensions.swift
//  Procedural Sandbox
//
//  Created by Gabriel Weinbrenner on 4/17/24.
//

import Foundation

typealias CGOffset = CGSize
extension CGOffset {
    static func +(lhs: CGOffset, rhs: CGOffset) -> CGOffset {
        CGOffset(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    static func +=(lhs: inout CGOffset, rhs: CGOffset) {
        lhs = lhs + rhs
    }
}
