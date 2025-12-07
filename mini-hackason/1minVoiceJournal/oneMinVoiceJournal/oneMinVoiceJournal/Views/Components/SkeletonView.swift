import SwiftUI

struct SkeletonView: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color.gray.opacity(0.2))
            .redacted(reason: .placeholder)
    }
}

#Preview {
    SkeletonView()
        .padding()
}
