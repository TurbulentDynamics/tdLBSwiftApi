//
//  QVecDims.swift
//  tdLBQVecTool
//
//  Created by Niall Ó Broin on 08/01/2019.
//  Copyright © 2019 Niall Ó Broin. All rights reserved.
//
import Foundation


/// This struct reads the json file that holds the meta information to read the binary files. The binary files can be written by C++ or Swift.
public struct ComputeUnitParams: Codable {
    //https://app.quicktype.io#

    public var i0: UInt64 = 0
    public var j0: UInt64 = 0
    public var k0: UInt64 = 0


}

extension ComputeUnitParams {
    public init(data: Data) throws {
        self = try newJSONDecoder().decode(ComputeUnitParams.self, from: data)
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
        i0: UInt64? = nil,
        j0: UInt64? = nil,
        k0: UInt64? = nil
    ) -> ComputeUnitParams {
        return ComputeUnitParams(
            i0: i0 ?? self.i0,
            j0: j0 ?? self.j0,
            k0: k0 ?? self.k0
        )
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
