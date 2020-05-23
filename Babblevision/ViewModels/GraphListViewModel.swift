//
//  GraphViewModel.swift
//  Babblevision
//
//  Created by Andrew Hao on 5/24/20.
//  Copyright © 2020 g9Labs. All rights reserved.
//

import Foundation
import Combine
import SwiftDate

class GraphListViewModel: ObservableObject, Identifiable {

  private let influxService: InfluxService?

  @Published var dataSource: [MeasurementGroupViewModel] = []
  
  private var disposables = Set<AnyCancellable>()

  init(influxService: InfluxService?) {
    self.influxService = influxService
    getMeasurements()
  }

  func getMeasurements() {
    guard let influxService = self.influxService else {
      return
    }
    
    influxService.makeQuery(with: influxService.defaultQuery)
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { [weak self] value in
          guard let self = self else { return }
          switch value {
          case .failure:
            self.dataSource = []
          case .finished:
            break
          }
        },
        receiveValue: { [weak self] measurementGroup in
          guard let self = self else { return }
          self.dataSource = measurementGroup
        })
      .store(in: &disposables)
  }
}

class MeasurementGroupViewModel: ObservableObject, Identifiable {
  let wrapped: MeasurementGroup
  let data: [MeasurementViewModel]
  
  init(measurementGroup: MeasurementGroup) {
    self.wrapped = measurementGroup
    self.data = self.wrapped.data.map(MeasurementViewModel.init).sorted(by: { $0.time < $1.time })
  }
  
  var measurement: String {
    return self.last.measurement
  }
  
  var device_id: String {
    return self.last.device_id
  }
  
  var rawValue: String {
    return self.last.rawValue
  }
  
  var time: DateInRegion {
    return self.last.time
  }
  
  var field: String {
    return self.last.field
  }
  
  // MARK: Private
  
  private var last: MeasurementViewModel {
    return self.data.last!
  }
}

class MeasurementViewModel: ObservableObject, Identifiable {
  let wrapped: Measurement

  init(measurement: Measurement) {
    self.wrapped = measurement
  }
  var id: String {
    return self.wrapped.id
  }
  
  var time: DateInRegion {
    return self.wrapped.time.toISODate()!
  }
  
  var measurement: String {
    return self.wrapped.measurement
  }

  var table: String {
    return self.wrapped.table
  }
  
  var field: String {
    return self.wrapped.field
  }

  var device_id: String {
    return self.wrapped.device_id
  }

  var value: MeasurementValue {
    guard let asNumber = Double(self.wrapped.value) else {
      return MeasurementValue.string(self.wrapped.value)
    }
    return MeasurementValue.number(asNumber)
  }
  
  var rawValue: String {
    self.wrapped.value
  }
}

enum MeasurementValue {
  case string(String)
  case number(Double)
}
