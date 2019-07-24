//
//  LevelDB.swift
//  LevelDBForSwift
//
//  Created by Leo on 2017/3/24.
//  Copyright © 2017年 Binea. All rights reserved.
//

import Foundation

open class LevelDB {
    
    public private(set) var db: UnsafeMutableRawPointer?
    
    public init(filePath: String) {
        var cChar: [CChar] = [CChar].init(repeating: 0, count: 2048)
        _ = filePath.getCString(&cChar, maxLength: 2048, encoding: .utf8)
        self.db = c_creatLeveldb(&cChar)
    }
    
    public convenience init(name: String) {
        let filePath = NSHomeDirectory() + "/Documents/" + name
        let fMgr: FileManager = FileManager()
        let lockFilePath = filePath + "/LOCK"
        if (!fMgr.fileExists(atPath: lockFilePath)) {
            try? fMgr.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
        }

        self.init(filePath: filePath)
    }
    
    public subscript(key: String) -> String? {
        get {
            guard let db = self.db else {
                return nil
            }
            guard var keyChar: [CChar] = key.cString(using: .utf8) else {
                return nil
            }
            var keyCstring = _CString_(basePtr: &keyChar, length: keyChar.count)
            var valueString = c_leveldbGetValue(db, &keyCstring)
            let string = String.init(cString: valueString.basePtr)
            c_FreeCString(&valueString)
            return string
        }
        set {
            guard let db = self.db else {
                return
            }
            guard var keyChar: [CChar] = key.cString(using: .utf8) else {
                return
            }
            let keyCstring = _CString_(basePtr: &keyChar, length: keyChar.count)
            
            guard var valueChar: [CChar] = newValue?.cString(using: .utf8) else {
                c_leveldbDeleteValue(db, keyCstring);
                return
            }
            let valueCstring = _CString_(basePtr: &valueChar, length: valueChar.count)
            c_leveldbSetValue(db, keyCstring, valueCstring)
        }
    }
    
    private func closeDB() {
        if let db = self.db {
            c_closeLeveldb(db)
        }
    }
}

public extension LevelDB {
    
    //MARK: - Public methods
    func delete(key: String) -> Bool {
        guard let db = self.db else {
            return false
        }
        guard var keyChar: [CChar] = key.cString(using: .utf8) else {
            return false
        }
        let keyCstring = _CString_(basePtr: &keyChar, length: keyChar.count)
        return c_leveldbDeleteValue(db, keyCstring)
    }
    
    func collectKeys(offset: Int) -> [String] {
        var keys: [String] = []
        
        guard let db = self.db else {
            return []
        }
        
        let limit = Int(c_batchSize())
        let offset = Int32(offset)
        if let items = c_leveldbGetValues(db, offset) {
            let buffer = UnsafeBufferPointer(start: items, count: limit)
            for i in 0..<buffer.count {
                var pointer = buffer[i]
                if let basePointer = pointer.basePtr {
                    if let key = String(cString: basePointer, encoding: .utf8), !key.isEmpty {
                        keys.append(key)
                        c_FreeCString(&pointer)
                    }
                }
            }
        }
        return keys
    }
    
    func close() {
        self.closeDB()
    }
    
    //MARK: - String
    private func set(_ value: String, forKey key: String) {
        guard let db = self.db else {
            return
        }
        guard var keyChar: [CChar] = key.cString(using: .utf8), var valueChar: [CChar] = value.cString(using: .utf8) else {
            return
        }
        
        let keyCstring = _CString_(basePtr: &keyChar, length: keyChar.count)
        let valueCstring = _CString_(basePtr: &valueChar, length: valueChar.count)
        c_leveldbSetValue(db, keyCstring, valueCstring)
    }
    
    private func getString(forKey key: String) -> String? {
        guard let db = self.db else {
            return nil
        }
        guard var keyChar: [CChar] = key.cString(using: .utf8) else {
            return nil
        }
        var keyCstring = _CString_(basePtr: &keyChar, length: keyChar.count)
        var valueString = c_leveldbGetValue(db, &keyCstring)
        let value = String(cString: valueString.basePtr)
        c_FreeCString(&valueString)
        return value
    }
    
    //MARK: - Data
    private func set(_ value: Data, forKey key: String) {
        guard let db = self.db else {
            return
        }
        guard var keyChar: [CChar] = key.cString(using: .utf8) else {
            return
        }
        
        let basePointer = UnsafeMutablePointer<Int8>.allocate(capacity: value.count)
        basePointer.initialize(repeating: 0, count: value.count)
        let pointer = UnsafeMutableBufferPointer<Int8>.init(start: basePointer, count: value.count)
        _ = value.copyBytes(to: pointer)
        let keyCstring = _CString_(basePtr: &keyChar, length: keyChar.count)
        let valueCstring = _CString_(basePtr: pointer.baseAddress, length: pointer.count)
        c_leveldbSetValue(db, keyCstring, valueCstring)
        basePointer.deallocate()
    }
    
    private func getData(forKey key: String) -> Data? {
        guard let db = self.db else {
            return nil
        }
        guard var keyChar: [CChar] = key.cString(using: .utf8) else {
            return nil
        }
        var keyCstring = _CString_(basePtr: &keyChar, length: keyChar.count)
        var valueString = c_leveldbGetValue(db, &keyCstring)
        let data = Data.init(bytes: valueString.basePtr, count: valueString.length)
        c_FreeCString(&valueString)
        return data
    }
    
    //MARK: - Int
    private func set(_ value: Int?, forKey key: String) {
        if let value = value {
            self[key] = "\(value)"
        } else {
            self[key] = nil
        }
    }
    
    private func getInt(forKey key: String) -> Int? {
        if let value = self[key] {
            return Int(value)
        }
        return nil
    }
    
    //MARK: - Float
    private func set(_ value: Float?, forKey key: String) {
        if let value = value {
            self[key] = "\(value)"
        } else {
            self[key] = nil
        }
    }
    
    private func getFloat(forKey key: String) -> Float? {
        if let value = self[key] {
            return Float(value)
        }
        return nil
    }
    
    //MARK: - Date
    private func set(_ value: Date?, forKey key: String) {
        if let value = value {
            self[key] = "\(value.timeIntervalSince1970)"
        } else {
            self[key] = nil
        }
    }
    
    private func getDate(forKey key: String) -> Date? {
        if let value = self[key], let time = TimeInterval(value) {
            return Date.init(timeIntervalSince1970: time)
        }
        return nil
    }
}




