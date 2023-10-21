//
//  Utilities.swift
//  Loyalty
//
//  Created by Hunter Kingsbeer on 9/09/23.
//

import Foundation
import SwiftUI
import CachedAsyncImage

let lineWidth: CGFloat = 0.9

let IS_PREVIEW: Bool = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
//let cornerRadius: CGFloat = 6

func generateHaptic(style: UIImpactFeedbackGenerator.FeedbackStyle) {
    UIImpactFeedbackGenerator(style: style).impactOccurred()
}
extension String {
    func capitalizingFirstLetter() -> String {
      return prefix(1).uppercased() + self.lowercased().dropFirst()
    }

    mutating func capitalizeFirstLetter() {
      self = self.capitalizingFirstLetter()
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
    
    @inlinable func reverseMask<Mask: View>(alignment: Alignment = .center, @ViewBuilder _ mask: () -> Mask) -> some View {
        self.mask(
            ZStack {
                Rectangle()

                mask()
                    .blendMode(.destinationOut)
            }
        )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension Image {
    static func fromAsync(url: URL?, color: Color = Color("accent")) -> CachedAsyncImage<_ConditionalContent<_ConditionalContent<ProgressView<EmptyView, EmptyView>, Image>, some View>> {
        CachedAsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let img):
                img.resizable()
            default:
                color
                    .opacity(0.1)
                    .overlay(
                        Image(systemName: "square.3.layers.3d.down.right.slash")
                            .foregroundColor(color)
                            .brightness(-0.5)
                    )
            }
        }
    }
}

struct Blur: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = UIBlurEffect(style: style)
    }
}

struct ShrinkingButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .animation(.spring(), value: configuration.isPressed)
    }
}

extension UIScreen{
   static let ScreenWidth = UIScreen.main.bounds.size.width
   static let ScreenHeight = UIScreen.main.bounds.size.height
   static let ScreenSize = UIScreen.main.bounds.size
}

extension Image {
    static var ciContext = CIContext()

    static func qrCodeImage(for input: String) -> Image? {
        let data = input.data(using: String.Encoding.utf8)
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        qrFilter.setValue(data, forKey: "inputMessage")

        guard let ciImage = qrFilter.outputImage else { return nil }
        let cgImage = ciContext.createCGImage(ciImage, from: ciImage.extent)
        let uiImage = UIImage(cgImage: cgImage!)
        let image = Image(uiImage: uiImage).interpolation(.none)

        return image
    }
}

extension Color {
    init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0

        let length = hexSanitized.count

        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else { return nil }

        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0

        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0

        } else {
            return nil
        }

        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
