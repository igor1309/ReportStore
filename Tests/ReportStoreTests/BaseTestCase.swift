//
//  BaseTestCase.swift
//  ReportStoreTests
//
//  Created by Igor Malyarov on 22.01.2021.
//

import XCTest
import CoreDataTengizReportSP
@testable import ReportStore

class BaseTestCase: XCTestCase {
    var reportStore: ReportStore!

    override func setUpWithError() throws {
        let coreDataStack = CoreDataStack(inMemory: true)
        reportStore = ReportStore(coreDataStack: coreDataStack)
    }

    override func tearDown() {
        super.tearDown()
        reportStore = nil
    }

    func testReportStoreBase() throws {
        XCTAssertNotNil(reportStore)

        XCTAssert(reportStore.getReports().isEmpty, "ERROR: new database is not empty")
        XCTAssert(reportStore.getReportGroups().isEmpty, "ERROR: new database is not empty")
        XCTAssert(reportStore.getReportItems().isEmpty, "ERROR: new database is not empty")
    }

}
