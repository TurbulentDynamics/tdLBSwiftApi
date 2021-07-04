//
//  File.swift
//
//
//  Created by Niall Ó Broin on 30/05/2020.
//

import Foundation

public typealias Radian = Float
public typealias Degree = Float

public typealias tStep = UInt32
public typealias tNi = Int32

public struct Size3d {
    public var x, y, z: Int

    public init(x: Int, y: Int, z: Int) {
        self.x = x
        self.y = y
        self.z = z
    }
}

public enum Direction3D {
    case x, y, z
}

public struct Pos3d {
    public var i, j, k: Int

    public init(i: Int, j: Int, k: Int) {
        self.i = i
        self.j = j
        self.k = k
    }

}

public struct Size2d {
    public var cols, rows: Int

    public init(cols: Int, rows: Int) {
        self.cols = cols
        self.rows = rows
    }

}

public enum Direction2D {
    case col, row
}

public struct Pos2d {
    private var c, r: Int

    public init(c: Int, r: Int) {
        self.c = c
        self.r = r
    }
    public init(i: Int, j: Int) {
        self.c = i
        self.r = j
    }
    public init(i: Int, k: Int) {
        self.c = i
        self.r = k
    }
    public init(j: Int, k: Int) {
        self.c = k
        self.r = j
    }
}

public struct Pos2dIJ {
    public var i, j: Int

    public init(i: Int, j: Int) {
        self.i = i
        self.j = j
    }
}

public struct Pos2dIK {
    public var i, k: Int

    public init(i: Int, k: Int) {
        self.i = i
        self.k = k
    }
}

public struct Pos2dJK {
    public var j, k: Int

    public init(j: Int, k: Int) {
        self.j = j
        self.k = k
    }
}

public struct Grid {
    //Number of cells in starting resolution grid.
    let x, y, z: Int

    //Number of nodes in the starting resolution grid.
    let ngx, ngy, ngz: Int
}

public enum OrthoPlaneOrientation: CaseIterable {
    case xyPlane
    case xzPlane
    case yzPlane
}

public enum Reference {
    case relative
    case absolute
}

public enum QVecType {
    case Double
    case Single
    case Half

    public var sizeInBytes: Int {
        switch self {
        case .Double: return MemoryLayout<Double>.size
        case .Single: return MemoryLayout<Float32>.size
        case .Half: return 2
        }
    }

}
