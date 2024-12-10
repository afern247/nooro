//
//  Color+Theme.swift
//  nooro
//
//  Created by Arturo on 12/10/24.
//

import SwiftUI

extension Color {
    
    public static var bgPrimary = Color.n100
    public static var bgCommonElement = Color.n600
    public static var fillSecondary = Color.n610
    public static var fillTextSecondary = Color.n620
    public static var fillPrimary = Color.n900
}

extension ShapeStyle where Self == Color {
   
    public static var bgPrimary: Color { .n100 }
    public static var bgCommonElement: Color { .n600 }
    public static var fillSecondary: Color { .n610 }
    public static var fillTextSecondary: Color { .n620 }
    public static var fillPrimary: Color { .n900 }
}
