// Tests/ConfigSchemaTests.swift
import XCTest
@testable import Shared

final class ConfigSchemaTests: XCTestCase {

    func testDecodeFullConfig() throws {
        let json = """
        {
            "version": 1,
            "global": {
                "fontFamily": "SF Mono",
                "fontSize": 13,
                "lineHeight": 1.5,
                "showLineNumbers": true,
                "imageTimeoutSeconds": 3
            },
            "fileTypes": {
                "log": {
                    "syntaxHighlight": true,
                    "logLevelPatterns": {
                        "error": "\\\\b(ERROR)\\\\b",
                        "warn": "\\\\b(WARN)\\\\b"
                    }
                }
            }
        }
        """.data(using: .utf8)!

        let config = try JSONDecoder().decode(AppConfig.self, from: json)
        XCTAssertEqual(config.version, 1)
        XCTAssertEqual(config.global.fontFamily, "SF Mono")
        XCTAssertEqual(config.global.fontSize, 13)
        XCTAssertEqual(config.fileTypes?["log"]?.syntaxHighlight, true)
        XCTAssertEqual(config.fileTypes?["log"]?.logLevelPatterns?["error"], "\\b(ERROR)\\b")
    }

    func testNullFieldsInheritFromGlobal() throws {
        let global = GlobalConfig(
            fontFamily: "SF Mono",
            fontSize: 13,
            lineHeight: 1.5,
            showLineNumbers: true,
            imageTimeoutSeconds: 3
        )
        let fileType = FileTypeConfig(
            fontFamily: nil,
            fontSize: 16,
            lineHeight: nil,
            showLineNumbers: nil,
            syntaxHighlight: nil,
            syntaxLanguage: nil,
            logLevelPatterns: nil
        )
        let resolved = fileType.resolved(with: global)
        XCTAssertEqual(resolved.fontFamily, "SF Mono")
        XCTAssertEqual(resolved.fontSize, 16)
        XCTAssertEqual(resolved.lineHeight, 1.5)
        XCTAssertEqual(resolved.showLineNumbers, true)
    }

    func testEncodeRoundTrip() throws {
        let config = AppConfig(
            version: 1,
            global: GlobalConfig(
                fontFamily: "Menlo",
                fontSize: 14,
                lineHeight: 1.6,
                showLineNumbers: false,
                imageTimeoutSeconds: 5
            ),
            fileTypes: nil
        )
        let data = try JSONEncoder().encode(config)
        let decoded = try JSONDecoder().decode(AppConfig.self, from: data)
        XCTAssertEqual(decoded.global.fontFamily, "Menlo")
        XCTAssertEqual(decoded.global.imageTimeoutSeconds, 5)
    }
}
