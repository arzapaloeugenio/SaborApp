import SwiftUI

// MARK: - Pantalla: Notificaciones
struct NotificationsView: View {
    @State private var filter = "Todas"
    @State private var allRead = false
    @State private var couponCopied = false

    var body: some View {
        VStack(spacing: 16) {
            NotificationsHeader(allRead: $allRead)
            NotificationsFilters(filter: $filter)
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Hoy · 2 actividades").font(.caption).bold().foregroundStyle(.secondary)
                    TrackingNotifCard()
                    PromoNotifCard(copied: $couponCopied)
                    Text("Ayer").font(.caption).bold().foregroundStyle(.secondary)
                    PointsNotifCard()
                    ChefNewsCard()
                    Text("Esta semana").font(.caption).bold().foregroundStyle(.secondary)
                    DeliveredNotifCard()
                    WeeklySummaryCard()
                    PreferencesFooter()
                }
            }
        }
        .padding(16)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Notificaciones")
    }
}

// Componente 1: cabecera con badge
struct NotificationsHeader: View {
    @Binding var allRead: Bool
    var body: some View {
        HStack(spacing: 8) {
            Text("Notificaciones").font(.title2).bold()
            Text(allRead ? "0" : "2 nuevas").font(.caption).bold().padding(8)
                .background(allRead ? Color(.systemGray4) : SaborTheme.primary).foregroundStyle(.white).clipShape(Capsule())
            Spacer()
            Button(allRead ? "Al día ✓" : "Marcar todas como leídas") { allRead.toggle() }
                .font(.caption).tint(SaborTheme.primary)
        }
    }
}

// Componente 2: filtros
struct NotificationsFilters: View {
    @Binding var filter: String
    let items = ["Todas (6)", "Pedidos (2)", "Promociones (2)", "Noticias del Chef (2)"]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items, id: \.self) { f in
                    Button { filter = f } label: { CategoryChip(title: f, isSelected: filter == f) }
                }
            }
        }
    }
}

// Componente 3: cards por tipo
struct TrackingNotifCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("En curso").font(.caption).bold().padding(8).background(SaborTheme.secondaryContainer).clipShape(Capsule())
                Text("Hace 15 min").font(.caption).foregroundStyle(.secondary)
            }
            HStack(spacing: 16) {
                Image(systemName: "moped.fill").font(.title2).foregroundStyle(SaborTheme.primaryContainer)
                VStack(alignment: .leading, spacing: 8) {
                    Text("¡Tu pedido está en camino!").font(.headline)
                    Text("Carlos va hacia tu puerta con tu Hamburguesa Trufada. Aprox. 12 min.").font(.subheadline).foregroundStyle(.secondary)
                    Text("Entrega estimada: 14:22").font(.caption)
                    Text("Rastrear pedido →").font(.subheadline).bold()
                        .padding(.horizontal, 16).padding(.vertical, 8)
                        .background(SaborTheme.primary).foregroundStyle(.white).clipShape(Capsule())
                }
            }
        }
        .padding(16).saborCard()
        .overlay(alignment: .leading) { Rectangle().fill(SaborTheme.primary).frame(width: 4).padding(.vertical, 16) }
    }
}

struct PromoNotifCard: View {
    @Binding var copied: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("Promoción").font(.caption).bold().padding(8).background(SaborTheme.tertiaryFixed).clipShape(Capsule())
                Text("Hace 3 horas").font(.caption).foregroundStyle(.secondary)
            }
            Text("25% de descuento en Platos de Autor").font(.headline)
            Text("Usa el cupón SABOR25. Válido hasta el domingo.").font(.subheadline).foregroundStyle(.secondary)
            Button(copied ? "¡Copiado! ✓" : "Copiar cupón SABOR25") { copied.toggle() }
                .font(.subheadline).bold().padding(.horizontal, 16).padding(.vertical, 8)
                .background(SaborTheme.primaryFixed).clipShape(Capsule()).tint(.primary)
        }
        .padding(16).saborCard()
    }
}

struct PointsNotifCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("Sabor Club").font(.caption).bold().padding(8).background(SaborTheme.secondaryContainer).clipShape(Capsule())
                Text("Ayer, 20:30").font(.caption).foregroundStyle(.secondary)
            }
            Label("Has sumado 120 puntos Sabor Club", systemImage: "gift.fill").font(.headline)
            Text("Tu pedido #SB-84920 te acerca a tu postre gratuito. Total: 640 puntos.").font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(16).saborCard()
    }
}

struct ChefNewsCard: View {
    @State private var added = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("Cocina de Autor").font(.caption).bold().padding(8).background(SaborTheme.tertiaryFixed).clipShape(Capsule())
                Text("Ayer, 13:10").font(.caption).foregroundStyle(.secondary)
            }
            Text("Nuevo plato de temporada en carta").font(.headline)
            Text("El Chef Javier presenta el Bowl Mediterráneo de Burrata con higos caramelizados.").font(.subheadline).foregroundStyle(.secondary)
            HStack(spacing: 16) {
                RoundedRectangle(cornerRadius: 12).fill(SaborTheme.secondaryContainer).frame(width: 64, height: 64)
                    .overlay(Image(systemName: "leaf.fill").foregroundStyle(SaborTheme.secondary))
                VStack(alignment: .leading, spacing: 8) {
                    Text("Bowl Burrata & Higos").font(.subheadline).bold()
                    Text("14,50 €").font(.subheadline).foregroundStyle(SaborTheme.primary)
                }
                Spacer()
                Button(added ? "✓" : "+") { added.toggle() }
                    .padding(8).background(SaborTheme.primary).foregroundStyle(.white).clipShape(Circle())
            }
            .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(16).saborCard()
    }
}

struct DeliveredNotifCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("Completado").font(.caption).bold().padding(8).background(Color(.secondarySystemBackground)).clipShape(Capsule())
                Text("12 May, 22:00").font(.caption).foregroundStyle(.secondary)
            }
            Label("Pedido entregado con éxito", systemImage: "checkmark.circle.fill").font(.headline).foregroundStyle(SaborTheme.secondary)
            Text("¿Qué te pareció el Costillar Ibérico? Valora y gana 30 puntos.").font(.subheadline).foregroundStyle(.secondary)
            HStack(spacing: 8) {
                Label("Dejar valoración", systemImage: "star").font(.subheadline).padding(.horizontal, 16).padding(.vertical, 8).background(SaborTheme.tertiaryFixed).clipShape(Capsule())
                Text("Ver recibo").font(.subheadline).padding(.horizontal, 16).padding(.vertical, 8).background(Color(.secondarySystemBackground)).clipShape(Capsule())
            }
        }
        .padding(16).saborCard()
    }
}

struct WeeklySummaryCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("Resumen").font(.caption).bold().padding(8).background(Color(.secondarySystemBackground)).clipShape(Capsule())
                Text("10 May, 11:15").font(.caption).foregroundStyle(.secondary)
            }
            Label("Tu balance gastronómico semanal", systemImage: "chart.bar.fill").font(.headline)
            Text("Completaste 2 pedidos y ahorraste 18,20 € con tus cupones.").font(.subheadline).foregroundStyle(.secondary)
        }
        .padding(16).saborCard()
    }
}

struct PreferencesFooter: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "bell.badge.fill").foregroundStyle(SaborTheme.primary)
            VStack(alignment: .leading, spacing: 8) {
                Text("Preferencias de aviso").font(.subheadline).bold()
                Text("Personalizar notificaciones push y SMS").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
        }
        .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview { NotificationsView() }
