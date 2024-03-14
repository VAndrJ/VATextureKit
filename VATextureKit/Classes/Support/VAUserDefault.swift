//
//  VAUserDefault.swift
//  VATextureKit
//
//  Created by Volodymyr Andriienko on 14.03.2024.
//

import Foundation

// TODO: - Documentation
@propertyWrapper
public struct VANilableUserDefault<Value: UserDefaultValue> {
    public var wrappedValue: Value? {
        get { userDefaults.object(forKey: key) as? Value }
        set {
            if let newValue {
                userDefaults.set(newValue, forKey: key)
            } else {
                userDefaults.removeObject(forKey: key)
            }
        }
    }

    let key: String
    let userDefaults: UserDefaults

    public init(
        key: String,
        userDefaults: UserDefaults = .standard
    ) {
        self.key = key
        self.userDefaults = userDefaults
    }
}

@propertyWrapper
public struct VAUserDefault<Value: UserDefaultValue> {
    public var wrappedValue: Value {
        get { userDefaults.object(forKey: key) as? Value ?? defaultValue }
        set { userDefaults.set(newValue, forKey: key) }
    }

    let key: String
    let defaultValue: Value
    let userDefaults: UserDefaults

    public init(
        key: String,
        defaultValue: Value,
        userDefaults: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

@propertyWrapper
public struct VANilableRawUserDefault<Value: RawRepresentable> where Value.RawValue: UserDefaultValue {
    public var wrappedValue: Value? {
        get { (userDefaults.object(forKey: key) as? Value.RawValue).flatMap(Value.init(rawValue:))}
        set {
            if let newValue {
                userDefaults.set(newValue.rawValue, forKey: key)
            } else {
                userDefaults.removeObject(forKey: key)
            }
        }
    }

    let key: String
    let userDefaults: UserDefaults

    public init(
        key: String,
        userDefaults: UserDefaults = .standard
    ) {
        self.key = key
        self.userDefaults = userDefaults
    }
}

@propertyWrapper
public struct VARawUserDefault<Value: RawRepresentable> where Value.RawValue: UserDefaultValue {
    public var wrappedValue: Value {
        get { (userDefaults.object(forKey: key) as? Value.RawValue).flatMap(Value.init(rawValue:)) ?? defaultValue }
        set { userDefaults.set(newValue.rawValue, forKey: key) }
    }

    let key: String
    let defaultValue: Value
    let userDefaults: UserDefaults

    public init(
        key: String,
        defaultValue: Value,
        userDefaults: UserDefaults = .standard
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

@propertyWrapper
public struct VANilableCodableUserDefault<Value: Codable> {
    public enum CodingErrorStrategy {
        case removeValue
        case keepPrevious
    }

    public var wrappedValue: Value? {
        get { userDefaults.data(forKey: key).flatMap { try? decoder.decode(Value.self, from: $0) } }
        set {
            if let newValue {
                do {
                    userDefaults.set(try encoder.encode(newValue), forKey: key)
                } catch {
                    #if DEBUG
                    print(#file, #line, "Coding error occured: \(error.localizedDescription) with: \(String(describing: newValue))")
                    #endif
                    switch codingErrorStrategy {
                    case .removeValue:
                        userDefaults.removeObject(forKey: key)
                    case .keepPrevious:
                        break
                    }
                }
            } else {
                userDefaults.removeObject(forKey: key)
            }
        }
    }

    let key: String
    let userDefaults: UserDefaults
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    let codingErrorStrategy: CodingErrorStrategy

    public init(
        key: String,
        userDefaults: UserDefaults = .standard,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        codingErrorStrategy: CodingErrorStrategy = .removeValue
    ) {
        self.key = key
        self.userDefaults = userDefaults
        self.decoder = decoder
        self.encoder = encoder
        self.codingErrorStrategy = codingErrorStrategy
    }
}

@propertyWrapper
public struct VACodableUserDefault<Value: Codable> {
    public enum CodingErrorStrategy {
        case removeValue
        case keepPrevious
        case storeDefault
    }

    public var wrappedValue: Value {
        get { userDefaults.data(forKey: key).flatMap { try? decoder.decode(Value.self, from: $0) } ?? defaultValue }
        set {
            do {
                userDefaults.set(try encoder.encode(newValue), forKey: key)
            } catch {
                #if DEBUG
                print(#file, #line, "Coding error occured: \(error.localizedDescription) with: \(String(describing: newValue))")
                #endif
                switch codingErrorStrategy {
                case .removeValue:
                    userDefaults.removeObject(forKey: key)
                case .storeDefault:
                    userDefaults.set(defaultValue, forKey: key)
                case .keepPrevious:
                    break
                }
            }
            userDefaults.set(try? encoder.encode(newValue), forKey: key)
        }
    }

    let key: String
    let defaultValue: Value
    let userDefaults: UserDefaults
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    let codingErrorStrategy: CodingErrorStrategy

    public init(
        _ key: String,
        defaultValue: Value,
        userDefaults: UserDefaults = .standard,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        codingErrorStrategy: CodingErrorStrategy = .removeValue
    ) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
        self.decoder = decoder
        self.encoder = encoder
        self.codingErrorStrategy = codingErrorStrategy
    }
}

public protocol UserDefaultValue {}

extension Bool: UserDefaultValue {}
extension Data: UserDefaultValue {}
extension Date: UserDefaultValue {}
extension Float: UserDefaultValue {}
extension Double: UserDefaultValue {}
extension String: UserDefaultValue {}
extension Int: UserDefaultValue {}
extension Int8: UserDefaultValue {}
extension Int16: UserDefaultValue {}
extension Int32: UserDefaultValue {}
extension Int64: UserDefaultValue {}
extension UInt: UserDefaultValue {}
extension UInt8: UserDefaultValue {}
extension UInt16: UserDefaultValue {}
extension UInt32: UserDefaultValue {}
extension UInt64: UserDefaultValue {}
extension NSData: UserDefaultValue {}
extension NSDate: UserDefaultValue {}
extension NSString: UserDefaultValue {}
extension NSNumber: UserDefaultValue {}
extension Array: UserDefaultValue where Element: UserDefaultValue {}
extension Dictionary: UserDefaultValue where Key == String, Value: UserDefaultValue {}
