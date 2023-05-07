//
//  SearchBar.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/30/23.
//

import Foundation
import SwiftUI

struct SearchBar: UIViewRepresentable {
    func makeUIView(context: Context) -> UISearchBar {
        UISearchBar(frame: .zero)
    }
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.placeholder = "Search"
    }
}

