//
//  Game.swift
//  Liar's Dice
//
//  Created by Robert Giesler on 10.08.22.
//

import Foundation
import SwiftUI

@MainActor
class Game: ObservableObject {
    private var dicePerPlayer: Int
    private var numPlayers: Int
    @Published var winner: Bool = false  // For displaying message in GameOverView
    @Published var roundNum: Int
    @Published var numTotalDice: Int
    @Published var dice: Set<Die>
    @Published var bidProbs: [[Double]]   /* Saves the probabilities for possible bids. bidProbs[n] = [i,p] where p is the
                                  probability that there are i dice showing the face n on the table.
                                  bidProbs[0] = [0,p] where p is the probability that the previous bid is a lie. */
    
    
    /// Game initializer
    init(numPlayers: Int, dicePerPlayer: Int = 5) {
        self.dicePerPlayer = dicePerPlayer
        self.numPlayers = numPlayers
        self.roundNum = 0
        self.numTotalDice = numPlayers * dicePerPlayer
        self.dice = Set<Die>(minimumCapacity: dicePerPlayer)
        self.bidProbs = Array(repeating: Array(repeating: 0, count: 2), count: 7)
        
        for _ in 0..<dicePerPlayer {
            let die: Die = Die()
            dice.insert(die)
        }
        
        // Initializing bidProbs for own dice
        let myDice: [Int] = getDiceValues()
        bidProbs[0] = [0, 0]
        bidProbs[1] = [Double(myDice[0]), 0]   // Starting bid on face 1 not allowed
        for i in 2..<7 {
            let n: Int = myDice[i - 1]
            if n > 0 {
                bidProbs[i] = [Double(n), 1.0]
            }
        }
        
    }
    
    
    /// Gets the current number of dice showing each face.
    ///
    /// - returns: 'Int[]' Array of length 6 where 'diceValue[x]' is the number of dice currently
    ///     showing the face 'x+1'.
    func getDiceValues() -> [Int] {
        var diceValues: [Int] = Array(repeating: 0, count: 6)
        
        for die in dice {
            diceValues[die.face.rawValue - 1] += 1
        }
        
        return diceValues
    }
    
    
    /// Calculates the probability that there are at least 'quantity' many dice of face 'face' on the table.
    ///
    /// - parameters:
    ///     - quantity: The quantity of dice bid.
    ///     - face: The face bid on.
    /// - returns: Probability as Double between 0 and 1.
    func calculateProbability(quantity: Int, face: Face) -> Double {
        let myDice: [Int] = getDiceValues()   // Saves own dice as a "Häufigkeitstupel"
        let faceValue: Int = face.rawValue
        let diceUnknown: Int = numTotalDice - dice.count   // Number of unknown dice
        let diceNeeded: Int
        
        if faceValue == 1 {
            diceNeeded = quantity - myDice[faceValue - 1]   /* Quantity that must be amongst unknown dice for
                                                               bid to be true */
        }
        else {
            diceNeeded = quantity - myDice[faceValue - 1] - myDice[0]   // Because face value 1 is a wild card
        }
        
        if diceNeeded <= 0 {
            return 1.0
        }
        if quantity > numTotalDice || diceNeeded > diceUnknown {
            return 0
        }
        
        var result: Double = 0
        // The face value == 1. Only ones are counted as the face value.
        if faceValue == 1 {
            for i in diceNeeded...diceUnknown {
                var additive: NSDecimalNumber
                if i < (diceUnknown - i) {   // For more efficient factorial calculation
                    let iFact: NSDecimalNumber = Factorials.factorial(n: i)   //i! as a NSDecimalNumber
                    additive = Factorials.factorialFrac(n: diceUnknown, m: diceUnknown - i)
                    additive = additive.multiplying(by: NSDecimalNumber(1).dividing(by: iFact))
                }
                else {
                    let niFact: NSDecimalNumber = Factorials.factorial(n: diceUnknown - i)   // (n-i)! as a NSDecimalNumber
                    additive = Factorials.factorialFrac(n: diceUnknown, m: i)
                    additive = additive.multiplying(by: NSDecimalNumber(1).dividing(by: niFact))
                }
                additive = additive.multiplying(by: NSDecimalNumber(decimal: pow(1.0/6.0, i)))
                additive = additive.multiplying(by: NSDecimalNumber(decimal: pow(5.0/6.0, diceUnknown - i)))
                
                result += additive.doubleValue
            }
        }
        // The face value is != 1. Ones must therefore also be counted as the face value.
        else {
            for i in diceNeeded...diceUnknown {
                var additive: NSDecimalNumber
                if i < (diceUnknown - i) {   // For more efficient factorial calculation
                    let iFact: NSDecimalNumber = Factorials.factorial(n: i)   //i! as a NSDecimalNumber
                    additive = Factorials.factorialFrac(n: diceUnknown, m: diceUnknown - i)
                    additive = additive.multiplying(by: NSDecimalNumber(1).dividing(by: iFact))
                }
                else {
                    let niFact: NSDecimalNumber = Factorials.factorial(n: diceUnknown - i)   // (n-i)! as a NSDecimalNumber
                    additive = Factorials.factorialFrac(n: diceUnknown, m: i)
                    additive = additive.multiplying(by: NSDecimalNumber(1).dividing(by: niFact))
                }
                additive = additive.multiplying(by: NSDecimalNumber(decimal: pow(1.0/3.0, i)))
                additive = additive.multiplying(by: NSDecimalNumber(decimal: pow(2.0/3.0, diceUnknown - i)))
                
                result += additive.doubleValue
            }
        }
        
        return result
    }
    
    
    /// Updates the Array 'bidProbs' based on current dice and a previous bid.
    /// - parameters:
    ///     - quantity: Quantity of dice bid on in the previous bid.
    ///     - face: Die face bid on in the previous bid.
    /// - throws: 'MyError.illegalArgumentError' if a quantity less than 1 is passed.
    func updateBidProbabilities(quantity: Int, face: Face) throws {
        if quantity <= 0 {
            throw MyError.illegalArgumentError("quantity must be greater than 0.")
        }
        
        let faceValue: Int = face.rawValue
        
        // Probability that the previous bid is a lie
        let lie: Double = 1 - calculateProbability(quantity: quantity, face: face)
        bidProbs[0][1] = lie
        
        // Previous bid was on face != 1
        if faceValue != 1 {
            // Probability of lowest possible bid for face == 1
            let prob1: Double = calculateProbability(quantity: Int((Double(quantity)/2.0).rounded(.up)), face: Face.One)
            bidProbs[1][0] = (Double(quantity)/2.0).rounded(.up)
            bidProbs[1][1] = prob1
            // Probabilities of lowest possible bids for all other faces
            for i in 2..<7 {
                if i > faceValue {
                    let prob: Double = calculateProbability(quantity: quantity, face: Face(rawValue: i)!)
                    bidProbs[i][0] = Double(quantity)
                    bidProbs[i][1] = prob
                }
                else {
                    let prob: Double = calculateProbability(quantity: quantity + 1, face: Face(rawValue: i)!)
                    bidProbs[i][0] = Double(quantity + 1)
                    bidProbs[i][1] = prob
                }
            }
        }
        // Previous bid was on face == 1
        else {
            // Probability of lowest possible bid for face == 1
            let prob1: Double = calculateProbability(quantity: quantity + 1, face: Face.One)
            bidProbs[1][0] = Double(quantity + 1)
            bidProbs[1][1] = prob1
            // Probabilities of lowest possible bids for all other faces
            for i in 2..<7 {
                let prob: Double = calculateProbability(quantity: quantity * 2 + 1, face: Face(rawValue: i)!)
                bidProbs[i][0] = Double(quantity * 2 + 1)
                bidProbs[i][1] = prob
            }
        }
    }
    
    
    /// Produces a bid based on the current state of bidProbs.
    ///
    /// - returns: '[i,n]' where 'i' is the face value and 'n' is the dice quantity of the bid. If 'i == 0', the previous bid is called as a lie.
    func bid() -> [Int] {
        var maxIndex = 0
        
        // Definitely call the lie when it is certain
        if (bidProbs[0][1] == 1.0) {
            return [0,0]
        }
        
        for i in 1..<7 {
            if bidProbs[i][1] > bidProbs[maxIndex][1] {
                maxIndex = i
            }
        }
        let maxProb: Double = bidProbs[maxIndex][1]
        
        // Array of all indices where prob == maxProb
        var maxIndices: [Int] = []
        for i in 0..<7 {
            if bidProbs[i][1] == maxProb {
                maxIndices.append(i)
            }
        }
        let rand: Int = Int.random(in: 0..<maxIndices.count)
        maxIndex = maxIndices[rand]   // If there are multiple bids with equal probability, a random one is chosen
        
        return [maxIndex, Int(bidProbs[maxIndex][0])]
    }
    
    
    /// Re-rolls the current dice and resets bidProbs
    func reRollDice() {
        // Re-rolling current dice
        for die in dice {
            die.roll()
        }
        
        // Resetting bidProbs for own dice
        let myDice: [Int] = getDiceValues()
        bidProbs = Array(repeating: Array(repeating: 0, count: 2), count: 7)
        bidProbs[0] = [0, 0]
        bidProbs[1] = [Double(myDice[0]), 0]   // Starting bid on face 1 not allowed
        for i in 2..<7 {
            let n: Int = myDice[i - 1]
            if n > 0 {
                bidProbs[i] = [Double(n), 1.0]
            }
        }
    }
    
    
    /// Prepares for next round by incrementing round count, decrementing total dice number, removing dice if lost,
    /// re-rolling the dice, and resetting bidProbs.
    ///
    /// - parameters:
    ///     - loseDie: Boolen whether the computer loses a die or not.
    func nextRound(loseDie: Bool) {
        roundNum += 1
        numTotalDice -= 1
        
        // Remove a die if computer lost last round
        if loseDie {
            dice.removeFirst()
        }
        
        reRollDice()
    }
    
    
    /// Resets the round number, dice, and bidProbs
    func resetGame(numPlayers: Int, dicePerPlayer: Int = 5) throws {
        
        if numPlayers <= 0 || dicePerPlayer <= 0 {
            throw MyError.illegalArgumentError("quantity must be greater than 0.")
        }
        
        self.dicePerPlayer = dicePerPlayer
        self.numPlayers = numPlayers
        self.roundNum = 0
        self.numTotalDice = numPlayers * dicePerPlayer
        self.dice = Set<Die>(minimumCapacity: dicePerPlayer)
        self.bidProbs = Array(repeating: Array(repeating: 0, count: 2), count: 7)
        
        if (dice.count > dicePerPlayer) {
            dice.removeAll()
            for _ in 0..<dicePerPlayer {
                let die: Die = Die()
                dice.insert(die)
            }
        }
        
        while (dice.count < dicePerPlayer) {
            let die: Die = Die()
            dice.insert(die)
        }
        
        // Resetting bidProbs for own dice
        let myDice: [Int] = getDiceValues()
        bidProbs[0] = [0, 0]
        bidProbs[1] = [Double(myDice[0]), 0]   // Starting bid on face 1 not allowed
        for i in 2..<7 {
            let n: Int = myDice[i - 1]
            if n > 0 {
                bidProbs[i] = [Double(n), 1.0]
            }
        }
    }
    
}
