//
//  Factorials.swift
//  Liar's Dice
//
//  Created by Robert Giesler on 09.08.22.
//

import Foundation

struct Factorials {
    
    /// Calculates n!
    ///
    /// - parameters:
    ///     - n: A non-negative `Int`
    /// - throws: `MyError.illegalArgumentError` if a negative `Int` is passed.
    /// - returns: n! as a `NSDecimalNumber`.
    static func factorial(n: Int) -> NSDecimalNumber {
        if n < 0 {   // Invalid argument
            return NSDecimalNumber(0)
        }
        
        if n < 2 {
            return NSDecimalNumber(decimal: 1)
        }
        
        var result: NSDecimalNumber = 1
        for i in 2...n {
            result = result.multiplying(by: NSDecimalNumber(decimal: Decimal(i)))
        }
        
        return result
    }
    
    
    /// Calculates n!/m!
    ///
    /// - parameters:
    ///     - n: A non-negative `Int`.
    ///     - m: A non-negative `Int`.
    /// - throws: `MyError.illegalArgumentError` if a negative `Int` is passed.
    /// - returns: n!/m! as a `NSDecimalNumber`.
    static func factorialFrac(n: Int, m: Int) -> NSDecimalNumber {
        if (n < 0 || m < 0) {   // Invalid argument
            return NSDecimalNumber(0)
        }
        
        var result: NSDecimalNumber = 1
        
        if n < m {
            var denominator: NSDecimalNumber = 1
            for i in stride(from: m, to: n, by: -1) {
                denominator = denominator.multiplying(by:
                                        NSDecimalNumber(decimal: Decimal(i)))
            }
            result = result.dividing(by: denominator)
        }
        
        else if n > m {
            for i in stride(from: n, to: m, by: -1) {
                result = result.multiplying(by:
                                        NSDecimalNumber(decimal: Decimal(i)))
            }
        }
        
        return result
    }
}
