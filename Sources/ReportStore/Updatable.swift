//
//  Updatable.swift
//  RBizReportApp
//
//  Created by Igor Malyarov on 27.01.2021.
//

import CoreData
import CoreDataTengizReportSP

/// based on `Stubbable` by John Sundel
/// https://www.swiftbysundell.com/articles/defining-testing-data-in-swift/
protocol Updatable {}

extension Updatable {
    func update<T>(_ keyPath: WritableKeyPath<Self, T>,
                   to value: T) -> Self {
        var copy = self
        copy[keyPath: keyPath] = value
        return copy
    }
}

extension Report: Updatable {}
extension ReportGroup: Updatable {}
extension ReportItem: Updatable {}
