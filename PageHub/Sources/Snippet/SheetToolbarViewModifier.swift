//
//  SheetToolbarViewModifier.swift
//  PageHub
//
//  Created by 노우영 on 11/1/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct SheetToolbarViewModifier<Item: Identifiable, Sheet: View, Toolbar: View>: ViewModifier {
    
    @Binding var item: Item?
    @Binding var config: ToolbarConfig
    
    @ViewBuilder var sheet: (Item) -> Sheet
    @ViewBuilder var toolbar: Toolbar
    
    @State var sheetViewSize: CGSize = .zero
    
    func body(content: Content) -> some View {
        content
            .sheet(item: $item) { item in
                sheet(item)
                    .presentationDetents(config.presentationDedents, selection: $config.selection)
                    .trackSize { size in
                        sheetViewSize = size
                    }
                    .presentationBackgroundInteraction(config.backgroundInteraction)
            }
            .overlay(alignment: .bottom) {
                ForEach(sections: toolbar) { section in
                    let values = section.containerValues
                    let alignment = values.alignment
                    let hStackAlignment: Alignment = alignment == .trailing ? .trailing : .leading
                    
                    HStack {
                        if hStackAlignment == .trailing {
                            Spacer()
                        }
                        
                        section.content
                        
                        if hStackAlignment == .leading {
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: hStackAlignment)
                    .offset(y: -sheetViewSize.height)
                }
            }
            .onChange(of: config.selection) { oldValue, newValue in
                if newValue == .fraction(0.01) {
                    item = nil
                    config.selection = oldValue
                }
            }
    }
}
