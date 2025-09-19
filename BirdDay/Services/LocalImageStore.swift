import UIKit

final class LocalImageStore {
    
    static let shared = LocalImageStore()
    
    private let directoryName = "StoredImages"
    private let fileManager = FileManager.default
    private let baseURL: URL
    
    private init() {
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        baseURL = documents.appendingPathComponent(directoryName, isDirectory: true)
        ensureDirectoryExists()
    }
    
    private func ensureDirectoryExists() {
        var isDir: ObjCBool = false
        if !fileManager.fileExists(atPath: baseURL.path, isDirectory: &isDir) || !isDir.boolValue {
            do {
                try fileManager.createDirectory(at: baseURL, withIntermediateDirectories: true)
            } catch {
                print("📁❌ Failed to create folder: \(error.localizedDescription)")
            }
        }
    }
    
    private func fileURL(for id: UUID) -> URL {
        baseURL.appendingPathComponent("\(id.uuidString).png")
    }
    
    private func fileURL(named fileName: String) -> URL {
        baseURL.appendingPathComponent(fileName)
    }
}

// MARK: - Public API
extension LocalImageStore {
    
    @discardableResult
    func save(_ image: UIImage, with id: UUID) async -> String? {
        let fileURL = fileURL(for: id)
        guard let data = image.pngData() else {
            print("📷❌ Could not encode image as PNG")
            return nil
        }
        
        do {
            try data.write(to: fileURL, options: .atomic)
            return fileURL.lastPathComponent
        } catch {
            print("💾❌ Could not save image: \(error.localizedDescription)")
            return nil
        }
    }
    
    func loadImage(named name: String) async -> UIImage? {
        let fileURL = fileURL(named: name)
        return UIImage(contentsOfFile: fileURL.path)
    }
    
    func deleteImage(with id: UUID) async {
        let fileURL = fileURL(for: id)
        guard fileManager.fileExists(atPath: fileURL.path) else { return }
        
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            print("🗑️❌ Could not delete image: \(error.localizedDescription)")
        }
    }
}
