//
//  PickerSection.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/30/23.
//

import SwiftUI

struct PickerSection: View {
    let title: String
    @Binding var selection: Int
    let tabs: [(String, Int)]
    
    var body: some View {
        Section {
            HStack {
                Text("\(title):")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 80/255, green: 129/255, blue: 255/255))
                    .padding(.horizontal, 25)
                Spacer()
            }
            
            Picker(selection: $selection, label: Text(title)) {
                ForEach(tabs, id: \.1) { tab in
                    Text(tab.0).tag(tab.1)
                }
            }
            .frame(width: 345)
            .environment(\.colorScheme, .light)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(red: 80/255, green: 129/255, blue: 255/255), lineWidth: 2)
            )
            .padding(.bottom)
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}
