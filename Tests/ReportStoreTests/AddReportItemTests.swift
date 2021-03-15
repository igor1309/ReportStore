//
//  AddReportItemTests.swift
//  ReportStoreTests
//
//  Created by Igor Malyarov on 22.01.2021.
//

import XCTest
import CoreData
import CoreDataTengizReportSP
@testable import ReportStore

final class AddReportItemTests: BaseTestCase {
    func testAddReportItemTitleError() throws {
        let report = try reportStore.sampleReport()
        let group = try reportStore.sampleReportGroup(for: report)

        let result = { title in
            self.reportStore.addReportItem(group: group,
                                           itemNumber: 1,
                                           title: title,
                                           amount: 1,
                                           hasIssue: false,
                                           note: "")
        }

        for title in ["", " "] {
            XCTAssertThrowsError(try result(title).get()) { error in
                XCTAssertEqual(error as! EntityError.ReportItemValidationError,
                               EntityError.ReportItemValidationError.emptyItemTitle,
                               "Expected to get error for empty title")
            }
        }
    }

    func testAddReportItem() throws {
        let report = try reportStore.sampleReport()
        let group = try reportStore.sampleReportGroup(for: report)

        var getItems = reportStore.getReportItems()
        XCTAssert(getItems.isEmpty)

        XCTAssertNoThrow(
            try reportStore.addReportItem(group: group,
                                          itemNumber: 9,
                                          title: "Item Title",
                                          amount: 10_000,
                                          hasIssue: false,
                                          note: ""
            ).get()
        )
        getItems = reportStore.getReportItems()
        XCTAssertEqual(getItems.count, 1, "Error adding Report Item with non-nil Report Group")

        try reportStore.sampleReportItems(for: group, itemCount: 20)
        getItems = reportStore.getReportItems()
        XCTAssertEqual(getItems.count, 21, "Error adding Report Item with non-nil Report Group")
    }

}
