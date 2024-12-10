//
//  Cache.swift
//  nooro
//
//  Created by Arturo on 12/10/24.
//

import Foundation

class Cache {
    
    private init() {}
    
    enum CacheKeys: String, CaseIterable {
        
        // The keys to use in cache to guarantee uniqueness and avoid overriding them using wrong data.
        case lastCity
        
        var type: Decodable.Type {
            switch self {
            case .lastCity: return WeatherData.self
            }
        }
        
        var fileName: String { return self.rawValue }
    }
}

extension Cache {
    
    /// Reads and decodes JSON data from a file into its corresponding Swift type.
    /// - Parameters:
    ///   - fileName: The name of the file to read from.
    ///   - fileExtension: The file extension, default is "json".
    /// - Returns: The decoded data as its Swift type if successful, nil otherwise.
    /// Usage example:
    /// ```swift
    /// if let currencies = Cache.read(fileName: Cache.CacheKeys.currencies.fileName) as? [CurrenciesModel.Currency] {
    ///    return currencies
    /// } else {
    ///    log.error("Failed to load currencies")
    ///    return []
    /// }
    /// ```
    static func read(fileName: CacheKeys, fileExtension: String = "json") -> Any? {
        let fileExists = checkIfFileExists(fileName: fileName, fileExtension: fileExtension)
        let fileName = fileName.fileName
        
        if fileExists {
            do {
                if let fileCached = Cache.CacheKeys(rawValue: fileName) {
                    guard let folderUrl = getFolderURL() else { return nil }
                    let fileUrl = folderUrl.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
                    
                    let data = try Data(contentsOf: fileUrl)
                    let finalData = try JSONDecoder().decode(fileCached.type, from: data)
                    return finalData
                } else {
                    print("The raw value doesn't match any enumeration case.")
                    return nil
                }
            } catch let error {
                return nil
            }
        } else {
            return nil
        }
    }
    
    /// Writes data to a file asynchronously, encoding it as JSON.
    /// - Parameters:
    ///   - fileName: The name of the file to write the data to.
    ///   - fileExtension: The file extension, default is "json".
    ///   - dataToStore: The data to be stored, must conform to `Encodable`.
    /// Usage example:
    /// ```swift
    /// struct User: Encodable {
    ///     var name: String
    ///     var age: Int
    /// }
    /// let userData = User(name: "John Doe", age: 30)
    /// Cache.write("userProfile", with: userData)
    /// // This saves the `userData` to a file named "userProfile.json" with current date as creation date.
    /// ```
    static func write<U: Encodable>(_ fileName: CacheKeys, fileExtension: String = "json", with dataToStore: U) {
        let fileName = fileName.fileName
        
        Task {
            let fileManager = FileManager.default
            
            do {
                guard let folderUrl = getFolderURL() else { return }
                let fileUrl = folderUrl.appendingPathComponent(fileName).appendingPathExtension(fileExtension)
                
                try JSONEncoder()
                    .encode(dataToStore)
                    .write(to: fileUrl)
                
                // Add the file attributes
                let attributes: [FileAttributeKey: Any] = [
                    FileAttributeKey.creationDate: Date.now
                ]
                try fileManager.setAttributes(attributes, ofItemAtPath: fileUrl.path)
            } catch let error {
                print("Couldn't cache \(fileName). Error: \(error.localizedDescription)")
            }
        }
    }
    
    /// Checks if a file with certain content exists already on disk
    /// - Parameters:
    ///   - path: example: nameOfFile, or /xyw/
    ///   - extention: example: json
    /// - Returns: if file exists or not
    static func checkIfFileExists(fileName: CacheKeys, fileExtension: String = "json") -> Bool {
        let fileName = fileName.fileName
        guard let folderUrl = getFolderURL() else { return false }
        let fileUrl = folderUrl.appendingPathComponent("\(fileName).\(fileExtension)")
        
        if FileManager.default.fileExists(atPath: fileUrl.path) {
            return true
        } else {
            return false
        }
    }
    
    static func getFolderURL() -> URL? {
        let fileManager = FileManager.default
        
        do {
            let appSupportUrl = try fileManager.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let folderUrl = appSupportUrl.appendingPathComponent("nooro")
            try fileManager.createDirectory(at: folderUrl, withIntermediateDirectories: true, attributes: nil)
            return folderUrl
        } catch let error {
            print("Couldn't read folder URL. Error: \(error.localizedDescription)")
            return nil
        }
    }
}
