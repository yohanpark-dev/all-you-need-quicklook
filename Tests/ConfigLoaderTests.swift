// Tests/ConfigLoaderTests.swift
import XCTest
@testable import Shared

final class ConfigLoaderTests: XCTestCase {

    var tempDir: URL!

    override func setUp() {
        tempDir = FileManager.default.temporaryDirectory
            .appendingPathComponent(UUID().uuidString)
        try! FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
    }

    override func tearDown() {
        try? FileManager.default.removeItem(at: tempDir)
    }

    func testLoadDefaultConfigWhenNoFileExists() {
        let loader = ConfigLoader(containerURL: tempDir)
        let config = loader.load()
        XCTAssertEqual(config.version, 1)
        XCTAssertEqual(config.global.fontFamily, "SF Mono")
        XCTAssertEqual(config.global.fontSize, 13)
    }

    func testSaveAndLoad() throws {
        let loader = ConfigLoader(containerURL: tempDir)
        var config = AppConfig()
        config.global.fontSize = 18
        try loader.save(config)

        let loaded = loader.load()
        XCTAssertEqual(loaded.global.fontSize, 18)
    }

    func testLoadFallsBackOnCorruptFile() throws {
        let corruptPath = tempDir.appendingPathComponent("config.json")
        try "not json".write(to: corruptPath, atomically: true, encoding: .utf8)

        let loader = ConfigLoader(containerURL: tempDir)
        let config = loader.load()
        XCTAssertEqual(config.version, 1)
    }
}
