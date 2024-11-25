//
//  NewsRowView.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 23.11.24.
//

import SwiftUI

struct NewsRowView: View {
    let news: News

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            AsyncImage(url: URL(string: news.imageUrl)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } placeholder: {
                ProgressView()
                    .frame(width: 60, height: 60)
            }

            VStack(alignment: .leading, spacing: 5) {
                Text(news.title)
                    .font(.headline)
                    .lineLimit(2)
                
                Text(news.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)

                Text(news.publishedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 5)
    }
}
