//
//  DeleteCascadeNullifyTests.swift
//  ReportStoreTests
//
//  Created by Igor Malyarov on 22.01.2021.
//

import XCTest
import CoreData
@testable import ReportStore

final class DeleteCascadeNullifyTests: BaseTestCase {

    // MARK: 'database is empty' check is in testBaseTestCase()

    func testDeleteReport() throws {
        let report = try reportStore.sampleReport()
        let getReports = reportStore.getReports()
        XCTAssertEqual(getReports.count, 1, "Error creating Report")
        XCTAssertEqual(getReports.first, report, "Error creating Report")

        let targetCount = 10

        for _ in 0..<targetCount {
            try reportStore.sampleReportGroup(for: report)
        }
        let groups = reportStore.getReportGroups()
        XCTAssertEqual(groups.count, targetCount, "Error creating \(targetCount) groups")
        XCTAssertEqual(reportStore.getReports().count, 1, "Error creating \(targetCount) groups")

        let firstGroup = try XCTUnwrap(groups.first)
        reportStore.delete(firstGroup)
        XCTAssertEqual(reportStore.getReportGroups().count, targetCount - 1, "Error deleting group")

        let lastGroup = try XCTUnwrap(groups.last)
        reportStore.delete(lastGroup)
        XCTAssertEqual(reportStore.getReportGroups().count, targetCount - 2, "Error deleting group")

        let group = groups[1]
        reportStore.delete(group)
        XCTAssertEqual(reportStore.getReportGroups().count, targetCount - 3, "Error deleting group")

        XCTAssertEqual(reportStore.getReports().count, 1, "Error Group Nullify delete")

        let reports = reportStore.getReports()
        let firstReport = try XCTUnwrap(reports.first)
        reportStore.delete(firstReport)
        XCTAssert(reportStore.getReports().isEmpty, "Error deleting report")
        XCTAssert(reportStore.getReportGroups().isEmpty, "Error Cascade delete")
    }

    func testDeleteReportGroup() throws {
        let report = try reportStore.sampleReport()
        let group = try reportStore.sampleReportGroup(for: report)
        XCTAssertEqual(reportStore.getReportGroups().count, 1, "Error creating Group")
        XCTAssert(reportStore.getReportItems().isEmpty, "Error deleting Report Items")

        let targetCount = 10

        for _ in 0..<targetCount {
            try reportStore.sampleReportItem(for: group)
        }
        XCTAssertEqual(reportStore.getReportItems().count, targetCount, "Error creating \(targetCount) items")

        let items = reportStore.getReportItems()

        let firstItem = try XCTUnwrap(items.first)
        reportStore.delete(firstItem)
        XCTAssertEqual(reportStore.getReportItems().count, targetCount - 1, "Error deleting item")

        let lastItem = try XCTUnwrap(items.last)
        reportStore.delete(lastItem)
        XCTAssertEqual(reportStore.getReportItems().count, targetCount - 2, "Error deleting item")

        let item = items[1]
        reportStore.delete(item)
        XCTAssertEqual(reportStore.getReportItems().count, targetCount - 3, "Error deleting item")

        XCTAssertEqual(reportStore.getReportGroups().count, 1, "Error Item Nullify delete")

        let groups = reportStore.getReportGroups()
        let firstGroup = try XCTUnwrap(groups.first)
        reportStore.delete(firstGroup)
        XCTAssertEqual(reportStore.getReportGroups().count, 0, "Error deleting group")
        XCTAssertEqual(reportStore.getReportItems().count, 0, "Error Cascade delete")
    }

    func testDeleteReportItem() throws {
        let report = try reportStore.sampleReport()
        let group = try reportStore.sampleReportGroup(for: report, itemCount: 10)
        XCTAssertEqual(reportStore.getReportItems().count, 10)

        let first = try XCTUnwrap(group.items.first)
        reportStore.delete(first)
        XCTAssertEqual(reportStore.getReportItems().count, 9, "Error deleting item")
        XCTAssertEqual(reportStore.getReportGroups().count, 1, "Error Item Nullify delete")

        let last = try XCTUnwrap(group.items.last)
        reportStore.delete(last)
        XCTAssertEqual(reportStore.getReportItems().count, 8, "Error deleting item")
        XCTAssertEqual(reportStore.getReportGroups().count, 1, "Error Item Nullify delete")

        reportStore.delete(group)
        XCTAssertEqual(reportStore.getReportItems().count, 0, "Error Item Cascade delete")
        XCTAssertEqual(reportStore.getReportGroups().count, 0, "Error Group delete")
    }
}
