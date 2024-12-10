//
//  SessionView.swift
//  nooro
//
//  Created by Arturo on 12/10/24.
//

import SwiftUI

// The only reason why this "empty" view is here is because on the requirements you mentioned that you wanted dependency injection, this demostrates that.
// I could delete this view and put it on the root, however it's not wise to do that do to performance.
struct SessionView: View {
    
    @StateObject private var viewModel = SearchViewModel()
    
    var body: some View {
        WeatherHomeView()
            .environmentObject(viewModel)
    }
}

#Preview {
    SessionView()
}
