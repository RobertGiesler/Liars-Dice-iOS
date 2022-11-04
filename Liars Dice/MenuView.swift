//
//  MenuView.swift
//  Liar's Dice
//
//  Created by Robert Giesler on 11.08.22.
//

import SwiftUI
import AVFoundation

struct MenuView: View {
    @EnvironmentObject var viewRouter: ViewRouter
    @EnvironmentObject var game: Game
    
    @State private var numPlayers: Int?
    @State private var dicePerPlayer: Int = 5
    @State private var negativeNumAlert: Bool = false
    @FocusState private var playerFocus: Bool
    @FocusState private var diceFocus: Bool
    
    var body: some View {
        VStack {
            Spacer()
            VStack {
                Text("Liar's Dice")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Image("twoDice")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250.0, height: 150.0)
            }
            
            VStack() {
                Text("Dice per player")
                    .font(.subheadline)
                TextField("Dice per player", value: $dicePerPlayer, format: .number)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .focused($diceFocus)
                    
            }
            .padding([.leading, .trailing], 90.0)
            .padding(.bottom)
            .frame(maxWidth: 600)
                            
            VStack() {
                Text("Number of players")
                    .font(.subheadline)
                TextField("Number of players", value: $numPlayers, format: .number)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .focused($playerFocus)
                    
            }
            .padding([.leading, .trailing], 90.0)
            .padding(.bottom)
            .frame(maxWidth: 600)
            
            Button("Play") {
                if let numPlayers = numPlayers {
                    do {
                        try game.resetGame(numPlayers: numPlayers, dicePerPlayer: dicePerPlayer)
                        viewRouter.currentPage = .gamePage
                    } catch {
                        negativeNumAlert = true
                    }
                }
                else {
                }
            }
            .disabled(numPlayers == nil)
            .controlSize(.large)
            .buttonStyle(.borderedProminent)
            .padding()
            .alert("Number of dice and players must be positive", isPresented: $negativeNumAlert) {
                Button("OK", role: .cancel) {}
            }
            
            Spacer()
            
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    playerFocus = false
                    diceFocus = false
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .environmentObject(ViewRouter())
            .environmentObject(Game(numPlayers: 2))
            .previewInterfaceOrientation(.portrait)
    }
}
