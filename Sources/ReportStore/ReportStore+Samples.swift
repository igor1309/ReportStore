//
//  ReportStore+Samples.swift
//  RBizReportApp
//
//  Created by Igor Malyarov on 22.01.2021.
//

import Foundation
import CoreDataTengizReportSP

extension ReportStore {

    // MARK: - Sample Report

    @discardableResult
    func sampleReport() throws -> Report {
        try addReport(company: "Test", month: 9, year: 2020, date: Date(), revenue: 1_000_000, dailyAverage: 100_000, totalExpenses: 800_000, balance: 200_000, openingBalance: -100_000, runningBalance: 100_000, note: "").get()
    }

    @discardableResult
    func sampleReports(count: Int) throws -> [Report] {
        try (0..<count).map { index in
            try addReport(company: "Test \(index + 1)", month: 9, year: 2020, date: Date(), revenue: 1_000_000, dailyAverage: 100_000, totalExpenses: 800_000, balance: 200_000, openingBalance: -100_000, runningBalance: 100_000, note: "").get()
        }
    }

    // MARK: - Sample Report Group(s)

    @discardableResult
    func sampleReportGroup(for report: Report, itemCount: Int = 0) throws -> ReportGroup {
        let group = try addReportGroup(report: report, groupNumber: 2, title: "Group", amount: 150_000, target: 0.2, note: "").get()
        group.items = try sampleReportItems(for: group, itemCount: itemCount)
        return group
    }

    @discardableResult
    func sampleReportGroups(for report: Report, groupCount: Int = 5, itemCount: Int = 10) throws -> [ReportGroup] {
        try (0..<groupCount).map { index -> ReportGroup in
            let group = try addReportGroup(report: report, groupNumber: index + 1, title: "Group \(index)", amount: 150_000, target: 0.2, note: "").get()
            try sampleReportItems(for: group, itemCount: itemCount)
            return group
        }
    }

    // MARK: - Sample Report Item(s)

    @discardableResult
    func sampleReportItem(for group: ReportGroup) throws -> ReportItem {
        try addReportItem(group: group, itemNumber: 2, title: "Item", amount: 100_000, hasIssue: false, note: "").get()
    }

    @discardableResult
    func sampleReportItems(for group: ReportGroup, itemCount: Int) throws -> [ReportItem] {
        try (0..<itemCount).map { index -> ReportItem in
            try addReportItem(group: group, itemNumber: index + 1, title: "Item \(index)", amount: 100_000, hasIssue: true, note: "").get()
        }
    }
}
