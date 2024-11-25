//
//  SwiftTestingeExampleApp.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 20.11.24.
//

import SwiftUI

struct AppView: View {
    
  private let container: DIContainer
  
  init(container: DIContainer) {
    self.container = container
  }
  
  var body: some View {
    VStack {
      NewsListScreen()
        .inject(container)
    }
  }
  
}
