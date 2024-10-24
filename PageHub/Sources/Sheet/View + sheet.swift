//
//  View + sheet.swift
//  PageHub
//
//  Created by 노우영 on 10/23/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI


extension View {
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


