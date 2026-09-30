import SwiftUI

// MARK: - Pantalla: Historial de pedidos
struct HistoryView: View {
    @State private var filter = "Todos"
    let orders = [
        OrderInfo(id: "SB-84920", date: "Hoy, 14:15 · Prioritaria", status: "En camino (~14:50)", dishesText: "Burger Trufada, Tagliatelle, Cheesecake", total: 41.60, isActive: true, rating: nil),
        OrderInfo(id: "SB-81042", date: "12 May 2024 · 21:30", status: "Entregado", dishesText: "Costillar Ibérico x1, Bowl Burrata x1, IPA x2", total: 38.90, isActive: false, rating: 5.0),
        OrderInfo(id: "SB-76819", date: "28 Abr 2024 · 14:10", status: "Entregado", dishesText: "Smash Burger x2, Patatas x2, Kombucha x2", total: 34.20, isActive: false, rating: 5.0),
        OrderInfo(id: "SB-72104", date: "15 Abr 2024 · 20:45", status: "Entregado", dishesText: "Salmón Miso x1, Pizza Tartufata x1", total: 31.70, isActive: false, rating: nil)
    ]

    var body: some View {
        VStack(spacing: 16) {
            HistoryHeader()
            HistoryFilters(filter: $filter)
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(orders, id: \.id) { o in OrderCard(order: o) }
                }
                HelpBanner()
            }
        }
        .padding(16)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Mis Pedidos")
    }
}

// Componente 1: cabecera
struct HistoryHeader: View {
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Mis Pedidos").font(.title2).bold()
                Text("Estado actual e historial gourmet").font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "square.and.arrow.down").padding(8).background(Color(.systemBackground)).clipShape(Circle())
        }
    }
}

// Componente 2: filtros
struct HistoryFilters: View {
    @Binding var filter: String
    let items = ["Todos 4", "En curso 1", "Completados 3", "Cancelados 0"]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(items, id: \.self) { f in
                    Button { filter = f } label: {
                        Text(f).font(.subheadline)
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(filter == f ? SaborTheme.secondary : Color(.systemBackground))
                            .foregroundStyle(filter == f ? .white : .primary)
                            .clipShape(Capsule())
                    }
                }
            }
        }
    }
}

// Componente 3: tarjeta de pedido
struct OrderCard: View {
    let order: OrderInfo
    @State private var reordered = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("#\(order.id)").font(.headline)
                Spacer()
                Text(order.status).font(.caption).bold()
                    .padding(8)
                    .background(order.isActive ? SaborTheme.secondaryContainer : Color(.secondarySystemBackground))
                    .clipShape(Capsule())
            }
            Text(order.date).font(.caption).foregroundStyle(.secondary)
            if order.isActive {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Repartidor cerca de tu zona · Faltan 12 min").font(.subheadline)
                    Capsule().fill(Color(.systemGray5)).frame(height: 8)
                        .overlay(alignment: .leading) { Capsule().fill(SaborTheme.primary).frame(width: 180) }
                }
            }
            Text(order.dishesText).font(.subheadline).foregroundStyle(.secondary)
            if let r = order.rating {
                HStack(spacing: 8) {
                    ForEach(0..<5, id: \.self) { _ in Image(systemName: "star.fill").font(.caption).foregroundStyle(SaborTheme.star) }
                    Text("\(String(format: "%.1f", r))").font(.caption)
                }
            } else if !order.isActive {
                Text("Dejar una reseña sobre este pedido").font(.caption).foregroundStyle(SaborTheme.primary)
            }
            HStack(spacing: 8) {
                Text(String(format: "%.2f €", order.total).replacingOccurrences(of: ".", with: ",")).font(.headline).foregroundStyle(SaborTheme.primary)
                Spacer()
                if order.isActive {
                    Button { } label: {
                        Label("Rastrear en vivo", systemImage: "radar").font(.subheadline).bold()
                            .padding(.horizontal, 16).padding(.vertical, 8)
                            .background(SaborTheme.primary).foregroundStyle(.white).clipShape(Capsule())
                    }
                } else {
                    Button(reordered ? "¡Añadido! ✓" : "Pedir nuevamente") { reordered.toggle() }
                        .font(.subheadline).bold().padding(.horizontal, 16).padding(.vertical, 8)
                        .background(SaborTheme.secondary).foregroundStyle(.white).clipShape(Capsule())
                }
            }
        }
        .padding(16).saborCard()
        .overlay(alignment: .leading) {
            if order.isActive { Rectangle().fill(SaborTheme.primary).frame(width: 4).clipShape(Capsule()).padding(.vertical, 16) }
        }
    }
}

// Componente 4: banner ayuda
struct HelpBanner: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "questionmark.circle.fill").font(.title2).foregroundStyle(SaborTheme.primary)
            VStack(alignment: .leading, spacing: 8) {
                Text("¿Dudas con un pedido anterior?").font(.headline)
                Text("Centro de Ayuda Sabor 24/7").font(.subheadline).foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundStyle(.secondary)
        }
        .padding(16).saborCard()
    }
}

#Preview { HistoryView() }
