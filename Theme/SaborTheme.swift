import SwiftUI

/// Paleta "Warm Culinary Modern" con base semántica.
/// Los colores de marca se definen con valores fijos y se combinan
/// con colores semánticos del sistema (.secondary, .systemBackground).
enum SaborTheme {
    static let primary = Color(red: 0.65, green: 0.20, blue: 0.11) // #A6331B
    static let primaryContainer = Color(red: 0.78, green: 0.29, blue: 0.19) // #C84B31
    static let primaryFixed = Color(red: 1.0, green: 0.85, blue: 0.83) // #FFDAD3
    static let secondary = Color(red: 0.27, green: 0.40, blue: 0.34) // #466557
    static let secondaryContainer = Color(red: 0.77, green: 0.91, blue: 0.84) // #C5E7D6
    static let tertiary = Color(red: 0.49, green: 0.33, blue: 0.0) // #7C5400
    static let tertiaryFixed = Color(red: 1.0, green: 0.87, blue: 0.68) // #FFDEAE
    static let star = Color(red: 0.99, green: 0.73, blue: 0.27) // #FDBA45
    static let error = Color(red: 0.73, green: 0.10, blue: 0.10) // #BA1A1A
    static let surfaceWarm = Color(red: 0.99, green: 0.98, blue: 0.96) // #FCF9F4

    static let cardShadow = Color.black.opacity(0.06)
}

extension View {
    func saborCard() -> some View {
        self
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: SaborTheme.cardShadow, radius: 8, x: 0, y: 2)
    }

    func saborPrimaryButton() -> some View {
        self
            .font(.headline)
            .foregroundStyle(.white)
            .frame(minHeight: 56)
            .frame(maxWidth: .infinity)
            .background(SaborTheme.primaryContainer)
            .clipShape(Capsule())
    }
}
