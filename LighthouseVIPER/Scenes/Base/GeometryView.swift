//
//  GeoStack.swift
//  LighthouseVIPER
//
//  Created by Kenji Arai on 2026/04/09.
//

import SwiftUI

struct GeometryView<Content: View>: View {
    
    let content: (GeometryProxy) -> Content
    
    init(
        @ViewBuilder content: @escaping (GeometryProxy) -> Content
    ) {
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geo in
            content(geo)
                .frame(width: geo.size.width, height: geo.size.height)
        }
    }
}
