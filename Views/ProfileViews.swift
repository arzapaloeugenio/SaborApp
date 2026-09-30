import SwiftUI

// MARK: - Pantalla: Perfil de usuario
struct ProfileView: View {
    @Environment(AppState.self) private var appState
    @State private var notifications = true

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ProfileHeaderCard()
                ProfileStatsRow()
                ProfileAccountSection()
                ProfilePreferences(notifications: $notifications)
                ProfileSupportSection()
                LogoutButton()
                Text("Sabor v2.4.0 (Build 184) · Hecho con esmero culinario").font(.caption).foregroundStyle(.secondary)
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Perfil")
    }
}

// Componente 1: cabecera perfil + VIP
struct ProfileHeaderCard: View {
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 16) {
                ZStack(alignment: .bottomTrailing) {
                    Circle().fill(SaborTheme.secondaryContainer).frame(width: 64, height: 64)
                        .overlay(Text("VG").font(.headline))
                    Image(systemName: "checkmark.seal.fill").foregroundStyle(SaborTheme.secondary)
                }
                VStack(alignment: .leading, spacing: 8) {
                    Text("Valentina González").font(.headline)
                    Text("valentina@correo.com").font(.caption).foregroundStyle(.secondary)
                    Text("+34 612 345 678").font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Image(systemName: "pencil").padding(8).background(Color(.secondarySystemBackground)).clipShape(Circle())
            }
            HStack(spacing: 8) {
                Image(systemName: "crown.fill").foregroundStyle(SaborTheme.tertiary)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Club Sabor VIP · Miembro Oro").font(.subheadline).bold()
                }
                Spacer()
                Label("840 pts", systemImage: "flame.fill").font(.caption).padding(8).background(SaborTheme.tertiaryFixed).clipShape(Capsule())
            }
            .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .padding(16).saborCard()
    }
}

// Componente 2: stats
struct ProfileStatsRow: View {
    var body: some View {
        HStack(spacing: 8) {
            StatCard(icon: "receipt", value: "14", label: "Pedidos")
            StatCard(icon: "heart.fill", value: "4", label: "Favoritos")
            StatCard(icon: "mappin", value: "3", label: "Direcciones")
        }
    }
}

struct StatCard: View {
    let icon: String; let value: String; let label: String
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon).foregroundStyle(SaborTheme.primary)
            Text(value).font(.headline)
            Text(label).font(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity).padding(16).saborCard()
    }
}

// Componente 3: secciones de cuenta
struct ProfileAccountSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Mi Cuenta").font(.headline)
            VStack(spacing: 8) {
                ProfileRow(icon: "mappin.circle.fill", title: "Direcciones de Entrega", subtitle: "Casa, Trabajo, Padres · 3 registradas")
                ProfileRow(icon: "creditcard.fill", title: "Métodos de Pago", subtitle: "Mastercard •••• 4829")
                ProfileRow(icon: "heart.fill", title: "Mis Platos Favoritos", subtitle: "4 guardados", badge: "4")
                ProfileRow(icon: "receipt.fill", title: "Historial y Recibos", subtitle: "13 completados", badge: "1 en camino")
            }
            .padding(16).saborCard()
        }
    }
}

struct ProfileRow: View {
    let icon: String; let title: String; let subtitle: String; var badge: String? = nil
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon).foregroundStyle(SaborTheme.primary).frame(width: 24)
            VStack(alignment: .leading, spacing: 8) {
                Text(title).font(.subheadline).bold()
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
            }
            Spacer()
            if let badge { Text(badge).font(.caption).padding(8).background(Color(.secondarySystemBackground)).clipShape(Capsule()) }
            Image(systemName: "chevron.right").foregroundStyle(.secondary).font(.caption)
        }
        .padding(.vertical, 8)
    }
}

// Componente 4: preferencias + recompensas
struct ProfilePreferences: View {
    @Binding var notifications: Bool
    @State private var progress = 0.84
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Preferencias y Experiencia").font(.headline)
            VStack(spacing: 8) {
                ProfileRow(icon: "leaf.fill", title: "Alergias y Preferencias", subtitle: "Sin frutos secos")
                HStack(spacing: 16) {
                    Image(systemName: "bell.fill").foregroundStyle(SaborTheme.primary).frame(width: 24)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notificaciones y Alertas").font(.subheadline).bold()
                        Text("Pedidos en vivo y promociones").font(.caption).foregroundStyle(.secondary)
                    }
                    Spacer()
                    Toggle("", isOn: $notifications).labelsHidden().tint(SaborTheme.primary)
                }
                .padding(.vertical, 8)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Club de Recompensas · 840 / 1.000 pts").font(.subheadline).bold()
                    ProgressView(value: progress).tint(SaborTheme.tertiary)
                    Text("Faltan 160 pts para tu cupón de 10 € · Ver catálogo").font(.caption).foregroundStyle(.secondary)
                }
                .padding(16).background(SaborTheme.tertiaryFixed.opacity(0.4)).clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(16).saborCard()
        }
    }
}

// Componente 5: soporte + logout
struct ProfileSupportSection: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Soporte y Legal").font(.headline)
            VStack(spacing: 8) {
                ProfileRow(icon: "questionmark.circle", title: "Centro de Ayuda", subtitle: "Chat en vivo 24/7")
                ProfileRow(icon: "gearshape", title: "Configuración y Privacidad", subtitle: "Datos y accesos")
                ProfileRow(icon: "doc.text", title: "Términos del Servicio", subtitle: "Compra y entrega")
            }
            .padding(16).saborCard()
        }
    }
}

struct LogoutButton: View {
    @State private var confirm = false
    var body: some View {
        Button(confirm ? "¿Seguro? Toca de nuevo para salir" : "Cerrar sesión") { confirm.toggle() }
            .font(.headline).frame(maxWidth: .infinity).padding(16)
            .background(confirm ? SaborTheme.error : SaborTheme.error.opacity(0.12))
            .foregroundStyle(confirm ? .white : SaborTheme.error)
            .clipShape(Capsule())
    }
}

// MARK: - Pantalla: Configuración
struct SettingsView: View {
    @State private var theme = "Claro"
    @State private var haptics = true
    @State private var pushOrders = true
    @State private var offers = true
    @State private var newsletter = false
    @State private var biometrics = true
    @State private var showDelete = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                SettingsCard(title: "Apariencia y Tema", subtitle: "Atmósfera cálida gourmet optimizada para el día o la noche.") {
                    ForEach(["Claro", "Oscuro", "Automático del sistema"], id: \.self) { o in
                        Button { theme = o } label: {
                            HStack(spacing: 8) {
                                Image(systemName: theme == o ? "checkmark.circle.fill" : "circle").foregroundStyle(SaborTheme.primary)
                                Text(o == "Claro" ? "Claro (Predeterminado)" : o).font(.body)
                            }
                        }
                        .tint(.primary)
                    }
                    Divider()
                    SettingsRow(title: "Idioma de la aplicación", subtitle: "Español (España)")
                    Toggle("Sonidos y Háptica al ordenar", isOn: $haptics).font(.subheadline).tint(SaborTheme.primary)
                }
                SettingsCard(title: "Notificaciones y Comunicaciones", subtitle: "") {
                    Toggle("Push de pedidos · Tiempo real", isOn: $pushOrders).font(.subheadline).tint(SaborTheme.primary)
                    Toggle("Ofertas exclusivas", isOn: $offers).font(.subheadline).tint(SaborTheme.primary)
                    Toggle("Boletín gastronómico del Chef", isOn: $newsletter).font(.subheadline).tint(SaborTheme.primary)
                }
                SettingsCard(title: "Privacidad y Seguridad", subtitle: "") {
                    Toggle("Autenticación Biométrica", isOn: $biometrics).font(.subheadline).tint(SaborTheme.primary)
                    SettingsRow(title: "Gestión de datos y cookies", subtitle: "Descargar datos o gestionar RGPD")
                    SettingsRow(title: "Permisos de ubicación", subtitle: "Solo con la app en uso")
                }
                SettingsCard(title: "Soporte e Información Legal", subtitle: "") {
                    SettingsRow(title: "Centro de Ayuda y FAQ", subtitle: "")
                    SettingsRow(title: "Contactar Soporte (Chat 24/7)", subtitle: "")
                    SettingsRow(title: "Términos y Condiciones", subtitle: "")
                    SettingsRow(title: "Política de Privacidad", subtitle: "")
                }
                Button("Cerrar sesión en todos los dispositivos") { }
                    .font(.headline).frame(maxWidth: .infinity).padding(16)
                    .background(Color(.secondarySystemBackground)).clipShape(Capsule()).tint(.primary)
                Button("Eliminar cuenta y datos personales") { showDelete = true }
                    .font(.subheadline).foregroundStyle(SaborTheme.error)
                    .alert("¿Eliminar cuenta de Sabor?", isPresented: $showDelete) {
                        Button("Sí, eliminar definitivamente", role: .destructive) { }
                        Button("Cancelar", role: .cancel) { }
                    } message: {
                        Text("Se cancelarán reservas, puntos y preferencias gourmet.")
                    }
                Text("Sabor Gastronomía S.L. · Versión 2.4.0").font(.caption).foregroundStyle(.secondary)
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Configuración")
    }
}

struct SettingsCard<Content: View>: View {
    let title: String; let subtitle: String
    @ViewBuilder let content: Content
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            if !subtitle.isEmpty { Text(subtitle).font(.caption).foregroundStyle(.secondary) }
            content
        }
        .padding(16).saborCard()
    }
}

struct SettingsRow: View {
    let title: String; let subtitle: String
    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title).font(.subheadline).bold()
                if !subtitle.isEmpty { Text(subtitle).font(.caption).foregroundStyle(.secondary) }
            }
            Spacer()
            Image(systemName: "chevron.right").font(.caption).foregroundStyle(.secondary)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Pantalla: Mis direcciones
struct AddressesView: View {
    @State private var toast: String?
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AddressesHeader()
                AddressCardMain(toast: $toast)
                AddressCardSecondary(title: "Oficina Creativa", subtitle: "Lunes a Viernes", street: "Paseo de la Castellana 112, Planta 4", notes: "Entregar en recepción.", toast: $toast)
                AddressCardSecondary(title: "Casa Padres", subtitle: "Ocasional", street: "Avenida de América 18, 1º Izq", notes: "Llamar al móvil al llegar.", toast: $toast)
                CoverageCard()
                if let toast {
                    Label(toast, systemImage: "checkmark.circle.fill").font(.subheadline).padding(16)
                        .background(Color(.label)).foregroundStyle(Color(.systemBackground)).clipShape(Capsule())
                }
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Mis Direcciones")
    }
}

struct AddressesHeader: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Direcciones de Entrega").font(.title2).bold()
            Text("Gestiona tus lugares habituales para recibir tus pedidos recién salidos de cocina.").font(.subheadline).foregroundStyle(.secondary)
            Button { } label: {
                Label("Agregar nueva dirección", systemImage: "location.badge.plus").saborPrimaryButton()
            }
        }
    }
}

struct AddressCardMain: View {
    @Binding var toast: String?
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "house.fill").foregroundStyle(SaborTheme.primary)
                Text("Casa (Habitual)").font(.headline)
                Spacer()
                Label("Predeterminada", systemImage: "checkmark.circle.fill").font(.caption).padding(8).background(SaborTheme.secondaryContainer).clipShape(Capsule())
            }
            VStack(alignment: .leading, spacing: 8) {
                Label("Calle Mayor 24, 3ºB, 28013 Madrid", systemImage: "mappin.circle.fill").font(.subheadline)
                Text("Dejar en conserjería o llamar al timbre.").font(.caption).foregroundStyle(.secondary)
                Text("+34 612 345 678").font(.caption)
            }
            .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
            HStack(spacing: 8) {
                Label("Seleccionada para pedidos", systemImage: "checkmark.circle.fill").font(.caption).foregroundStyle(SaborTheme.secondary)
                Spacer()
                Button("Editar") { toast = "Abriendo editor de ubicación..." }.font(.subheadline)
                    .padding(.horizontal, 16).padding(.vertical, 8).background(Color(.secondarySystemBackground)).clipShape(Capsule()).tint(.primary)
            }
        }
        .padding(16).saborCard()
    }
}

struct AddressCardSecondary: View {
    let title: String; let subtitle: String; let street: String; let notes: String
    @Binding var toast: String?
    @State private var isMain = false
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "building.2.fill").foregroundStyle(.secondary)
                Text(title).font(.headline)
                Spacer()
                Button(isMain ? "Principal ✓" : "Hacer principal") { isMain.toggle(); toast = "Dirección predeterminada actualizada" }
                    .font(.caption).tint(SaborTheme.primary)
            }
            Text(subtitle).font(.caption).foregroundStyle(.secondary)
            Text(street).font(.subheadline)
            Text(notes).font(.caption).foregroundStyle(.secondary)
        }
        .padding(16).saborCard()
    }
}

struct CoverageCard: View {
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "bicycle").font(.title2).foregroundStyle(SaborTheme.secondary)
            VStack(alignment: .leading, spacing: 8) {
                Text("Zona de entrega garantizada").font(.headline)
                Text("Radio de 6 km · Flota 100% eléctrica · ~25-35 min").font(.caption).foregroundStyle(.secondary)
                Text("Consultar cobertura ampliada").font(.caption).foregroundStyle(SaborTheme.primary)
            }
        }
        .padding(16).saborCard()
    }
}

#Preview { ProfileView().environment(AppState()) }
#Preview { SettingsView() }
#Preview { AddressesView() }
