//
//  NewsListScreen.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 22.11.24.
//

import SwiftUI

struct NewsListScreen: View {
  @Environment(\.injected) private var injected: DIContainer
  
  @State private var viewModel: NewsViewModel = NewsViewModel()
  @State private var searchQuery: String = ""
  
  var body: some View {
    NavigationView {
      VStack {
        
        TextField("Search news...", text: $searchQuery, onCommit: {
          viewModel.fetchNews(query: searchQuery)
        })
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
        
        List(viewModel.news) { news in
          NavigationLink(destination: NewsDetailView(news: news)) {
            NewsRowView(news: news)
          }
        }
        .navigationTitle("Latest News")
      }
    }
    .onAppear {
      viewModel.useCase = injected.useCases
      viewModel.fetchNews()
    }
  }
  
}

#Preview {
  NewsListScreen()
}
