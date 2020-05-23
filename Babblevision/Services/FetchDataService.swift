//
//  FetchDataService.swift
//  Babblevision
//
//  Created by Andrew Hao on 5/22/20.
//  Copyright © 2020 g9Labs. All rights reserved.
//

import Combine
import Foundation
import CSV
import AppCenterAnalytics

protocol InfluxService {
  func makeQuery(with query: String?) -> AnyPublisher<[MeasurementGroupViewModel], Error>
  var defaultQuery: String { get }
}

class FetchDataService: InfluxService {
  var server: String
  var token: String
  var org: String
  var bucket: String
  var defaultQuery: String
  var queryTimeRangeStart: String

  
  init?() {
    guard let INFLUXDB_SERVER: String = try? AppConfiguration.value(for: "INFLUXDB_SERVER"),
      let INFLUXDB_TOKEN: String = try? AppConfiguration.value(for: "INFLUXDB_TOKEN"),
      let INFLUXDB_ORG: String = try? AppConfiguration.value(for: "INFLUXDB_ORG"),
      let INFLUXDB_BUCKET: String = try? AppConfiguration.value(for: "INFLUXDB_BUCKET") else {
        MSAnalytics.trackEvent("initialized_fetch_data_service", withProperties: ["success": "false"])
        return nil
    }
    
    self.server = INFLUXDB_SERVER
    self.token = INFLUXDB_TOKEN
    self.bucket = INFLUXDB_BUCKET
    self.org = INFLUXDB_ORG
    self.queryTimeRangeStart = "-3h"
    
    MSAnalytics.trackEvent("initialized_fetch_data_service", withProperties: ["success": "true"])
    
    self.defaultQuery = """
    from(bucket: "\(self.bucket)")
    |> range(start: \(self.queryTimeRangeStart))
    """
  }
  
  func setTimeRangeStart(_ range: String) -> InfluxService {
    self.queryTimeRangeStart = range
    return self
  }

  func makeQuery(with query: String?) -> AnyPublisher<[MeasurementGroupViewModel], Error> {
    let url = URL(string: "https://\(self.server)/api/v2/query?org=\(self.org)")

    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.setValue("application/csv", forHTTPHeaderField: "Accept")
    request.setValue("application/vnd.flux", forHTTPHeaderField: "Content-Type")
    request.setValue("Token \(self.token)", forHTTPHeaderField: "Authorization")
    request.httpBody = (query ?? self.defaultQuery).data(using: .utf8)

    return URLSession.shared.dataTaskPublisher(for: request)
      .tryMap() { element -> String in
        guard let httpResponse = element.response as? HTTPURLResponse,
          httpResponse.statusCode == 200
        else {
          throw URLError(.badServerResponse)
        }
        return String(data: element.data, encoding: .utf8)!
      }
      .map(transformCsv)
      .map(sortGroups)
      .receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
  }

  func sortGroups(groups: [MeasurementGroupViewModel]) -> [MeasurementGroupViewModel] {
    return groups.sorted {
      if $0.measurement == $1.measurement {
        return $0.field < $1.field
      }
      return $0.measurement < $1.measurement
    }
  }
  
  func transformCsv(csv: String) -> [MeasurementGroupViewModel] {
    let trimmed = csv.trimmingCharacters(in: CharacterSet.whitespaces)
    let chunks = trimmed.components(separatedBy: "\r\n\r\n").filter({!$0.isEmpty})
    
    var groups = [MeasurementGroup]()
    
    for chunk in chunks {
      let reader = try! CSVReader(string: chunk, hasHeaderRow: true)
      
      var group = MeasurementGroup(id: UUID().uuidString, data: [])
    
      while reader.next() != nil {
        let row = Measurement(id: UUID().uuidString,
                              device_id: reader["device_id"]!,
                              table: reader["table"]!,
                              time: reader["_time"]!,
                              field: reader["_field"]!,
                              measurement: reader["_measurement"]!,
                              value: reader["_value"]!)

        group.data.append(row)
      }
      groups.append(group)
    }
    
    return groups.map(MeasurementGroupViewModel.init)
  }
}
  
