//
//  TagCloud.swift
//  PackPoint
//
//  Created by Keegan Gaffney on 4/30/23.
//

import SwiftUI

struct TagCloud: View {
    let tags: [String] = [
        "Free WiFi",
        "Outdoor",
        "Quiet",
        "Food",
        "AC",
        "Open Late",
        "Pet Friendly",
        "Study Spot",
        "Kids Friendly",
        "Live Music",
        "Whiteboard",
        "Accessible",
        "Free Parking",
        "Good for Dates"
    ]
    let numberOfTagsInRow = 3

    @Binding public var selectedTags: Set<String>

    var body: some View {
        VStack(alignment: .leading) {
            ForEach(0..<numberOfRows, id: \.self) { rowIndex in
                HStack {
                    ForEach(rowRange(rowIndex), id: \.self) { tagIndex in
                        let tag = tags[tagIndex]
                        Button(action: {
                            if selectedTags.contains(tag) {
                                selectedTags.remove(tag)
                            } else {
                                selectedTags.insert(tag)
                            }
                        }) {
                            Text(tag)
                        }
                        .padding(10)
                        .background(selectedTags.contains(tag) ? Color.blue : Color.white)
                        .foregroundColor(selectedTags.contains(tag) ? Color.white : Color.blue)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                    }
                }
            }
        }
    }

    private var numberOfRows: Int {
        (tags.count + numberOfTagsInRow - 1) / numberOfTagsInRow
    }

    private func rowRange(_ rowIndex: Int) -> Range<Int> {
        let start = rowIndex * numberOfTagsInRow
        let end = min(start + numberOfTagsInRow, tags.count)
        return start..<end
    }
}
