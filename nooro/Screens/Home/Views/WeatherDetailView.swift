//
//  WeatherDetailView.swift
//  nooro
//
//  Created by Arturo on 12/10/24.
//

import SwiftUI

struct WeatherDetailView: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.fillSecondary)
            Text(value)
                .font(.body)
                .fontWeight(.medium)
                .foregroundColor(.fillSecondary)
        }
    }
}

#Preview {
    WeatherDetailView(label: "UV", value: "4")
}
