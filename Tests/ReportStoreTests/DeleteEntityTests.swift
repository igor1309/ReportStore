//
//  DeleteEntityTests.swift
//  ReportStoreTests
//
//  Created by Igor Malyarov on 22.01.2021.
//

import XCTest
import CoreData
@testable import ReportStore

final class DeleteEntityTests: BaseTestCase {

    // MARK: 'database is empty' check is in testBaseTestCase()

    func testDeleteReport() throws {
        let report = try reportStore.sampleReport()

        var getReports = reportStore.getReports()
        XCTAssertEqual(report.id, getReports.first?.id)
        XCTAssertEqual(getReports.count, 1, "Error adding Report to context")

        reportStore.delete(report)
        getReports = reportStore.getReports()
        XCTAssert(getReports.isEmpty, "Error deleting Report")
    }

    func testDeleteReportGroup() throws {
        let report = try reportStore.sampleReport()
        let group = try reportStore.sampleReportGroup(for: report)

        var getGroups = reportStore.getReportGroups()
        XCTAssertEqual(group.id, getGroups.first?.id)
        XCTAssertEqual(getGroups.count, 1, "Error adding Report Group to context")

        reportStore.delete(group)
        getGroups = reportStore.getReportGroups()
        XCTAssert(getGroups.isEmpty, "Error deleting Report Grooup")
    }

    func testDeleteReportItem() throws {
        let report = try reportStore.sampleReport()
        let group = try reportStore.sampleReportGroup(for: report)
        let item = try reportStore.sampleReportItem(for: group)

        var getItems = reportStore.getReportItems()
        XCTAssertEqual(item.id, getItems.first?.id)
        XCTAssertEqual(getItems.count, 1, "Error adding Report Item to context")

        reportStore.delete(item)
        getItems = reportStore.getReportItems()
        XCTAssert(getItems.isEmpty, "Error deleting Report Item")
    }
}
