//
//  View+sheet.swift
//  PageHub
//
//  Created by 노우영 on 11/1/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

extension View {
    ///
    /// ```
    ///struct HowToUse: View {
    ///
    ///    @State var config = ToolbarConfig(presentationDedents: [.large], selection: .large, backgroundInteraction: .enabled)
    ///    @State var item: Int = 0
    ///
    ///
    ///    var body: some View {
    ///        VStack {
    ///
    ///        }
    ///        .sheet(config: $config, item: $item) { item in
    ///            ItemView(item)
    ///        } toolbar: {
    ///            SheetToolbarGroup(alignment: .trailing) {
    ///                Button("Increase") {
    ///                    item += 1
    ///                }
    ///            }
    ///        }
    ///
    ///    }
    ///}
    /// ```
    func sheet<Item, Content, T>(
        config: Binding<ToolbarConfig>,
        item: Binding<Item?>,
        @ViewBuilder content: @escaping (Binding<Item>) -> Content,
        toolbar: () -> SheetToolbarGroup<T>
    ) -> some View where Item : Identifiable, Content : View, T: View {
        self
            .modifier(
                SheetToolbarViewModifier(
                    item: item,
                    config: config,
                    sheet: { i in
                    content(i)
                }, toolbar: {
                    toolbar()
                })
            )
    }
}
