// Tests/HTMLTemplateTests.swift
import XCTest
@testable import Shared

final class HTMLTemplateTests: XCTestCase {

    func testTemplateContainsContent() {
        let html = HTMLTemplate.wrap(body: "<p>Hello</p>", rendererType: "markdown")
        XCTAssertTrue(html.contains("<p>Hello</p>"))
    }

    func testTemplateHasDarkModeCSS() {
        let html = HTMLTemplate.wrap(body: "", rendererType: "plaintext")
        XCTAssertTrue(html.contains("prefers-color-scheme: dark"))
    }

    func testTemplateIncludesRendererTypeClass() {
        let html = HTMLTemplate.wrap(body: "", rendererType: "notebook")
        XCTAssertTrue(html.contains("class=\"notebook\""))
    }

    func testTemplateWithCustomCSS() {
        let css = "--custom-font: Menlo; --custom-size: 16px;"
        let html = HTMLTemplate.wrap(body: "<pre>test</pre>", rendererType: "plaintext", customCSS: css)
        XCTAssertTrue(html.contains(css))
    }

    func testTemplateIncludesJSLibraries() {
        let html = HTMLTemplate.wrap(body: "", rendererType: "markdown")
        XCTAssertTrue(html.contains("marked.min.js"))
        XCTAssertTrue(html.contains("highlight.min.js"))
        XCTAssertTrue(html.contains("katex.min.js"))
    }
}
