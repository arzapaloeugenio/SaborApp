import SwiftUI

// MARK: - Pantallas: Carrito + Finalizar pedido
struct CartView: View {
    @Environment(CartStore.self) private var cart
    @State private var quantity = 1

    var body: some View {
        @Bindable var store = cart
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    DeliveryBanner()
                    CartTitleRow()
                    ForEach($store.items) { $item in CartItemCard(item: $item) }
                    UpsellSection()
                    CutleryToggle(cutlery: $store.cutlery)
                    CouponCard()
                    OrderSummary()
                }
                .padding(16).padding(.bottom, 90)
            }
            CartBottomBar()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Carrito y Pedido")
        .onAppear { cart.sampleData() }
    }
}

// Componente 1: banner entrega
struct DeliveryBanner: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "bicycle").padding(16).background(SaborTheme.secondary).foregroundStyle(.white).clipShape(Circle())
            VStack(alignment: .leading, spacing: 8) {
                Text("Entrega estimada").font(.caption).foregroundStyle(.secondary)
                Text("25-35 min").font(.headline)
                Text("Calle Mayor 24, 3ºB").font(.subheadline)
            }
            Spacer()
            Image(systemName: "pencil").foregroundStyle(SaborTheme.primary)
        }
        .padding(16).background(SaborTheme.secondaryContainer.opacity(0.4)).clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// Componente 2: título + añadir más
struct CartTitleRow: View {
    var body: some View {
        HStack(spacing: 8) {
            Text("Tu pedido (3 platos)").font(.headline)
            Spacer()
            Label("Añadir más", systemImage: "book").font(.subheadline).foregroundStyle(SaborTheme.primary)
        }
    }
}

// Componente 3: item del carrito
struct CartItemCard: View {
    @Binding var item: CartItem
    var body: some View {
        HStack(spacing: 16) {
            RoundedRectangle(cornerRadius: 12).fill(SaborTheme.primaryContainer.opacity(0.2))
                .frame(width: 80, height: 80)
                .overlay(Image(systemName: item.dish.systemImage).foregroundStyle(SaborTheme.primary))
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text(item.dish.name).font(.headline).lineLimit(1)
                    Spacer()
                    Image(systemName: "trash").foregroundStyle(.secondary).font(.caption)
                }
                Text(item.note).font(.caption).foregroundStyle(.secondary).lineLimit(1)
                HStack(spacing: 8) {
                    Text(item.dish.priceText).font(.subheadline).bold().foregroundStyle(SaborTheme.primary)
                    Spacer()
                    QuantityStepper(quantity: $item.quantity)
                }
            }
        }
        .padding(16).saborCard()
    }
}

// Componente 4: upsell bebidas
struct UpsellSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("¿Deseas agregar bebida? · Maridaje ideal").font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    UpsellCard(name: "Cerveza Artesana IPA", price: "3,80 €")
                    UpsellCard(name: "Kombucha Frutos Bosque", price: "3,50 €")
                }
            }
        }
    }
}

struct UpsellCard: View {
    let name: String; let price: String
    @State private var added = false
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "cup.and.saucer.fill").foregroundStyle(SaborTheme.primary)
            VStack(alignment: .leading, spacing: 8) {
                Text(name).font(.subheadline).bold()
                Text(price).font(.caption).foregroundStyle(SaborTheme.primary)
            }
            Button(added ? "✓" : "Añadir") { added.toggle() }
                .font(.caption).bold().padding(8)
                .background(SaborTheme.primary).foregroundStyle(.white).clipShape(Capsule())
        }
        .padding(16).saborCard().frame(width: 240)
    }
}

// Componente 5: cubiertos + cupón + resumen
struct CutleryToggle: View {
    @Binding var cutlery: Bool
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Cubiertos biodegradables").font(.subheadline).bold()
                Text("Ayuda a reducir residuos de un solo uso").font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            Toggle("", isOn: $cutlery).labelsHidden().tint(SaborTheme.secondary)
        }
        .padding(16).saborCard()
    }
}

struct CouponCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Código de cupón").font(.headline)
            HStack(spacing: 8) {
                Text("SABOR25 (-25% en platos)").font(.subheadline)
                Spacer()
                Label("Aplicado", systemImage: "checkmark.circle.fill").font(.caption).foregroundStyle(SaborTheme.secondary)
            }
            .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(16).saborCard()
    }
}

struct OrderSummary: View {
    @Environment(CartStore.self) private var cart
    var body: some View {
        VStack(spacing: 8) {
            Text("Resumen del pedido").font(.headline).frame(maxWidth: .infinity, alignment: .leading)
            PriceRow(title: "Subtotal", value: "46,20 €")
            PriceRow(title: "Coste de entrega", value: "2,50 €")
            PriceRow(title: "Tarifa de servicio", value: "0,90 €")
            PriceRow(title: "Descuento (SABOR25)", value: "-8,00 €")
            Divider()
            PriceRow(title: "Total a pagar", value: String(format: "%.2f €", cart.total).replacingOccurrences(of: ".", with: ","), bold: true)
            Text("Impuestos incluidos (10% IVA) · Pago seguro cifrado").font(.caption).foregroundStyle(.secondary)
        }
        .padding(16).saborCard()
    }
}

struct CartBottomBar: View {
    @Environment(CartStore.self) private var cart
    var body: some View {
        HStack(spacing: 16) {
            Text(String(format: "Total %.2f €", cart.total).replacingOccurrences(of: ".", with: ",")).font(.headline)
            Spacer()
            Text("Continuar al pago →").font(.headline).padding(.horizontal, 24).padding(.vertical, 16)
                .background(SaborTheme.primary).foregroundStyle(.white).clipShape(Capsule())
        }
        .padding(16).background(.ultraThinMaterial)
    }
}

// MARK: - Finalizar pedido
struct CheckoutView: View {
    @State private var deliveryMode = "pronto"
    @State private var payMethod = "card"
    @State private var notes = ""
    @State private var confirming = false

    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    CheckoutETA()
                    CheckoutAddress(mode: $deliveryMode)
                    CheckoutPayment(selection: $payMethod)
                    CheckoutNotes(notes: $notes)
                    CheckoutSummaryMini()
                }
                .padding(16).padding(.bottom, 90)
            }
            HStack(spacing: 16) {
                Text("Total final 41,60 €").font(.headline)
                Spacer()
                Button(confirming ? "Confirmando..." : "Realizar pedido →") { confirming.toggle() }
                    .font(.headline).padding(.horizontal, 24).padding(.vertical, 16)
                    .background(SaborTheme.primary).foregroundStyle(.white).clipShape(Capsule())
            }
            .padding(16).background(.ultraThinMaterial)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Finalizar Pedido")
    }
}

struct CheckoutETA: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "moped.fill").font(.title2).foregroundStyle(SaborTheme.secondary)
            VStack(alignment: .leading, spacing: 8) {
                Text("Tiempo estimado").font(.caption).foregroundStyle(.secondary)
                Text("25 - 35 minutos").font(.headline)
            }
            Spacer()
            Text("En directo").font(.caption).padding(8).background(SaborTheme.secondaryContainer).clipShape(Capsule())
        }
        .padding(16).saborCard()
    }
}

struct CheckoutAddress: View {
    @Binding var mode: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Label("Dirección de Entrega", systemImage: "mappin.circle.fill").font(.headline)
                Spacer()
                Text("+ Nueva dirección").font(.caption).foregroundStyle(SaborTheme.primary)
            }
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Text("Casa · Principal").font(.subheadline).bold()
                    Spacer()
                    Text("Cambiar").font(.caption).foregroundStyle(SaborTheme.primary)
                }
                Text("Calle Mayor 24, 3ºB, 28013 Madrid").font(.subheadline)
                Text("Dejar en conserjería o llamar al timbre").font(.caption).foregroundStyle(.secondary)
            }
            .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
            Text("Momento de entrega").font(.subheadline).bold()
            HStack(spacing: 8) {
                Button { mode = "pronto" } label: {
                    Label("Lo antes posible", systemImage: "bolt.fill").font(.subheadline)
                        .frame(maxWidth: .infinity).padding(16)
                        .background(mode == "pronto" ? SaborTheme.secondary : Color(.secondarySystemBackground))
                        .foregroundStyle(mode == "pronto" ? .white : .primary).clipShape(RoundedRectangle(cornerRadius: 12))
                }
                Button { mode = "programado" } label: {
                    Label("Programar hora", systemImage: "calendar").font(.subheadline)
                        .frame(maxWidth: .infinity).padding(16)
                        .background(mode == "programado" ? SaborTheme.secondary : Color(.secondarySystemBackground))
                        .foregroundStyle(mode == "programado" ? .white : .primary).clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(16).saborCard()
    }
}

struct CheckoutPayment: View {
    @Binding var selection: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Label("Método de Pago", systemImage: "creditcard.fill").font(.headline)
                Spacer()
                Text("+ Añadir nuevo").font(.caption).foregroundStyle(SaborTheme.primary)
            }
            PayOption(id: "card", title: "•••• 4829 · Mastercard · 09/27", subtitle: "Predeterminada", selected: $selection)
            PayOption(id: "gpay", title: "Google Pay", subtitle: "mariagonzalez@gmail.com", selected: $selection)
            PayOption(id: "cash", title: "Pago en efectivo", subtitle: "Importe exacto recomendado", selected: $selection)
        }
        .padding(16).saborCard()
    }
}

struct PayOption: View {
    let id: String; let title: String; let subtitle: String
    @Binding var selected: String
    var body: some View {
        Button { selected = id } label: {
            HStack(spacing: 8) {
                Image(systemName: selected == id ? "checkmark.circle.fill" : "circle").foregroundStyle(SaborTheme.primary)
                VStack(alignment: .leading, spacing: 8) {
                    Text(title).font(.subheadline).bold()
                    Text(subtitle).font(.caption).foregroundStyle(.secondary)
                }
            }
            .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .tint(.primary)
    }
}

struct CheckoutNotes: View {
    @Binding var notes: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Notas para la cocina o repartidor", systemImage: "note.text").font(.headline)
            TextField("Ej: Alérgico a frutos secos, sin hielo...", text: $notes, axis: .vertical)
                .font(.body).lineLimit(3)
                .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(16).saborCard()
    }
}

struct CheckoutSummaryMini: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Label("Resumen del Pedido", systemImage: "fork.knife").font(.headline)
                Spacer()
                Text("3 platos").font(.caption).padding(8).background(SaborTheme.secondaryContainer).clipShape(Capsule())
            }
            PriceRow(title: "Subtotal", value: "46,20 €")
            PriceRow(title: "Gastos de envío", value: "2,50 €")
            PriceRow(title: "Tarifa de servicio", value: "0,90 €")
            PriceRow(title: "Cupón SABOR25", value: "-8,00 €")
            Divider()
            PriceRow(title: "Total final", value: "41,60 €", bold: true)
            Label("Este pedido compensa su huella de carbono al 100%.", systemImage: "leaf.fill").font(.caption).foregroundStyle(SaborTheme.secondary)
        }
        .padding(16).saborCard()
    }
}

#Preview { CartView().environment(CartStore()).environment(AppState()) }
#Preview { CheckoutView() }
