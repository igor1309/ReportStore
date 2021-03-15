//
//  ReportStorePreviewTests.swift
//  ReportStorePreviewTests
//
//  Created by Igor Malyarov on 25.01.2021.
//

import XCTest
@testable import ReportStore

class ReportStorePreviewTests: XCTestCase {
    var preview: ReportStore!

    override func setUpWithError() throws {
        preview = ReportStore.preview
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        preview = nil
    }

    func testReportStoreBase() throws {
        XCTAssertNotNil(preview)

        XCTAssertEqual(preview.getReports().count, 2, "There are 2 reports in preview")
        XCTAssertEqual(preview.getReportGroups().count, 6, "There are 6 reports in preview")
        XCTAssertEqual(preview.getReportItems().count, 11, "There are 11 reports in preview")
    }

}
