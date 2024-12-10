//
//  NColor.swift
//  nooro
//
//  Created by Arturo on 12/10/24.
//

import SwiftUI

/// The reason why I decided to create this balance design sistem and Colors was because of the emphasis on following figma. I could have used the native colors from SwiftUI but on Figma there are HTML colors and the requirements don't mention anything about using the native Colors.
/// I kept it minimal with only what we need to have a streamline design accross the app,
/// N in NColor stands for Nooro.
public enum NColor: Hashable, CaseIterable {

    case n100
    case n600
    case n610
    case n620
    case n900
    
    var color: Color { return self.light }
    
    var light: Color {
        switch self {
            
        case .n100: return Color(hex: "FFFFFF")
        case .n600: return Color(hex: "F2F2F2")
        case .n610: return Color(hex: "C4C4C4")
        case .n620: return Color(hex: "9A9A9A")
        case .n900: return Color(hex: "2C2C2C")
        }
    }
}

extension Color {
    
    public static let allnColors: [Color] = NColor.allCases.map { $0.color }
    
    public static let n100 = NColor.n100.color
    public static let n600 = NColor.n600.color
    public static let n610 = NColor.n610.color
    public static let n620 = NColor.n620.color
    public static let n900 = NColor.n900.color
    
}
