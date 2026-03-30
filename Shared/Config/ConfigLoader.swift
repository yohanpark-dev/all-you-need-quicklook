// Shared/Config/ConfigLoader.swift
import Foundation

public final class ConfigLoader: Sendable {
    private let containerURL: URL
    private let configFileName = "config.json"

    public init(containerURL: URL) {
        self.containerURL = containerURL
    }

    public convenience init() {
        let groupURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.yohanpark.AllYouNeedQuickLook"
        ) ?? FileManager.default.temporaryDirectory
        self.init(containerURL: groupURL)
    }

    private var configFileURL: URL {
        containerURL.appendingPathComponent(configFileName)
    }

    public func load() -> AppConfig {
        guard FileManager.default.fileExists(atPath: configFileURL.path) else {
            return loadBundledDefault()
        }
        do {
            let data = try Data(contentsOf: configFileURL)
            return try JSONDecoder().decode(AppConfig.self, from: data)
        } catch {
            return loadBundledDefault()
        }
    }

    public func save(_ config: AppConfig) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = try encoder.encode(config)
        try data.write(to: configFileURL, options: .atomic)
    }

    private func loadBundledDefault() -> AppConfig {
        guard let url = Bundle(for: Self.self).url(forResource: "default-config", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let config = try? JSONDecoder().decode(AppConfig.self, from: data)
        else {
            return AppConfig()
        }
        return config
    }
}
