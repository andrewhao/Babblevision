//
//  GraphViewModel.swift
//  Babblevision
//
//  Created by Andrew Hao on 8/16/20.
//  Copyright © 2020 g9Labs. All rights reserved.
//

import Foundation
import Combine
import SwiftDate

class GraphViewModel: ObservableObject, Identifiable {

  @Published var dataSource: MeasurementGroupViewModel
  
  private var disposables = Set<AnyCancellable>()

  init(measurementGroupViewModel: MeasurementGroupViewModel) {
    self.dataSource = measurementGroupViewModel
  }
}
