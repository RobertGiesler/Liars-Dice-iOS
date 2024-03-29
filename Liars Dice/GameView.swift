//
//  GameView.swift
//  Liar's Dice
//
//  Created by Robert Giesler on 11.08.22.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var game: Game
    
    @State private var currentBid: [Int] = [-1,0]
    @State private var numPreviousBid: Int = 1
    @State private var facePreviousBid: Face? = nil
    @State private var negativeNumAlert: Bool = false
    
    @FocusState private var numFocus: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button() {
                    viewRouter.currentPage = .menuPage
                } label: {
                    Image(systemName: "house")
                }
                .padding(.horizontal, 30)
            }
            
            Spacer()
            
            Text("My bid")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            ZStack {
                Rectangle()
                    .frame(height: 120)
                    .cornerRadius(15)
                    .padding([.leading, .trailing], 60.0)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .opacity(0.1)
                
                getBidView(bid: currentBid)
            }
            .frame(maxWidth: 600)
            
            Text("Previous bid")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom)
            
            VStack(alignment: .leading) {
                Text("Number of dice")
                    .font(.subheadline)
                    .padding(.bottom)
                    
                VStack {
                    Text("\(numPreviousBid)")
                        .font(.title)
                    
                    Slider(
                        value: IntDoubleBinding($numPreviousBid).doubleValue,
                        in: 1.0...Double(game.numTotalDice),
                        step: 1.0)
                }
            }
            .padding([.leading, .trailing], 60.0)
            .padding(.bottom)
            .frame(maxWidth: 600)
            
            VStack(alignment: .leading) {
                Text("Die face")
                    .font(.subheadline)
                VStack {
                    ForEach(0..<2) { column in
                        HStack {
                            ForEach(1..<4) { row in
                                let face = column * 3 + row
                                Button() {
                                    if facePreviousBid == Face(rawValue: face) {
                                        facePreviousBid = nil
                                    }
                                    else {
                                        facePreviousBid = Face(rawValue: face)
                                    }
                                } label: {
                                    Image("Face\(face)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .if(facePreviousBid == Face(rawValue: face)) { view in
                                            view.overlay(
                                                RoundedRectangle(cornerRadius: 15)
                                                    .stroke(Color.blue, lineWidth: 3))
                                        }
                                }
                            }
                        }
                    }
                }
            }
            .padding([.leading, .trailing], 60.0)
            .padding(.bottom)
            .frame(maxWidth: 600)
            
            HStack {
                Button() {
                    viewRouter.currentPage = .revealPage
                } label: {
                    Text("Reveal dice")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                
                
                Button() {
                    /* Update bid probabilities and bid if facePreviousBid is
                    not nil and numPreviousBid > 0 */
                    if facePreviousBid != nil && numPreviousBid > 0 {
                        do {
                            try game.updateBidProbabilities(quantity: numPreviousBid, face: facePreviousBid!)
                            
                            currentBid = game.bid()
                        } catch {
                            negativeNumAlert = true
                        }
                    }
                    // Else, place first bid
                    else {
                        currentBid = game.bid()
                    }
                } label: {
                    if numPreviousBid == 0 || facePreviousBid == nil {
                        Text("First bid")
                            .frame(maxWidth: .infinity)
                    }
                    else {
                        Text("Bid")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .alert("Number of dice must be positive", isPresented: $negativeNumAlert) {
                    Button("OK", role: .cancel) {}
                    }
            }
            .padding([.leading, .trailing], 60.0)
            .padding([.bottom], 20.0)
            .frame(maxWidth: 600)
            
            Spacer()
        }
        .ignoresSafeArea(.keyboard)
    }

}


@ViewBuilder
func getBidView(bid: [Int]) -> some View {
    if bid[0] == -1 {
        EmptyView()
            .frame(width: 300, height: 150)
    }
    else if bid[0] == 0 {
        Text("Bullshit!")
            .font(.largeTitle)
    }
    else {
        HStack {
            Text("\(bid[1])")
                .font(.largeTitle)
            Text("x")
                .font(.largeTitle)
            Image("Face\(bid[0])")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
        }
    }
}

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

struct IntDoubleBinding {
    let intValue : Binding<Int>
    
    let doubleValue : Binding<Double>
    
    init(_ intValue : Binding<Int>) {
        self.intValue = intValue
        
        self.doubleValue = Binding<Double>(get: {
            return Double(intValue.wrappedValue)
        }, set: {
            intValue.wrappedValue = Int($0)
        })
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
            .environmentObject(ViewRouter())
            .environmentObject(Game(numPlayers: 2))
    }
}

