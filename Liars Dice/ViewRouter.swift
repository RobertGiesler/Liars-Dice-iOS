//
//  ViewRouter.swift
//  Liar's Dice
//
//  Created by Robert Giesler on 11.08.22.
//

import SwiftUI


@MainActor
class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .menuPage
    
}
