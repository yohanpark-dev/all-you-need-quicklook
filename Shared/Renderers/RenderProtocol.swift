// Shared/Renderers/RenderProtocol.swift
import Foundation

public protocol Renderer {
    func render(content: String, config: AppConfig, fileExtension: String) -> String
}
