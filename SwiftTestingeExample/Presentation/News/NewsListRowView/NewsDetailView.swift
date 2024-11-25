//
//  NewsDetailView.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 23.11.24.
//

import SwiftUI

struct NewsDetailView: View {
    let news: News

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                AsyncImage(url: URL(string: news.imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom)

                Text(news.title)
                    .font(.title)
                    .bold()
                    .padding(.bottom, 5)

                Text("Published on \(news.publishedDate)")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Divider()

                Text(news.content)
                    .font(.body)
                    .padding(.top, 5)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
