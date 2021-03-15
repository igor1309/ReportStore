//
//  UpdateEntityViaKeyPath.swift
//  ReportStoreTests
//
//  Created by Igor Malyarov on 27.01.2021.
//

import XCTest
import CoreData
import CoreDataTengizReportSP
@testable import ReportStore

final class UpdateEntityViaKeyPath: BaseTestCase {
    func testUpdateReportViaKeyPath() throws {
        let report = try reportStore.sampleReport()

        let company = "Test Company #2"
        let month = 12
        let year = 2022
        let date = Date()
        let revenue = 3_000_000.00
        let dailyAverage = 300_000.00
        let totalExpenses = 2_200_000.00
        let balance = 800_000.00
        let openingBalance = -300_000.00
        let runningBalance = 500_000.00
        let note = "Note Some Note"

        var updatedReport = reportStore.update(report, keyPath: \Report.company, to: company)
        updatedReport = reportStore.update(updatedReport, keyPath: \Report.month, to: month)
        updatedReport = reportStore.update(updatedReport, keyPath: \Report.year, to: year)
        updatedReport = reportStore.update(updatedReport, keyPath: \Report.date, to: date)
        updatedReport = reportStore.update(updatedReport, keyPath: \Report.revenue, to: revenue)
        updatedReport = reportStore.update(updatedReport, keyPath: \Report.dailyAverage, to: dailyAverage)
        updatedReport = reportStore.update(updatedReport, keyPath: \Report.totalExpenses, to: totalExpenses)
        updatedReport = reportStore.update(updatedReport, keyPath: \Report.balance, to: balance)
        updatedReport = reportStore.update(updatedReport, keyPath: \Report.openingBalance, to: openingBalance)
        updatedReport = reportStore.update(updatedReport, keyPath: \Report.runningBalance, to: runningBalance)
        updatedReport = reportStore.update(updatedReport, keyPath: \Report.note, to: note)

        XCTAssertEqual(updatedReport.company,company)
        XCTAssertEqual(updatedReport.month, month)
        XCTAssertEqual(updatedReport.year, year)
        XCTAssertEqual(updatedReport.date, date)
        XCTAssertEqual(updatedReport.revenue, revenue)
        XCTAssertEqual(updatedReport.dailyAverage, dailyAverage)
        XCTAssertEqual(updatedReport.totalExpenses, totalExpenses)
        XCTAssertEqual(updatedReport.balance, balance)
        XCTAssertEqual(updatedReport.openingBalance, openingBalance)
        XCTAssertEqual(updatedReport.runningBalance, runningBalance)
        XCTAssertEqual(updatedReport.note, note)
    }

    func testUpdateReportGroupViaKeyPath() throws {
        let report = try reportStore.sampleReport()
        report.company = "Company 1"

        let group = try reportStore.sampleReportGroup(for: report)

        let report2 = try reportStore.sampleReport()
        let title = "Group 2"
        let groupNumber = 3
        let amount = 200_000.00
        let target = 0.25
        let items = try reportStore.sampleReportItems(for: group, itemCount: 10)
        let note = ""

        var updatedGroup = reportStore.update(group, keyPath: \ReportGroup.report, to: report2)
        updatedGroup = reportStore.update(group, keyPath: \ReportGroup.title, to: title)
        updatedGroup = reportStore.update(group, keyPath: \ReportGroup.groupNumber, to: groupNumber)
        updatedGroup = reportStore.update(group, keyPath: \ReportGroup.amount, to: amount)
        updatedGroup = reportStore.update(group, keyPath: \ReportGroup.target, to: target)
        updatedGroup = reportStore.update(group, keyPath: \ReportGroup.items, to: items)
        updatedGroup = reportStore.update(group, keyPath: \ReportGroup.note, to: note)

        XCTAssertEqual(updatedGroup.id, group.id, "Error updating Report Group")
        XCTAssertEqual(updatedGroup.report, report2, "Error updating Report Group")
        XCTAssertEqual(updatedGroup.title, title, "Error updating Report Group")
        XCTAssertEqual(updatedGroup.groupNumber, groupNumber, "Error updating Report Group")
        XCTAssertEqual(updatedGroup.amount, amount, "Error updating Report Group")
        XCTAssertEqual(updatedGroup.target, target, "Error updating Report Group")
        XCTAssertEqual(updatedGroup.items.count, items.count, "Error updating Report Group")
        XCTAssertEqual(updatedGroup.note, note, "Error updating Report Group")
    }

    func testUpdateReportItemViaKeyPath() throws {
        let report = try reportStore.sampleReport()
        let group = try reportStore.sampleReportGroup(for: report)
        let item = try reportStore.sampleReportItem(for: group)

        let group2 = try reportStore.sampleReportGroup(for: report)
        let itemNumber = 2
        let title = "Item"
        let amount = 100_000.00
        let hasIssue = true
        let note = ""

        var updatedItem = reportStore.update(item, keyPath: \ReportItem.group, to: group2)
        updatedItem = reportStore.update(updatedItem, keyPath: \ReportItem.itemNumber, to: itemNumber)
        updatedItem = reportStore.update(updatedItem, keyPath: \ReportItem.title, to: title)
        updatedItem = reportStore.update(updatedItem, keyPath: \ReportItem.amount, to: amount)
        updatedItem = reportStore.update(updatedItem, keyPath: \ReportItem.hasIssue, to: hasIssue)
        updatedItem = reportStore.update(updatedItem, keyPath: \ReportItem.note, to: note)

        XCTAssertEqual(updatedItem.id, item.id, "Error updating Report Item")
        XCTAssertEqual(updatedItem.group, group2, "Error updating Report Item")
        XCTAssertEqual(updatedItem.itemNumber, itemNumber, "Error updating Report Item")
        XCTAssertEqual(updatedItem.title, title, "Error updating Report Item")
        XCTAssertEqual(updatedItem.amount, amount, "Error updating Report Item")
        XCTAssertEqual(updatedItem.hasIssue, hasIssue, "Error updating Report Item")
        XCTAssertEqual(updatedItem.note, note, "Error updating Report Item")
    }


}
