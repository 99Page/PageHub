//
//  SheetToolbarViewModifier.swift
//  PageHub
//
//  Created by 노우영 on 11/1/24.
//  Copyright © 2024 Page. All rights reserved.
//

import SwiftUI

struct SheetToolbarViewModifier<Item: Identifiable, Sheet: View, Toolbar: View>: ViewModifier {
    
    @State var sheetViewSize: CGSize = .zero
    
    @Binding var item: Item?
    @Binding var config: ToolbarConfig
    
    @ViewBuilder var sheet: (Item) -> Sheet
    @ViewBuilder var toolbar: Toolbar
    
    func body(content: Content) -> some View {
        content
            .sheet(item: $item, content: buildSheet)
            .overlay(alignment: .bottom, content: buildToolbar)
            .onChange(of: config.selection, onSelectionChanged)
    }
    
    private func buildSheet(item: Item) -> some View {
        sheet(item)
            .presentationDetents(config.presentationDedents, selection: $config.selection)
            .trackSize(updateViewSize)
            .presentationBackgroundInteraction(config.backgroundInteraction)
            .onAppear { config.isSheetAppeared = true }
            .onDisappear { config.isSheetAppeared = false }
    }
    
    @ViewBuilder
    private func buildToolbar() -> some View {
        if config.isToolbarPresented {
            toolbar
                .frame(maxWidth: .infinity, alignment: config.alignment)
                .offset(y: -sheetViewSize.height)
        }
    }
    
    private func onSelectionChanged(oldValue: PresentationDetent, newValue: PresentationDetent) {
        if config.isAtMinimumHeightFraction {
            item = nil
            config.selection = oldValue
        }
    }
    
    private func updateViewSize(size: CGSize) {
        sheetViewSize = size
    }
}
