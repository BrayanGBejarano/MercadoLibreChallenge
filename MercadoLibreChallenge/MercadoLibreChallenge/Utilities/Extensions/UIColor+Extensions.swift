//
//  UIColor+Extensions.swift
//  MercadoLibreChallenge
//
//  Created by Brayan Bejarano on 27/04/25.
//

import UIKit

// MARK: - Colors
extension UIColor {
    
    // Colores principales
    static let mlPrimary = UIColor(red: 0.00, green: 0.64, blue: 0.85, alpha: 1.00)
    static let mlYellow = UIColor(red: 1.00, green: 0.90, blue: 0.16, alpha: 1.00)
    static let mlGreen = UIColor(red: 0.00, green: 0.69, blue: 0.29, alpha: 1.00)
    
    // Colores secundarios
    static let mlDarkGray = UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.00)
    static let mlLightGray = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1.00)
    
    // Colores de estado
    static let mlSuccess = UIColor(red: 0.22, green: 0.71, blue: 0.29, alpha: 1.00)
    static let mlError = UIColor(red: 0.91, green: 0.22, blue: 0.21, alpha: 1.00)
    static let mlWarning = UIColor(red: 1.00, green: 0.66, blue: 0.16, alpha: 1.00)
    
    // Colores neutros
    static let mlBlack = UIColor(red: 0.10, green: 0.10, blue: 0.10, alpha: 1.00)
    static let mlWhite = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    static let mlBackground = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexFormatted = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#") {
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}

// MARK: - Semantic Colors (opcional)
extension UIColor {
    static let mlTextPrimary = UIColor.mlBlack
    static let mlTextSecondary = UIColor.mlDarkGray
    static let mlBorder = UIColor(white: 0.88, alpha: 1.0)
    static let mlShadow = UIColor.black.withAlphaComponent(0.1)
}
