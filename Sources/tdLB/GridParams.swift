//
//  QVecDims.swift
//  tdLBQVecTool
//
//  Created by Niall Ó Broin on 08/01/2019.
//  Copyright © 2019 Niall Ó Broin. All rights reserved.
//
import Foundation


/// This struct reads the json file that holds the meta information to read the binary files. The binary files can be written by C++ or Swift.
public struct GridParams: Codable {
    //https://app.quicktype.io#

    public var x: UInt64 = 0
    public var y: UInt64 = 0
    public var z: UInt64 = 0

    public var ngx: Int = 0
    public var ngy: Int = 0
    public var ngz: Int = 0

}

extension GridParams {
    public init(data: Data) throws {
        self = try newJSONDecoder().decode(GridParams.self, from: data)
    }

    public init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    public init(_ url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        x: UInt64? = nil,
        y: UInt64? = nil,
        z: UInt64? = nil,
        ngx: Int? = nil,
        ngy: Int? = nil,
        ngz: Int? = nil
    ) -> GridParams {
        return GridParams(
            x: x ?? self.x,
            y: y ?? self.y,
            z: z ?? self.z,
            ngx: ngx ?? self.ngx,
            ngy: ngy ?? self.ngy,
            ngz: ngz ?? self.ngz        )
    }


    public func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    public func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }

    public func writeJson(to jsonURL: URL) throws {

        let json: String = try jsonString()!

        try json.write(to: jsonURL, atomically: true, encoding: .utf8)
    }


}
