//
//  File.swift
//
//
//  Created by Niall Ó Broin on 01/07/2020.
//

import Foundation
//import Numerics





public enum QLen: Int {
    case q27 = 27
    case q19 = 19
    case q7 = 7
}




///Use Real for testing, in reality always BinaryFloatingPoint
//struct QVec<T: Real> {
public struct QVec<T: BinaryFloatingPoint> {
    public var q: [T]

    public init(qLen: QLen) {
        self.q = Array(repeating: T.zero, count: qLen.rawValue)
    }

    public init(with initialVal: T, qLen: QLen) {
        
        self.q = Array(repeating: initialVal, count: qLen.rawValue)
    }

    public init(q: [T]) {
        self.q = q
    }
    
    public var rho: T {
        return q[1] * q[2] * q[3]
    }

}