//
//  LB.swift
//
//
//  Created by Niall Ó Broin on 01/07/2020.
//

import Foundation

//import Numerics

///Represented by Real for testing, in reality always BinaryFloatingPoint
//struct ComputeUnit<TQ: Real> {
public struct ComputeUnit<TQ: BinaryFloatingPoint> {
    public var x: Int
    public var y: Int
    public var z: Int
    public var i0: Int
    public var j0: Int
    public var k0: Int
    public var qLen: QLen

    public var Q: [[[QVec<TQ>]]]
    public var F: [[[Force<TQ>]]]
    public var 𝜈: [[[TQ]]]
    public var O: [[[Bool]]]

    var outputTree: DiskOutputTree

    init(outputTree: DiskOutputTree, withQVec initial: QVec<TQ>, x: Int, y: Int, z: Int, i0: Int, j0: Int, k0: Int, qLen: QLen) {
        self.x = x
        self.y = y
        self.z = z
        self.i0 = i0
        self.j0 = j0
        self.k0 = k0
        self.qLen = qLen
        self.outputTree = outputTree

        Q = Array(repeating: Array(repeating: Array(repeating: initial, count: z), count: y), count: x)
        F = Array(repeating: Array(repeating: Array(repeating: Force(x: 0, y: 0, z: 0), count: z), count: y), count: x)
        𝜈 = Array(repeating: Array(repeating: Array(repeating: 0, count: z), count: y), count: x)
        O = Array(repeating: Array(repeating: Array(repeating: false, count: z), count: y), count: x)
    }

    init(outputTree: DiskOutputTree, with initialVal: TQ, x: Int, y: Int, z: Int, i0: Int, j0: Int, k0: Int, qLen: QLen) {
        self.x = x
        self.y = y
        self.z = z
        self.i0 = i0
        self.j0 = j0
        self.k0 = k0
        self.qLen = qLen
        self.outputTree = outputTree

        let initialQ = QVec<TQ>(with: initialVal, qLen: qLen)

        Q = Array(repeating: Array(repeating: Array(repeating: initialQ, count: z), count: y), count: x)
        F = Array(repeating: Array(repeating: Array(repeating: Force(x: 0, y: 0, z: 0), count: z), count: y), count: x)
        𝜈 = Array(repeating: Array(repeating: Array(repeating: 0, count: z), count: y), count: x)
        O = Array(repeating: Array(repeating: Array(repeating: false, count: z), count: y), count: x)

    }

    //    init(x: Int, y:Int, z:Int, qLen: QLen) {
    //        self.init(with: 0, x:x, y:y, z:z, qLen:qLen)
    //    }

    ///Sets up the LB Matrix with some dummy test data
    mutating func setPositionalDataForTesting() {

        for i in 0..<x {
            for j in 0..<y {
                for k in 0..<z {

                    let o = TQ(i * 10000 + j * 1000 + k * 100)

                    let q: [TQ] = (0..<qLen.rawValue).indices.map { o + TQ($0) / 100.0 }

                    //                    u.append(contentsOf: stride(from: 0, to: TQ(qLen.rawValue), by: 1))
                    //
                    //                    grid[i][j][k].q = u.map({o + $0})

                    self.Q[i][j][k].q = q

                }
            }
        }
    }

}
