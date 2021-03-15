//
//  SampleDataTests.swift
//  RBizReportAppTests
//
//  Created by Igor Malyarov on 25.01.2021.
//

import XCTest
import CoreData
import CoreDataTengizReportSP
@testable import ReportStore

class SampleDataTests: BaseTestCase {

    // MARK: - Report

    func testSampleReport() throws {
        try reportStore.sampleReport()

        XCTAssertEqual(reportStore.count(for: Report.fetchRequest()), 1, "sampleReport() should create 1 Report")
    }

    // MARK: - Report Group(s)

    func testSampleReportGroupNoItems() throws {
        let report = try reportStore.sampleReport()
        try reportStore.sampleReportGroup(for: report)

        XCTAssertEqual(reportStore.count(for: ReportGroup.fetchRequest()), 1, "sampleReportGroup(for:) should create 1 Report Group")
        XCTAssertEqual(reportStore.count(for: ReportItem.fetchRequest()), 0, "sampleReportGroup(for:) should create 0 Report Items")
    }

    func testSampleReportGroupWithItems() throws {
        let report = try reportStore.sampleReport()
        let count = 10
        try reportStore.sampleReportGroup(for: report, itemCount: count)

        XCTAssertEqual(reportStore.count(for: ReportGroup.fetchRequest()), 1, "sampleReportGroup(for:) should create 1 Report Group")
        XCTAssertEqual(reportStore.count(for: ReportItem.fetchRequest()), count, "sampleReportGroup(for:itemCount:) should create \(count) Report Items")
    }

    func testSampleReportGroups() throws {
        let report = try reportStore.sampleReport()
        let groupCount = 15
        let itemCount = 13
        let groups = try reportStore.sampleReportGroups(for: report, groupCount: groupCount, itemCount: itemCount)

        XCTAssertEqual(reportStore.getReports().count, 1, "sampleReportGroups(for:groupCount:itemCount:) should create 1 Report")

        XCTAssertEqual(groups.count, groupCount, "sampleReportGroups(for:groupCount:itemCount:) should create \(groupCount) Report Groups")
        XCTAssertEqual(reportStore.getReportGroups().count, groupCount, "sampleReportGroups(for:groupCount:itemCount:) should create \(groupCount) Report Groups")
        XCTAssertEqual(reportStore.count(for: ReportGroup.fetchRequest()), groupCount, "sampleReportGroups(for:groupCount:itemCount:) should create \(groupCount) Report Groups")

        XCTAssertEqual(reportStore.count(for: ReportItem.fetchRequest()), groupCount * itemCount, "sampleReportGroups(for:groupCount:itemCount:) should create \(groupCount * itemCount) Report Items")
    }

    func testSampleReportGroupsDefaultValues() throws {
        let report = try reportStore.sampleReport()
        let groups = try reportStore.sampleReportGroups(for: report)

        XCTAssertEqual(reportStore.getReports().count, 1, "sampleReportGroups(for:) with default params should create 1 Report")

        XCTAssertEqual(groups.count, 5, "sampleReportGroups(for:) with default params should create 5 Report Groups")

        XCTAssertEqual(reportStore.count(for: ReportItem.fetchRequest()), 50, "sampleReportGroups(for:) with default params should create 50 Report Items")
    }

    // MARK: - Report Item(s)

    func testSampleReportItem() throws {
        let report = try reportStore.sampleReport()
        let group = try reportStore.sampleReportGroup(for: report)
        try reportStore.sampleReportItem(for: group)

        XCTAssertEqual(reportStore.count(for: ReportItem.fetchRequest()), 1, "sampleReportItem(for:) should create 1 Report Item")
    }

    func testSampleReportItems() throws {
        let report = try reportStore.sampleReport()
        let group = try reportStore.sampleReportGroup(for: report)

        let count = 50
        let items = try reportStore.sampleReportItems(for: group, itemCount: count)

        XCTAssertEqual(items.count, count, "sampleReportItems(for:itemCount:) should create \(count) Report Items")
        XCTAssertEqual(reportStore.getReportItems().count, count, "sampleReportItems(for:itemCount:) should create \(count) Report Items")
        XCTAssertEqual(reportStore.count(for: ReportItem.fetchRequest()), count, "sampleReportItems(for:itemCount:) should create \(count) Report Items")
    }

}
