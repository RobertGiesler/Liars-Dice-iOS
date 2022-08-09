//
//  Factorials.swift
//  Liar's Dice
//
//  Created by Robert Giesler on 09.08.22.
//

import Foundation

class Factorials {
    
    static func factorial(n: Int) throws -> NSDecimalNumber {
        if n < 0 {
            throw MyError.illegalArgumentError("""
                Factorials can only be calculated for non-negative integers.
            """)
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
    
    
    static func factorialFrac(n: Int, m: Int) throws -> NSDecimalNumber {
        if (n < 0 || m < 0) {
            throw MyError.illegalArgumentError("""
                Factorials can only be calculated for non-negative integers.
            """)
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
