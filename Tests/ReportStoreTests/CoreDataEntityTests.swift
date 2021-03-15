//
//  CoreDataEntityTests.swift
//  ReportStoreTests
//
//  Created by Igor Malyarov on 22.01.2021.
//

import XCTest
import CoreData
@testable import ReportStore

final class CoreDataEntityTests: BaseTestCase {
    func testEntityRelationships() throws {
        let report = try reportStore.sampleReport()
        let group = try reportStore.sampleReportGroup(for: report, itemCount: 1)
        let item = try XCTUnwrap(reportStore.getReportItems().first)

        XCTAssertEqual(item.group, group, "ERROR setting Group items")
        XCTAssertNotNil(group.items_, "ERROR setting Group items")
        XCTAssertNotNil(group.items.first)

        let first = try XCTUnwrap(group.items.first)
        XCTAssertEqual(first, item)

        XCTAssertFalse(group.items.isEmpty)
        XCTAssertEqual(group.items.count, 1)

        XCTAssertEqual(group.report, report, "ERROR setting Reports group")
        XCTAssertNotNil(report.groups_, "ERROR setting Reports group")
        XCTAssertNotNil(report.groups.first)
        if let first = try? XCTUnwrap(report.groups.first) {
            XCTAssertEqual(first, group)
        }
        XCTAssertFalse(report.groups.isEmpty)
        XCTAssertEqual(report.groups.count, 1)
    }

    func testEntityComputedProperties() throws {
        let report = try reportStore.sampleReport()
        let count = 20
        let group = try reportStore.sampleReportGroup(for: report, itemCount: count)
        //let item = try XCTUnwrap(reportStore.getReportItems().first)

        XCTAssertNotNil(group.items.first, "ERROR setting Group items")
        XCTAssertEqual(group.items.count, count, "ERROR setting Group items")

        XCTAssertEqual(group.amountCalculated, Double(count) * 100_000, "ERROR calculating Group amountCalculated property")
        XCTAssertEqual(group.amountDelta, Double(count) * -92_500, "ERROR calculating Group amountDelta property")
        XCTAssertFalse(group.isAmountMatch, "ERROR calculating Group isAmountMatch property")
        XCTAssertTrue(group.hasIssue, "ERROR calculating Group hasIssue property")

        XCTAssertNotNil(report.groups_, "ERROR setting Reports group")
        XCTAssertEqual(group.report, report, "ERROR setting Reports group")
        XCTAssertNotNil(report.groups.first, "ERROR setting Reports group")
        XCTAssertEqual(report.groups.count, 1, "ERROR setting Reports group")

        XCTAssertEqual(report.calculatedTotalExpenses, Double(count) * 100_000, "ERROR calculationg Report calculatedTotalExpenses property")
        XCTAssertEqual(report.totalExpensesDelta, Double(count) * -60_000, "ERROR calculationg Report totalExpensesDelta property")
        XCTAssertTrue(report.hasIssue, "ERROR calculating Report hasIssue property")
    }

    func testReportWithoutGroupComputedProperties() throws {
        let report = try reportStore.addReport(company: "Test", month: 1, year: 2021, date: Date(), revenue: 900_000, dailyAverage: 30_000, totalExpenses: 1_000_000, balance: 0, openingBalance: -200_000, runningBalance: -300_000, note: "").get()

        XCTAssertFalse(report.isTotalOk, "Total is not ok: Revenue minus Total Expenses is not equal to Balance")
        XCTAssertFalse(report.isBalanceOk, "Balance is not ok: openingBalance + balance is not equal to runningBalance")

        report.balance = -100_000
        XCTAssert(report.isTotalOk, "Total is not ok: Revenue minus Total Expenses is not equal to Balance")
        XCTAssert(report.isBalanceOk, "Balance is not ok: openingBalance + balance is not equal to runningBalance")
    }

    func testReportGroupComputedProperties() throws {
        let totalExpenses = 1_000_000.00
        let report = try reportStore.addReport(company: "Test", month: 1, year: 2021, date: Date(), revenue: 900_000, dailyAverage: 30_000, totalExpenses: totalExpenses, balance: -100_000, openingBalance: -200_000, runningBalance: -300_000, note: "").get()

        let group = try reportStore.addReportGroup(report: report, groupNumber: 1, title: "Group 1", amount: 950_000, target: 0.2, note: "").get()

        var hasIssue = false
        _ = try reportStore.addReportItem(group: group, itemNumber: 1, title: "Item 1", amount: 100_000, hasIssue: hasIssue, note: "").get()
        _ = try reportStore.addReportItem(group: group, itemNumber: 2, title: "Item 2", amount: 200_000, hasIssue: hasIssue, note: "").get()
        _ = try reportStore.addReportItem(group: group, itemNumber: 3, title: "Item 3", amount: 300_000, hasIssue: hasIssue, note: "").get()

        // MARK: Check Group

        XCTAssertNotEqual(group.amount, group.amountCalculated, "Report Group Amount is not equal to sum of Items amounts")
        XCTAssertNotEqual(group.amountDelta, 0, "Report Group amount is not equal to sum of Items amounts")
        XCTAssertFalse(group.isAmountMatch, "Report Group amount is not equal to sum of Items amounts")
        XCTAssertFalse(group.hasIssue)

        hasIssue = true
        _ = try reportStore.addReportItem(group: group, itemNumber: 4, title: "Item 4", amount: 350_000, hasIssue: hasIssue, note: "").get()
        XCTAssertEqual(group.amount, group.amountCalculated, "Report Group Amount is not equal to sum of Items amounts")
        XCTAssertEqual(group.amountDelta, 0, "Report Group amount is not equal to sum of Items amounts")
        XCTAssert(group.isAmountMatch, "Report Group amount is not equal to sum of Items amounts")
        XCTAssert(group.hasIssue)

        // MARK: Check Report

        XCTAssertNotEqual(report.calculatedTotalExpenses, totalExpenses, "Error: calculated Total Expenses not equal to totalExpenses")
        XCTAssertNotEqual(report.totalExpensesDelta, 0, "Error: calculated Total Expenses not equal to totalExpenses")
        XCTAssertFalse(report.isTotalExpensesMatch, "Error: calculated Total Expenses not equal to totalExpenses")

        let group2 = try reportStore.addReportGroup(report: report, groupNumber: 1, title: "Group 1", amount: 50_000, target: 0.2, note: "").get()

        _ = try reportStore.addReportItem(group: group2, itemNumber: 1, title: "Item 2.1", amount: 50_000, hasIssue: false, note: "").get()

        XCTAssertEqual(report.calculatedTotalExpenses, totalExpenses, "Error: calculated Total Expenses not equal to totalExpenses")
        XCTAssertEqual(report.totalExpensesDelta, 0, "Error: calculated Total Expenses not equal to totalExpenses")
        XCTAssert(report.isTotalExpensesMatch, "Error: calculated Total Expenses not equal to totalExpenses")

    }

}

