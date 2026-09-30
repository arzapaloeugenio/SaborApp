import SwiftUI

// MARK: - Pantalla 1: Splash / Onboarding (3 slides)
struct OnboardingView: View {
    @Binding var isPresented: Bool
    @State private var index = 0
    private let slides = OnboardingData.slides

    var body: some View {
        VStack(spacing: 16) {
            OnboardingHero(index: index)
            OnboardingPanel(
                slide: slides[index],
                index: index,
                total: slides.count,
                onNext: {
                    if index < slides.count - 1 { index += 1 } else { isPresented = false }
                },
                onSkip: { isPresented = false }
            )
        }
        .background(Color(.systemGroupedBackground))
        .ignoresSafeArea()
    }
}

struct OnboardingData {
    struct Slide { let title: String; let text: String; let cta: String }
    static let slides = [
        Slide(title: "Descubre nuevos sabores artesanales", text: "Platos de alta cocina preparados al momento con ingredientes frescos de origen local directamente a tu mesa.", cta: "Comenzar a ordenar"),
        Slide(title: "Recetas de autor y sazón auténtica", text: "Creadas por maestros culinarios que transforman cada bocado en una experiencia sensorial inolvidable.", cta: "Explorar menú"),
        Slide(title: "La mesa servida donde prefieras", text: "Servicio impecable con empaques ecológicos diseñados para conservar la textura y temperatura ideal.", cta: "Crear mi cuenta")
    ]
}

// Componente 1: hero superior con badges
struct OnboardingHero: View {
    let index: Int
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [.orange.opacity(0.5), SaborTheme.primary], startPoint: .top, endPoint: .bottom)
            VStack(spacing: 8) {
                HStack(spacing: 8) {
                    Label("Sabor", systemImage: "flame.fill")
                        .font(.headline).padding(8)
                        .background(.ultraThinMaterial).clipShape(Capsule())
                    Spacer()
                }
                .padding(16)
                Spacer()
                HStack(spacing: 8) {
                    Label("Ingredientes 100% de origen local", systemImage: "leaf.fill")
                        .font(.caption).padding(8)
                        .background(SaborTheme.secondaryContainer).clipShape(Capsule())
                    Spacer()
                    HStack(spacing: 8) {
                        Image(systemName: "star.fill").foregroundStyle(SaborTheme.star)
                        Text("4.9/5").font(.subheadline).bold()
                        Text("de +12,000 comensales").font(.caption).foregroundStyle(.secondary)
                    }
                    .padding(8).background(.ultraThinMaterial).clipShape(Capsule())
                }
                .padding(16)
            }
        }
        .frame(height: 400)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.horizontal, 16)
    }
}

// Componente 2: panel inferior con dots y CTA
struct OnboardingPanel: View {
    let slide: OnboardingData.Slide
    let index: Int
    let total: Int
    let onNext: () -> Void
    let onSkip: () -> Void
    var body: some View {
        VStack(spacing: 16) {
            Capsule().fill(Color(.systemGray4)).frame(width: 48, height: 4)
            HStack(spacing: 8) {
                ForEach(0..<total, id: \.self) { i in
                    Capsule().fill(i == index ? SaborTheme.primaryContainer : Color(.systemGray4))
                        .frame(width: i == index ? 28 : 8, height: 8)
                }
                Spacer()
                Button("Saltar", action: onSkip).font(.subheadline).tint(SaborTheme.primary)
            }
            Text(slide.title).font(.title2).bold().multilineTextAlignment(.center)
            Text(slide.text).font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
            OnboardingPerks()
            Button(action: onNext) {
                Label(slide.cta, systemImage: "arrow.forward").saborPrimaryButton()
            }
            HStack(spacing: 8) {
                Text("¿Ya tienes una cuenta?").font(.subheadline).foregroundStyle(.secondary)
                Text("Iniciar sesión").font(.subheadline).bold().foregroundStyle(SaborTheme.primary)
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 32))
    }
}

// Componente 3: mini tarjetas de ventajas
struct OnboardingPerks: View {
    var body: some View {
        HStack(spacing: 16) {
            PerkCard(icon: "timer", title: "Entrega ágil", subtitle: "En su punto exacto")
            PerkCard(icon: "fork.knife", title: "Menú de Autor", subtitle: "Chefs destacados")
        }
    }
}

struct PerkCard: View {
    let icon: String; let title: String; let subtitle: String
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon).font(.title2).foregroundStyle(SaborTheme.primary)
            Text(title).font(.subheadline).bold()
            Text(subtitle).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(16)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// Componente 4: logotipo Sabor (pantalla logo_sabor)
struct SaborLogoView: View {
    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle().fill(LinearGradient(colors: [.orange, SaborTheme.primary], startPoint: .top, endPoint: .bottom)).frame(width: 44, height: 44)
                Image(systemName: "flame.fill").foregroundStyle(.white)
            }
            Text("Sabor").font(.title).bold() + Text(".").font(.title).bold().foregroundStyle(SaborTheme.primary)
        }
    }
}

#Preview { OnboardingView(isPresented: .constant(true)) }
