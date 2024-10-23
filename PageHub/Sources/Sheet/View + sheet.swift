//
//  View + sheet.swift
//  PageHub
//
//  Created by 노우영 on 10/23/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

extension View {
    func sheet<Item, Content, Toolbar>(item: Binding<Item?>, onDismiss: (() -> Void)? = nil, @ViewBuilder content: @escaping (Item) -> Content, toolbar: @escaping () -> Toolbar ) -> some View where Item : Identifiable, Content : View, Toolbar: View {
        self
            .sheet(item: item) { item in
                content(item)
            }
    }
}


