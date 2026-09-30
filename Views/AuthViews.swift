import SwiftUI

// MARK: - Pantallas: Iniciar sesión + Registro
struct LoginView: View {
    @State private var email = "camila.rodriguez@gourmet.es"
    @State private var password = "MiClaveSegura2024"
    @State private var showPassword = false
    @State private var remember = true

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                AuthHeader(badge: "ALTA COCINA A TU MESA", title: "¡Bienvenido de vuelta!", subtitle: "Inicia sesión para saborear tus platos favoritos y disfrutar de beneficios exclusivos.")
                AuthCard {
                    VStack(spacing: 16) {
                        AuthEmailField(email: $email)
                        AuthPasswordField(password: $password, showPassword: $showPassword)
                        HStack(spacing: 8) {
                            Toggle("", isOn: $remember).labelsHidden().tint(SaborTheme.primary)
                            Text("Recordarme en este dispositivo").font(.subheadline)
                            Spacer()
                            Text("¿Olvidaste tu contraseña?").font(.subheadline).foregroundStyle(SaborTheme.primary)
                        }
                        Button { } label: { Label("Iniciar sesión", systemImage: "arrow.forward").saborPrimaryButton() }
                    }
                }
                AuthSocialRow()
                GuestButton()
                Label("Tus datos están protegidos con cifrado de grado bancario", systemImage: "checkmark.shield.fill")
                    .font(.caption).foregroundStyle(.secondary)
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
    }
}

// Componente 1: cabecera auth
struct AuthHeader: View {
    let badge: String; let title: String; let subtitle: String
    var body: some View {
        VStack(spacing: 8) {
            SaborLogoView()
            Text(badge).font(.caption).bold()
                .padding(.horizontal, 16).padding(.vertical, 8)
                .background(SaborTheme.secondaryContainer).clipShape(Capsule())
            Text(title).font(.title2).bold()
            Text(subtitle).font(.subheadline).foregroundStyle(.secondary).multilineTextAlignment(.center)
        }
    }
}

// Componente 2: tarjeta contenedora
struct AuthCard<Content: View>: View {
    @ViewBuilder let content: Content
    var body: some View {
        VStack(spacing: 16) { content }
            .padding(16)
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

// Componente 3: campo email con verificado
struct AuthEmailField: View {
    @Binding var email: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text("Correo electrónico").font(.subheadline).bold()
                Spacer()
                Label("Verificado", systemImage: "checkmark.circle.fill").font(.caption).foregroundStyle(SaborTheme.secondary)
            }
            HStack(spacing: 8) {
                Image(systemName: "envelope").foregroundStyle(.secondary)
                TextField("ejemplo@correo.com", text: $email).font(.body).textInputAutocapitalization(.never)
            }
            .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// Componente 4: campo contraseña
struct AuthPasswordField: View {
    @Binding var password: String
    @Binding var showPassword: Bool
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Contraseña").font(.subheadline).bold()
            HStack(spacing: 8) {
                Image(systemName: "lock").foregroundStyle(.secondary)
                if showPassword { TextField("Contraseña", text: $password).font(.body) }
                else { SecureField("Contraseña", text: $password).font(.body) }
                Button { showPassword.toggle() } label: { Image(systemName: showPassword ? "eye.slash" : "eye").foregroundStyle(.secondary) }
            }
            .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// Componente 5: botones sociales
struct AuthSocialRow: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Rectangle().fill(Color(.systemGray4)).frame(height: 1)
                Text("o continúa con").font(.caption).foregroundStyle(.secondary)
                Rectangle().fill(Color(.systemGray4)).frame(height: 1)
            }
            HStack(spacing: 16) {
                AuthSocialButton(icon: "g.circle.fill", label: "Google")
                AuthSocialButton(icon: "apple.logo", label: "Apple")
                AuthSocialButton(icon: "touchid", label: "ID")
            }
        }
    }
}

struct AuthSocialButton: View {
    let icon: String; let label: String
    var body: some View {
        Button { } label: {
            VStack(spacing: 8) {
                Image(systemName: icon).font(.title3)
                Text(label).font(.caption)
            }
            .frame(maxWidth: .infinity).padding(16)
            .background(Color(.systemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .tint(.primary)
    }
}

struct GuestButton: View {
    var body: some View {
        Button { } label: {
            Label("Explorar menú como invitado", systemImage: "book")
                .font(.headline).frame(maxWidth: .infinity).padding(16)
                .background(Color(.secondarySystemBackground)).clipShape(Capsule())
        }
        .tint(SaborTheme.secondary)
    }
}

// MARK: - Registro
struct RegisterView: View {
    @State private var name = "Valentina"
    @State private var surname = "González"
    @State private var email = "valentina@correo.com"
    @State private var phone = "612 345 678"
    @State private var password = "SaborDelicioso#2024"
    @State private var acceptTerms = true
    @State private var acceptOffers = false

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    Label("Paso 1 de 2: Datos de cuenta", systemImage: "fork.knife").font(.caption)
                        .padding(8).background(SaborTheme.secondaryContainer).clipShape(Capsule())
                    Spacer()
                }
                AuthHeader(badge: "🎁 10 € de regalo para nuevos miembros", title: "Crea tu cuenta Sabor", subtitle: "Únete al club gastronómico y recibe 10 € de bienvenida en tu primer pedido artesanal.")
                AuthCard {
                    VStack(spacing: 16) {
                        HStack(spacing: 16) {
                            RegisterField(label: "Nombre", text: $name, icon: "person")
                            RegisterField(label: "Apellidos", text: $surname, icon: nil)
                        }
                        RegisterField(label: "Email", text: $email, icon: "envelope")
                        RegisterField(label: "Teléfono (+34)", text: $phone, icon: "phone")
                        RegisterField(label: "Contraseña", text: $password, icon: "lock")
                        PasswordStrengthBar()
                        Toggle("Acepto los Términos del Servicio y la Política de Privacidad.", isOn: $acceptTerms).font(.subheadline).tint(SaborTheme.primary)
                        Toggle("Deseo recibir ofertas exclusivas del chef.", isOn: $acceptOffers).font(.subheadline).tint(SaborTheme.primary)
                        Button { } label: { Label("Crear cuenta y comenzar", systemImage: "arrow.forward").saborPrimaryButton() }
                    }
                }
                HStack(spacing: 8) {
                    Text("¿Ya tienes una cuenta?").font(.subheadline).foregroundStyle(.secondary)
                    Text("Iniciar sesión").font(.subheadline).bold().foregroundStyle(SaborTheme.primary)
                }
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
    }
}

struct RegisterField: View {
    let label: String; @Binding var text: String; let icon: String?
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label).font(.subheadline).bold()
            HStack(spacing: 8) {
                if let icon { Image(systemName: icon).foregroundStyle(.secondary) }
                TextField(label, text: $text).font(.body)
            }
            .padding(16).background(Color(.secondarySystemBackground)).clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

struct PasswordStrengthBar: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                ForEach(0..<4, id: \.self) { _ in Capsule().fill(SaborTheme.secondary).frame(height: 4) }
            }
            Label("Fuerte y Segura · Excelente combinación", systemImage: "checkmark.seal.fill")
                .font(.caption).foregroundStyle(SaborTheme.secondary)
        }
    }
}

#Preview { LoginView() }
#Preview { RegisterView() }
