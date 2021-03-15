//
//  GetReportTests.swift
//  ReportStoreTests
//
//  Created by Igor Malyarov on 22.01.2021.
//

import XCTest
import CoreData
@testable import ReportStore

final class GetReportTests: BaseTestCase {

    func testHasReportsForCompanyWithMonth() throws {
        let company = "Some Test Company"
        let month = 11

        XCTAssertFalse(reportStore.hasReport(forCompany: company, month: month), "There should be no Reports for company '\(company)' in month \(month)")

        try (0..<2).forEach { _ in
            let report = try reportStore.sampleReport()
            report.company = company
            report.month = month
        }

        XCTAssert(reportStore.hasReport(forCompany: company, month: month), "Should be 2 Reports with name '\(company)' in month \(month)")

        XCTAssertEqual(reportStore.getReports(forCompany: company, month: month).count, 2, "Should be 2 Reports with name \(company)")

        try reportStore.sampleReport()
        XCTAssertEqual(reportStore.getReports().count, 3, "Should be 3 Reports total")
        XCTAssertEqual(reportStore.getReports(forCompany: company, month: month).count, 2, "Should be 2 Reports with name \(company)")

    }

    // MARK: - Reports array

    func testGetReports() throws {
        XCTAssertEqual(reportStore.getReports().count, 0, "There should be no reports")

        let targetCount = 10
        try reportStore.sampleReports(count: targetCount)
        
        XCTAssertEqual(reportStore.getReports().count, targetCount)
    }

    func testGetReportsWithMatchingCompanyName() throws {
        let company = "Test Company"
        let month = 11

        let report = try reportStore.sampleReport()
        report.company = company
        report.month = month

        var getReports = reportStore.getReports(forCompany: company)
        XCTAssertFalse(getReports.isEmpty)
        XCTAssertEqual(getReports, [report])

        getReports = reportStore.getReports(forCompany: "Test")
        XCTAssert(getReports.isEmpty)
    }

    func testGetReportsNoMatchingCompanyName() throws {
        let company = "Test Company"
        let month = 11

        let report = try reportStore.sampleReport()
        report.company = company
        report.month = month

        let getReports = reportStore.getReports(forCompany: "NOTTest Company")
        XCTAssert(getReports.isEmpty)
        XCTAssertNotEqual(getReports, [report])
    }

    func testGetReportsForCompanyWithMonth() throws {
        let company = "Some Test Company"
        let month = 11

        try (0..<2).forEach { _ in
            let report = try reportStore.sampleReport()
            report.company = company
            report.month = month
        }

        XCTAssertEqual(reportStore.getReports().count, 2, "Should be 2 Reports total")
        XCTAssertEqual(reportStore.getReports(forCompany: company, month: month).count, 2, "Should be 2 Reports with name \(company)")

        try reportStore.sampleReport()
        XCTAssertEqual(reportStore.getReports().count, 3, "Should be 3 Reports total")
        XCTAssertEqual(reportStore.getReports(forCompany: company, month: month).count, 2, "Should be 2 Reports with name \(company)")

    }

    // MARK: - One Report

    func testGetReportWithMatchingCompanyName() throws {
        let company = "Test Company"
        let month = 11

        let report = try reportStore.sampleReport()
        report.company = company
        report.month = month

        let getReport = reportStore.getReport(forCompany: company, month: month)
        XCTAssertNotNil(getReport)
        XCTAssertEqual(getReport, report)
    }

    func testGetReportNoMatchingCompanyName() throws {
        let company = "Test Company"
        let month = 11

        let report = try reportStore.sampleReport()
        report.company = company
        report.month = month

        var getReport = reportStore.getReport(forCompany: "NOT" + company, month: month)
        XCTAssertNil(getReport, "No Report for wrong name should be returned")

        getReport = reportStore.getReport(forCompany: "NOTTest Company", month: 10)
        XCTAssertNil(getReport, "No Report for wrong month should be returned")
    }

}
