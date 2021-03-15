//
//  GetReportGroupsAndItemsTests.swift
//  ReportStoreTests
//
//  Created by Igor Malyarov on 22.01.2021.
//

import XCTest
import CoreData
@testable import ReportStore

final class GetReportGroupsAndItemsTests: BaseTestCase {

    func testGetReportGroups() throws {
        let report = try reportStore.sampleReport()
        let targetCount = 10
        for _ in 0..<targetCount {
            try reportStore.sampleReportGroup(for: report)
        }

        let getGroups = reportStore.getReportGroups()
        XCTAssertEqual(getGroups.count, targetCount)
    }

    func testGetReportItems() throws {
        let report = try reportStore.sampleReport()
        let group = try reportStore.sampleReportGroup(for: report)
        let targetCount = 10
        for _ in 0..<targetCount {
            try reportStore.sampleReportItem(for: group)
        }

        let getItems = reportStore.getReportItems()
        XCTAssertEqual(getItems.count, targetCount)
    }

}
