//
//  DIContainer.swift
//  SwiftTestingeExample
//
//  Created by Revan SADIGLI on 22.11.24.
//

import SwiftUI

struct DIContainer: EnvironmentKey {
  
  let useCases: UseCases
  
  init(useCases: UseCases) {
    self.useCases = useCases
  }
  
  static var defaultValue: Self { Self.default }
  
  private static let `default` = Self(useCases: .defaultValue)
}

extension EnvironmentValues {
  var injected: DIContainer {
    get { self[DIContainer.self] }
    set { self[DIContainer.self] = newValue }
  }
}

extension View {
  
  func inject(
    _ useCases: DIContainer.UseCases) -> some View {
      let container = DIContainer(useCases: useCases)
      return inject(container)
    }
  
  func inject(_ container: DIContainer) -> some View {
    return self
      .environment(\.injected, container)
  }
}
