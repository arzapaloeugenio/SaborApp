import SwiftUI

// MARK: - Pantalla: Pedido confirmado
struct OrderConfirmedView: View {
    @State private var showTracking = false
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SuccessHero()
                OrderStatusCard()
                DishesInProgress()
                FreshGuarantee()
                ConfirmedActions()
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Pedido Confirmado")
    }
}

// Componente 1: hero éxito
struct SuccessHero: View {
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle().fill(SaborTheme.secondaryContainer).frame(width: 96, height: 96)
                Image(systemName: "checkmark").font(.largeTitle).bold().foregroundStyle(SaborTheme.secondary)
            }
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "fork.knife.circle.fill").font(.title).foregroundStyle(SaborTheme.primaryContainer)
            }
            Text("¡Pedido Confirmado con Éxito!").font(.title2).bold().multilineTextAlignment(.center)
            Text("La cocina de Sabor ha recibido tu orden y ya está encendiendo los fogones.").font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
        .padding(16).saborCard()
    }
}

// Componente 2: estado + referencia
struct OrderStatusCard: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text("Referencia #SB-84920").font(.headline)
                Spacer()
                HStack(spacing: 8) {
                    Circle().fill(SaborTheme.secondary).frame(width: 8, height: 8)
                    Text("En cocina").font(.caption).bold()
                }
                .padding(8).background(SaborTheme.secondaryContainer).clipShape(Capsule())
            }
            HStack(spacing: 16) {
                Image(systemName: "clock.fill").foregroundStyle(SaborTheme.primary)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tiempo estimado 25 - 35 min").font(.subheadline).bold()
                    Text("Llegada 14:45 h aprox.").font(.caption).foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
            VStack(spacing: 8) {
                Label("Calle Mayor 24, 3ºB", systemImage: "mappin.circle.fill").font(.subheadline)
                Label("Mastercard •••• 4829 (41,60 € cobrado)", systemImage: "creditcard.fill").font(.subheadline)
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16).saborCard()
    }
}

// Componente 3: platos en preparación
struct DishesInProgress: View {
    let items = ["Hamburguesa Trufada · x1", "Tagliatelle al Pesto · x1", "Cheesecake Artesanal · x1"]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("Platos en preparación (3)").font(.headline)
                Spacer()
                Text("Ver detalle").font(.caption).foregroundStyle(SaborTheme.primary)
            }
            ForEach(items, id: \.self) { i in
                Label(i, systemImage: "flame.fill").font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(16).saborCard()
    }
}

// Componente 4: garantía + acciones
struct FreshGuarantee: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "leaf.fill").font(.title2).foregroundStyle(SaborTheme.secondary)
            VStack(alignment: .leading, spacing: 8) {
                Text("Garantía de Frescura Sabor").font(.headline)
                Text("Ingredientes 100% frescos preparados al momento.").font(.caption)
            }
        }
        .padding(16).background(SaborTheme.secondaryContainer.opacity(0.5)).clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct ConfirmedActions: View {
    var body: some View {
        VStack(spacing: 8) {
            Button { } label: {
                Label("Seguimiento en Vivo", systemImage: "radar").saborPrimaryButton()
            }
            HStack(spacing: 8) {
                Button { } label: {
                    Label("Ir al Inicio", systemImage: "house").font(.headline)
                        .frame(maxWidth: .infinity).padding(16)
                        .background(Color(.secondarySystemBackground)).clipShape(Capsule())
                }
                Button { } label: {
                    Label("Recibo PDF", systemImage: "receipt").font(.headline)
                        .frame(maxWidth: .infinity).padding(16)
                        .background(Color(.secondarySystemBackground)).clipShape(Capsule())
                }
            }
            .tint(.primary)
        }
    }
}

// MARK: - Pantalla: Seguimiento en vivo
struct TrackingView: View {
    @State private var showInvoice = false
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                LiveMap()
                TrackingStatus()
                CourierCard()
                TrackingOrderAccordion()
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Seguimiento en Vivo")
    }
}

struct LiveMap: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16).fill(Color(.secondarySystemBackground)).frame(height: 240)
            Image(systemName: "map.fill").font(.system(size: 64)).foregroundStyle(.secondary.opacity(0.4))
            VStack(spacing: 8) {
                Label("Transmisión satelital en directo", systemImage: "circle.fill").font(.caption)
                    .padding(8).background(.ultraThinMaterial).clipShape(Capsule())
                Spacer()
                HStack(spacing: 8) {
                    Label("Sabor Bistro", systemImage: "flame.fill").font(.caption).padding(8).background(Color(.systemBackground)).clipShape(Capsule())
                    Label("Carlos • 12 min", systemImage: "bicycle").font(.caption).padding(8).background(SaborTheme.primary).foregroundStyle(.white).clipShape(Capsule())
                    Label("Mi Casa", systemImage: "house.fill").font(.caption).padding(8).background(Color(.systemBackground)).clipShape(Capsule())
                }
            }
            .padding(16)
        }
    }
}

struct TrackingStatus: View {
    let steps = [
        ("Pedido recibido", "Aceptado 14:15", true),
        ("Preparado con esmero", "Empacado 14:26", true),
        ("En camino a tu ubicación", "Av. Libertador 14:38", true),
        ("Entregado en mano", "~14:50", false)
    ]
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("En camino • 12 min aprox.").font(.caption).bold().padding(8).background(SaborTheme.secondaryContainer).clipShape(Capsule())
                Spacer()
                Text("Llegada ~14:50").font(.caption).foregroundStyle(.secondary)
            }
            Text("El repartidor va hacia tu puerta").font(.headline)
            Text("Carlos ha recogido tu comida y está a 2.4 km.").font(.subheadline).foregroundStyle(.secondary)
            ForEach(steps, id: \.0) { s in
                HStack(spacing: 8) {
                    Image(systemName: s.2 ? "checkmark.circle.fill" : "circle").foregroundStyle(s.2 ? SaborTheme.secondary : .secondary)
                    VStack(alignment: .leading, spacing: 8) {
                        Text(s.0).font(.subheadline).bold()
                        Text(s.1).font(.caption).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding(16).saborCard()
    }
}

struct CourierCard: View {
    @State private var calling = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("Tu Repartidor Asignado").font(.headline)
                Spacer()
                Label("VIP Sabor", systemImage: "checkmark.seal.fill").font(.caption).foregroundStyle(SaborTheme.secondary)
            }
            HStack(spacing: 16) {
                ZStack(alignment: .bottomTrailing) {
                    Circle().fill(SaborTheme.secondaryContainer).frame(width: 56, height: 56)
                        .overlay(Text("CM").font(.headline))
                    Circle().fill(.green).frame(width: 12, height: 12)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Carlos M.").font(.headline)
                    Label("4.9 (1.240 entregas)", systemImage: "star.fill").font(.caption)
                    Text("Moto Honda ecológica · M-8291-ZX").font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Button { calling.toggle() } label: { Image(systemName: "phone.fill").padding(16).background(SaborTheme.secondary).foregroundStyle(.white).clipShape(Circle()) }
                Button { } label: { Image(systemName: "message.fill").padding(16).background(Color(.secondarySystemBackground)).clipShape(Circle()) }
            }
            Text("PIN de entrega: 4821").font(.headline)
                .frame(maxWidth: .infinity).padding(16)
                .background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(16).saborCard()
    }
}

struct TrackingOrderAccordion: View {
    @State private var expanded = false
    var body: some View {
        VStack(spacing: 8) {
            Button { expanded.toggle() } label: {
                HStack(spacing: 8) {
                    Text("Pedido #SB-84920 · 3 platos · 41,60 €").font(.subheadline).bold()
                    Spacer()
                    Image(systemName: expanded ? "chevron.up" : "chevron.down").foregroundStyle(.secondary)
                }
            }
            .tint(.primary)
            if expanded {
                PriceRow(title: "Hamburguesa Trufada", value: "16,80 €")
                PriceRow(title: "Tagliatelle al Pesto", value: "14,00 €")
                PriceRow(title: "Cheesecake Frutos Rojos", value: "10,80 €")
                PriceRow(title: "Total abonado", value: "41,60 €", bold: true)
            }
            Text("Descargar Factura (PDF)").font(.subheadline).foregroundStyle(SaborTheme.primary)
        }
        .padding(16).saborCard()
    }
}

#Preview { OrderConfirmedView() }
#Preview { TrackingView() }
