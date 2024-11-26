//
//  View+sheet.swift
//  PageHub
//
//  Created by 노우영 on 11/1/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

extension View {
    /// Sheet와 툴바를 포함한 View를 생성합니다.
    ///
    /// ```
    /// struct HowToUse: View {
    ///     @State var config = ToolbarConfig(presentationDedents: [.large], selection: .large, backgroundInteraction: .enabled)
    ///     @State var item: Int = 0
    ///
    ///     var body: some View {
    ///         VStack {
    ///             // Content
    ///         }
    ///         .sheet(config: $config, item: $item) { item in
    ///             ItemView(item)
    ///         } toolbar: {
    ///             SheetToolbarGroup(alignment: .trailing) {
    ///                 Button("Increase") {
    ///                     item += 1
    ///                 }
    ///             }
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - config: `ToolbarConfig`를 관리하는 바인딩
    ///   - item: Sheet에 바인딩될 Identifiable 데이터
    ///   - content: Sheet 내부에 표시될 뷰
    ///   - toolbar: 툴바에 표시될 뷰
    /// - Returns: Sheet와 툴바가 포함된 View
    func sheet<Item, Content, ToolbarContent>(
        config: Binding<ToolbarConfig>,
        item: Binding<Item?>,
        content: @escaping (Item) -> Content,
        toolbar: @escaping () -> ToolbarContent
    ) -> some View where Item: Identifiable, Content: View, ToolbarContent: View {
        self.modifier(
            SheetToolbarViewModifier(
                item: item,
                config: config,
                sheet: content,
                toolbar: toolbar
            )
        )
    }
}
