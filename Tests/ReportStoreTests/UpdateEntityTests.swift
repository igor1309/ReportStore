//
//  UpdateEntityTests.swift
//  ReportStoreTests
//
//  Created by Igor Malyarov on 22.01.2021.
//

import XCTest
import CoreData
@testable import ReportStore

final class UpdateEntityTests: BaseTestCase {
    func testUpdateReport() throws {
        let report = try reportStore.sampleReport()

        let company = "Test 2"
        let month = 10
        let year = 2021
        let date = Date()
        let revenue = 2_000_000.00
        let dailyAverage = 200_000.00
        let totalExpenses = 1_600_000.00
        let balance = 400_000.00
        let openingBalance = -200_000.00
        let runningBalance = 200_000.00
        let note = "Note"

        report.company = company
        report.month = month
        report.year = year
        report.date = date
        report.revenue = revenue
        report.dailyAverage = dailyAverage
        report.totalExpenses = totalExpenses
        report.balance = balance
        report.openingBalance = openingBalance
        report.runningBalance = runningBalance
        report.note = note

        let updatedReport = reportStore.update(report)

        XCTAssertEqual(updatedReport.id, report.id, "Error updating Report")
        XCTAssertEqual(updatedReport.company, company, "Error updating Report")
        XCTAssertEqual(updatedReport.month, month, "Error updating Report")
        XCTAssertEqual(updatedReport.year, year, "Error updating Report")
        XCTAssertEqual(updatedReport.date, date, "Error updating Report")
        XCTAssertEqual(updatedReport.revenue, revenue, "Error updating Report")
        XCTAssertEqual(updatedReport.dailyAverage, dailyAverage, "Error updating Report")
        XCTAssertEqual(updatedReport.totalExpenses, totalExpenses, "Error updating Report")
        XCTAssertEqual(updatedReport.balance, balance, "Error updating Report")
        XCTAssertEqual(updatedReport.openingBalance, openingBalance, "Error updating Report")
        XCTAssertEqual(updatedReport.runningBalance, runningBalance, "Error updating Report")
        XCTAssertEqual(updatedReport.note, note, "Error updating Report")
    }

    func testUpdateReportGroup() throws {
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

        group.report = report2
        group.title = title
        group.groupNumber = groupNumber
        group.amount = amount
        group.target = target
        group.items = items
        group.note = note

        let updatedGroup = reportStore.update(group)

        XCTAssertEqual(updatedGroup.id, group.id, "Error updating Report Group")
        XCTAssertEqual(updatedGroup.report, report2, "Error updating Report Group")
        XCTAssertEqual(updatedGroup.title, title, "Error updating Report Group")
        XCTAssertEqual(updatedGroup.groupNumber, groupNumber, "Error updating Report Group")
        XCTAssertEqual(updatedGroup.amount, amount, "Error updating Report Group")
        XCTAssertEqual(updatedGroup.target, target, "Error updating Report Group")
        XCTAssertEqual(updatedGroup.items.count, items.count, "Error updating Report Group")
        XCTAssertEqual(updatedGroup.note, note, "Error updating Report Group")
    }

    func testUpdateReportItem() throws {
        let report = try reportStore.sampleReport()
        let group = try reportStore.sampleReportGroup(for: report)
        let item = try reportStore.sampleReportItem(for: group)        

        let group2 = try reportStore.sampleReportGroup(for: report)
        let itemNumber = 2
        let title = "Item"
        let amount = 100_000.00
        let hasIssue = true
        let note = ""

        item.group = group2
        item.itemNumber = itemNumber
        item.title = title
        item.amount = amount
        item.hasIssue = hasIssue
        item.note = note

        let updatedItem = reportStore.update(item)

        XCTAssertEqual(updatedItem.id, item.id, "Error updating Report Item")
        XCTAssertEqual(updatedItem.group, group2, "Error updating Report Item")
        XCTAssertEqual(updatedItem.itemNumber, itemNumber, "Error updating Report Item")
        XCTAssertEqual(updatedItem.title, title, "Error updating Report Item")
        XCTAssertEqual(updatedItem.amount, amount, "Error updating Report Item")
        XCTAssertEqual(updatedItem.hasIssue, hasIssue, "Error updating Report Item")
        XCTAssertEqual(updatedItem.note, note, "Error updating Report Item")
    }

}
