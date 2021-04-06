//
//  InputFilesV4URLTests.swift
//  tdQVecTool
//
//  Created by Niall Ó Broin on 15/10/2019.
//

import XCTest
@testable import tdLBOutput

class OutputDirTests: XCTestCase {

    let fm = FileManager.default
    var testRootDir:String = ""
    var testRootDirURL: URL!

    var isDirectory = ObjCBool(true)

    let testDirStrings = [
        "plot.XYplane.V5.step_00000010.cut_10",
        "plot.XZplane.V5.step_00000010.cut_10",
        "plot.XZplane.V5.step_00000010.cut_11",
        "plot.XZplane.V5.step_00000010.cut_12",
        "plot.XZplane.V5.step_00000020.cut_10",
        "plot.XZplane.V5.step_00000020.cut_11",
        "plot.XZplane.V5.step_00000020.cut_12",
        "plot.YZplane.V5.step_00000010.cut_10"
    ]
    var testDirURLs = [URL]()

    
    override func setUp() {
        super.setUp()
        testRootDir = fm.currentDirectoryPath + "/testRootDir"
        testRootDirURL = URL(fileURLWithPath: testRootDir, isDirectory: true)

        //Ensure testRootDir does not exist
        do {
            try fm.removeItem(at: URL(fileURLWithPath: testRootDir))
        } catch {
            //Item probably didnt exist
        }

        testDirURLs = testDirStrings.map{ testRootDirURL.appendingPathComponent($0, isDirectory: true) }
    }

    override func tearDown() {
        super.tearDown()
        do {
            try fm.removeItem(at: URL(fileURLWithPath: testRootDir))
        } catch {
            //Some tests failed and Dir was not created
        }
    }



    // TODO: ERROR
    func testOutputDirInitWhenDirExists() {
        let o = try! OutputDir(rootDir: testRootDir)
        XCTAssertEqual(testRootDir, o.root.path)
    }

    func testOutputDirIsCreated() {
        let _ = try! OutputDir(rootDir: testRootDir, createDir: true)
        XCTAssert(fm.fileExists(atPath: testRootDir))
        XCTAssert(fm.fileExists(atPath: testRootDir, isDirectory: &isDirectory))
    }

    func testOutputDirCannotBeCreatedDueToPermissions() {
        // TODO
        //            XCTAssertThrowsError
    }




    func testPlotFormattedAndCreatedXYPlane() {

        let outDir = try! OutputDir(rootDir: testRootDir, createDir: true)


        let xyString = outDir.formatXYPlane(step: 10, atK:10)

        XCTAssertEqual(xyString, testDirStrings[0])

        let xyPlotDir = outDir.createXYPlane(step: 10, atK:10)
        XCTAssert(fm.fileExists(atPath: xyPlotDir.path, isDirectory: &isDirectory))
    }


    func testPlotFormattedAndCreatedXZPlane() {
        let outDir = try! OutputDir(rootDir: testRootDir, createDir: true)

        let xzString = outDir.formatXZPlane(step: 10, atJ:10)
        XCTAssertEqual(xzString, testDirStrings[1])

        let xzPlotDir = outDir.createXZPlane(step: 10, atJ:10)
        XCTAssert(fm.fileExists(atPath: xzPlotDir.path, isDirectory: &isDirectory))

    }

    func testPlotFormattedAndCreatedYZPlane() {
        let outDir = try! OutputDir(rootDir: testRootDir, createDir: true)

        let yzString = outDir.formatYZPlane(step: 10, atI:10)
        XCTAssertEqual(yzString, testDirStrings[2])

        let yzPlotDir = outDir.createYZPlane(step: 10, atI:10)
        XCTAssert(fm.fileExists(atPath: yzPlotDir.path, isDirectory: &isDirectory))

    }




    func testFindPlotDirs() {
        let outDir = try! OutputDir(rootDir: testRootDir, createDir: true)


        let _ = outDir.createXYPlane(step: 10, atK:10)
        let _ = outDir.createXZPlane(step: 10, atJ:10)
        let _ = outDir.createYZPlane(step: 10, atI:10)


        let dirs:[URL] = outDir.plotDirs()
        XCTAssertEqual(dirs, testDirURLs)




        let dirsXY = outDir.plotDirs(withKind: .XYplane)
        let dirsXZ = outDir.plotDirs(withKind: .XZplane)
        let dirsYZ = outDir.plotDirs(withKind: .YZplane)


        XCTAssertEqual(dirsXY, [testDirURLs[0]])
        XCTAssertEqual(dirsXZ, [testDirURLs[1]])
        XCTAssertEqual(dirsYZ, [testDirURLs[2]])



    }


}
