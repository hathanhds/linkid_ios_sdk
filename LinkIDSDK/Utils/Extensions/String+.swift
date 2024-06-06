//
//  String+.swift
//  LinkIDApp
//
//  Created by ThanhNTH on 11/03/2024.
//

import Foundation

extension String {
    func containsAlphabetLetters() -> Bool {
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
        return self.rangeOfCharacter(from: set) != nil
    }

    func containsLowercaseLetter() -> Bool {
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz")
        return self.rangeOfCharacter(from: set) != nil
    }

    func containsUppercaseLetter() -> Bool {
        let set = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        return self.rangeOfCharacter(from: set) != nil
    }

    func containsAtLeastOne(from string: String) -> Bool {
        let set = CharacterSet(charactersIn: string)
        return self.rangeOfCharacter(from: set) != nil
    }

    func containsNumbers() -> Bool {
        return self.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil
    }

    func containsSpecialCharacters(exceptions: [String] = []) -> Bool {
        guard self.count > 0 else { return false }
        var text = self
        exceptions.forEach({ text = text.replacingOccurrences(of: $0, with: "") })
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            return regex.firstMatch(in: text, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, text.count)) != nil
        } catch {
            debugPrint(error.localizedDescription)
        }
        return false
    }
}

extension String {
    func currencyFomatter() -> String {
        var amountWithPrefix = self
        if (amountWithPrefix.isEmpty) {
            return ""
        }
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        let double = (amountWithPrefix as NSString).doubleValue
        return double.formatter()
    }

    func phoneNumberFormatter() -> String {
        return self.applyPatternOnNumbers(pattern: "#### ### ### ###", replacmentCharacter: "#")
    }

    func applyPatternOnNumbers(pattern: String, replacmentCharacter: Character) -> String {
        var pureNumber = self.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        for index in 0 ..< pattern.count {
            guard index < pureNumber.count else { return pureNumber }
            let stringIndex = String.Index(utf16Offset: index, in: pattern)
            let patternCharacter = pattern[stringIndex]
            guard patternCharacter != replacmentCharacter else { continue }
            pureNumber.insert(patternCharacter, at: stringIndex)
        }
        return pureNumber
    }

    func formatVietnamesePhoneNumber() -> String {
        let digits = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let number = digits.removeLeadingZeros()
        if number.hasPrefix("84") {
            return "+84" + String(number.dropFirst(2))
        } else if number.hasPrefix("+84") {
            return number
        } else {
            return "+84" + number
        }
    }

    func removeLeadingZeros() -> String {
        var result = self
        while result.hasPrefix("0") && result.count > 1 {
            result = String(result.dropFirst())
        }
        return result
    }

    func maskedString() -> String {
        return "*** *** " + self.suffix(4)
    }

}
