//
//  QVecDims.swift
//  tdLBQVecTool
//
//  Created by Niall Ó Broin on 08/01/2019.
//  Copyright © 2019 Niall Ó Broin. All rights reserved.
//
import Foundation

/// This struct reads the json file that holds the meta information to read the binary files. The binary files can be written by C++ or Swift.
///
public struct BinFileParams: Codable {
    //https://app.quicktype.io#

    public let name, note, structName: String

    public let qDataType: String
    public let qOutputLength: Int
    public let binFileSizeInStructs: UInt64
    public let coordsType: String
    public let filePath: String
    public let hasColRowtCoords, hasGridtCoords: Bool

    public let reference: String
    public let i0, j0, k0: UInt64

    enum CodingKeys: String, CodingKey {
        case qDataType = "QDataType"
        case qOutputLength = "QOutputLength"
        case binFileSizeInStructs, coordsType, filePath, hasColRowtCoords, hasGridtCoords, name, note, structName, reference, i0, j0, k0
    }

}

extension BinFileParams {
    public init(data: Data) throws {
        self = try newJSONDecoder().decode(BinFileParams.self, from: data)
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


//    func with(
//        qDataType: String? = nil,
//        qOutputLength: Int? = nil,
//        binFileSizeInStructs: UInt64? = nil,
//        coordsType: String? = nil,
//        filePath: String? = nil,
//        hasColRowtCoords: Bool? = nil,
//        hasGridtCoords: Bool? = nil,
//        name: String? = nil,
//        note: String? = nil,
//        structName: String? = nil,
//        reference: String? = nil,
//        i0: UInt64? = nil,
//        j0: UInt64? = nil,
//        k0: UInt64? = nil
//    ) -> BinFileParams {
//        return BinFileParams(
//            qDataType: qDataType ?? self.qDataType,
//            qOutputLength: qOutputLength ?? self.qOutputLength,
//            binFileSizeInStructs: binFileSizeInStructs ?? self.binFileSizeInStructs,
//            coordsType: coordsType ?? self.coordsType,
//            filePath: filePath ?? self.filePath,
//            hasColRowtCoords: hasColRowtCoords ?? self.hasColRowtCoords,
//            hasGridtCoords: hasGridtCoords ?? self.hasGridtCoords,
//            name: name ?? self.name,
//            note: note ?? self.note,
//            structName: structName ?? self.structName,
//            reference: reference ?? self.reference,
//            i0: i0 ?? self.i0,
//            j0: j0 ?? self.j0,
//            k0: k0 ?? self.k0
//        )
//    }


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

    public var coordsTypeString: String {

        //TODO Complete or replace
        if coordsType == "uint16_t" {
            return "UInt16"
        }
        if coordsType == "uint32_t" {
            return "UInt32"
        }
        if coordsType == "uint64_t" {
            return "UInt64"
        }
        else if coordsType == "Int" {
            fatalError("Cannot determine size of type Int, could be 32 or 64 bits.")

        }
        else {
            return coordsType
        }

    }

    public var sizeColRowTypeInBytes: Int {

        //        if ["UInt8", "Int8"].contains(coordsType) {
        //            return 1

        if ["UInt16", "Int16", "uint16_t"].contains(coordsType) {
            return 2

        }
        else if ["UInt32", "Int32"].contains(coordsType) {
            return 4

        } else if ["UInt64", "Int64"].contains(coordsType) {
            return 8

        }
        else if coordsType == "Int" {
            fatalError("Cannot determine size of type Int, could be 32 or 64 bits.")

        }
        else {
            fatalError("Cannot determine size of type \(coordsType)")
        }
    }

    public func typeOfColRow() -> AnyObject {
        switch coordsType {
        //            case "Int8":
        //                return Int8.self as AnyObject
        case "UInt16":
            return UInt16.self as AnyObject
        case "UInt32":
            return UInt32.self as AnyObject
        case "UInt64":
            return UInt64.self as AnyObject        //            case "Int64":
        //                return Int64.self as AnyObject
        default:
            fatalError("Cannot determine size of type \(coordsType)")
        }
    }

    public var byteOffsetColRow: Int {
        return 0
    }

    ///Grid and ColRow use the same Type
    public var sizeGridTypeInBytes: Int {
        return sizeColRowTypeInBytes
    }

    public var byteOffsetGrid: Int {
        if hasColRowtCoords {
            return sizeColRowTypeInBytes * 2
        }
        else {
            return 0
        }
    }

    public var qDataTypeString: String {
        if ["Float16", "float16", "half"].contains(qDataType) {
            return "Half"

        }
        else if ["Float32", "float32", "Float", "float"].contains(qDataType) {
            return "Float"

        }
        else if ["Float64", "float64", "Double", "double"].contains(qDataType) {
            return "Double"

        }
        else {
            fatalError("Cannot determine type of \(qDataType)")
        }
    }

    public var sizeQTypeInBytes: Int {
        if ["Float16", "float16", "half"].contains(qDataType) {
            return 2

        }
        else if ["Float32", "float32", "Float", "float"].contains(qDataType) {
            return 4

        }
        else if ["Float64", "float64", "Double", "double"].contains(qDataType) {
            return 8

        }
        else {
            fatalError("Cannot determine size of type \(qDataType)")
        }
    }

    public var byteOffsetQVec: Int {
        if hasColRowtCoords && !hasGridtCoords {
            return sizeColRowTypeInBytes * 2
        }
        else if !hasColRowtCoords && hasGridtCoords {
            return sizeGridTypeInBytes * 3
        }
        else {
            return sizeColRowTypeInBytes * 2 + sizeGridTypeInBytes * 3
        }
    }

    public var sizeStructInBytes: Int {
        return byteOffsetQVec + sizeQTypeInBytes * qOutputLength
    }

    public func printMe() {
        print("HasColRow \(hasColRowtCoords), Type \(coordsType), sizeInBytes \(sizeColRowTypeInBytes)")
        print("HasGridtCoords \(hasGridtCoords), Type \(coordsType), sizeInBytes, \(sizeGridTypeInBytes)")
        print("QLen \(qOutputLength), Type \(qDataType) sizeInBytes \(sizeQTypeInBytes)")

        //        print("Total size of Grid in xyz:  \(gridX) \(gridY) \(gridZ)")
        //        print("Total number of Nodes in xyz: \(ngx) \(ngy) \(ngz)")
        //        print("Node id in ijk: \(idi) \(idj) \(idk)")
        //        print("Node start position: \(x0) \(y0) \(z0)")

    }

}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
