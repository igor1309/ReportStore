//
//  AddReportGroupTests.swift
//  ReportStoreTests
//
//  Created by Igor Malyarov on 22.01.2021.
//

import XCTest
import CoreData
import CoreDataTengizReportSP
@testable import ReportStore

final class AddReportGroupTests: BaseTestCase {
    func testAddReportGroupTitleError() throws {
        let report = try reportStore.sampleReport()

        let result = { title in
            self.reportStore.addReportGroup(report: report,
                                            groupNumber: 1,
                                            title: title,
                                            amount: 1,
                                            target: 0,
                                            note: "")
        }

        for title in ["", " ", "   "] {
            XCTAssertThrowsError(try result(title).get()) { error in
                XCTAssertEqual(error as! EntityError.ReportGroupValidationError,
                               EntityError.ReportGroupValidationError.emptyGroupTitle,
                               "Expected to get error for empty title")
            }
        }

        for title in [" Test", "Test"] {
            XCTAssertNoThrow(try result(title).get())
        }
    }

    func testAddReportGroup() throws {
        let report = try reportStore.sampleReport()
        XCTAssertNotNil(report, "Report should not be nil")

        let title = "Group Title"
        let groupNumber = 10
        let amount = 900_000.00
        let target = 0.2
        let note = "Some Group Note"

        let group = try reportStore.addReportGroup(
            report: report,
            groupNumber: groupNumber,
            title: title,
            amount: amount,
            target: target,
            note: note
        ).get()

        XCTAssertNotNil(group, "Report Group should not be nil")

        let targetCount = 10
        _ = try reportStore.sampleReportItems(for: group, itemCount: targetCount)

        let first = try XCTUnwrap(report.groups.first)

        XCTAssertEqual(first.id, group.id)
        XCTAssertEqual(first.report, report)
        XCTAssertEqual(first.title, title, "ERROR setting Group title property")
        XCTAssertEqual(first.title_, title, "ERROR setting Group title property")
        XCTAssertEqual(first.groupNumber, groupNumber, "ERROR setting Group groupNumber property")
        XCTAssertEqual(first.groupNumber_, Int16(groupNumber), "ERROR setting Group groupNumber property")
        XCTAssertEqual(first.amount, amount, "ERROR setting Group amount property")
        XCTAssertEqual(first.target, target, "ERROR setting Group target property")
        XCTAssertEqual(first.items.count, targetCount, "ERROR setting Group Items")
        XCTAssertEqual(first.note, note, "ERROR setting Group note property")
        XCTAssertEqual(first.note_, note, "ERROR setting Group note property")
    }
}
