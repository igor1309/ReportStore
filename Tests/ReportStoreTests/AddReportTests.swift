//
//  AddReportTests.swift
//  ReportStoreTests
//
//  Created by Igor Malyarov on 22.01.2021.
//

import XCTest
import CoreData
import CoreDataTengizReportSP
@testable import ReportStore

typealias ReportError = ReportStore.ReportStoreError

final class AddReportTests: BaseTestCase {
    func testAddReportWithCompanyError() throws {
        let result = { company in
            self.reportStore.addReport(company: company,
                                       month: 9,
                                       year: 2020,
                                       date: Date(),
                                       revenue: 1_000_000,
                                       dailyAverage: 100_000,
                                       totalExpenses: 800_000,
                                       balance: 200_000,
                                       openingBalance: -100_000,
                                       runningBalance: 100_000,
                                       note: "")
        }

        for company in ["", " ", "   "] {
            XCTAssertThrowsError(try result(company).get()) { error in
                XCTAssertEqual(error as! ReportError,
                               ReportError.validation(EntityError.ReportValidationError.emptyCompany),
                               "Expected to get error for empty company")
            }
        }
    }

    func testAddReportWithMonth() throws {
        let result = { month in
            self.reportStore.addReport(company: "Test Company",
                                       month: month,
                                       year: 2020,
                                       date: Date(),
                                       revenue: 2_500_000,
                                       dailyAverage: 100_000,
                                       totalExpenses: 1_500_000,
                                       balance: 1_000_000,
                                       openingBalance: 500_000,
                                       runningBalance: -500_000,
                                       note: "Some Report Note")
        }

        for month in [0, 13] {
            XCTAssertThrowsError(try result(month).get()) { error in
                XCTAssertEqual(error as! ReportError,
                               ReportError.validation(EntityError.ReportValidationError.invalidMonth(month)),
                               "Expected to get error for invalid month")
            }
        }

        for month in 1...12 {
            XCTAssertNoThrow(try result(month).get())
        }
    }

    func testAddReportWithYearError() throws {
        let result = { year in
            self.reportStore.addReport(company: "Test Company",
                                       month: 9,
                                       year: year,
                                       date: Date(),
                                       revenue: 2_500_000,
                                       dailyAverage: 100_000,
                                       totalExpenses: 1_500_000,
                                       balance: 1_000_000,
                                       openingBalance: 500_000,
                                       runningBalance: -500_000,
                                       note: "Some Report Note")
        }

        for year in [2019, 2051] {
            XCTAssertThrowsError(try result(year).get()) { error in
                XCTAssertEqual(error as! ReportError,
                               ReportError.validation(EntityError.ReportValidationError.invalidYear(year)),
                               "Expected to get error for invalid year")
            }
        }
    }

    func testAddReportWithRevenueError() throws {
        let result = { revenue in
            self.reportStore.addReport(company: "Test Company",
                                       month: 9,
                                       year: 2020,
                                       date: Date(),
                                       revenue: revenue,
                                       dailyAverage: 100_000,
                                       totalExpenses: 1_500_000,
                                       balance: 1_000_000,
                                       openingBalance: 500_000,
                                       runningBalance: -500_000,
                                       note: "Some Report Note")
        }

        let revenue = -2_500_000.00
        XCTAssertThrowsError(try result(revenue).get()) { error in
            XCTAssertEqual(error as! ReportError,
                           ReportError.validation(EntityError.ReportValidationError.invalidRevenue(revenue)),
                           "Expected to get error for invalid (negative) revenue")
        }
    }

    func testAddReportWithDailyAverageError() throws {
        let result = { dailyAverage in
            self.reportStore.addReport(company: "Test Company",
                                       month: 9,
                                       year: 2020,
                                       date: Date(),
                                       revenue: 2_500_000,
                                       dailyAverage: dailyAverage,
                                       totalExpenses: 1_500_000,
                                       balance: 1_000_000,
                                       openingBalance: 500_000,
                                       runningBalance: -500_000,
                                       note: "Some Report Note")
        }

        let dailyAverage = -100_000.00
        XCTAssertThrowsError(try result(dailyAverage).get()) { error in
            XCTAssertEqual(error as! ReportError,
                           ReportError.validation(EntityError.ReportValidationError.invalidDailyAverage(dailyAverage)),
                           "Expected to get error for invalid (negative) Daily Average")
        }
    }

    func testAddReportWithTotalExpensesError() throws {
        let result = { totalExpenses in
            self.reportStore.addReport(company: "Test Company",
                                       month: 9,
                                       year: 2020,
                                       date: Date(),
                                       revenue: 2_500_000.00,
                                       dailyAverage: 100_000,
                                       totalExpenses: totalExpenses,
                                       balance: 1_000_000,
                                       openingBalance: 500_000,
                                       runningBalance: -500_000,
                                       note: "Some Report Note")
        }

        let totalExpenses = -1_500_000.00
        XCTAssertThrowsError(try result(totalExpenses).get()) { error in
            XCTAssertEqual(error as! ReportError,
                           ReportError.validation(EntityError.ReportValidationError.invalidTotalExpenses(totalExpenses)),
                           "Expected to get error for invalid (negative) Total Expenses")
        }
    }

    func testAddReport() throws {
        let now = Date()

        let company = "Test Company"
        let month = 9
        let year = 2020
        let date = now
        let revenue = 2_500_000.00
        let dailyAverage = 100_000.00
        let totalExpenses = 1_500_000.00
        let balance = 1_000_000.00
        let openingBalance = 500_000.00
        let runningBalance = -500_000.00
        let note = "Some Report Note"


        let report = try reportStore.addReport(
            company: company,
            month: month,
            year: year,
            date: date,
            revenue: revenue,
            dailyAverage: dailyAverage,
            totalExpenses: totalExpenses,
            balance: balance,
            openingBalance: openingBalance,
            runningBalance: runningBalance,
            note: note
        ).get()

        XCTAssertNotNil(report, "Report should not be nil")
        XCTAssertEqual(report.company, company, "ERROR setting Report company property")
        XCTAssertEqual(report.company_, company, "ERROR setting Report company property")
        XCTAssertEqual(report.balance, 1_000_000, "ERROR setting Report balance property")
        XCTAssertEqual(report.dailyAverage, 100_000, "ERROR setting Report dailyAverage property")
        XCTAssertEqual(report.date, now, "ERROR setting Report date property")
        XCTAssertEqual(report.date_, now, "ERROR setting Report date property")
        XCTAssertEqual(report.month, month, "ERROR setting Report month property")
        XCTAssertEqual(report.month_, Int16(month), "ERROR setting Report month property")
        XCTAssertEqual(report.note, note, "ERROR setting Report note property")
        XCTAssertEqual(report.note_, note, "ERROR setting Report note property")
        XCTAssertEqual(report.openingBalance, openingBalance, "ERROR setting Report openingBalance property")
        XCTAssertEqual(report.revenue, revenue, "ERROR setting Report revenue property")
        XCTAssertEqual(report.runningBalance, runningBalance, "ERROR setting Report runningBalance property")
        XCTAssertEqual(report.totalExpenses, totalExpenses, "ERROR setting Report totalExpenses property")
        XCTAssertEqual(report.year, year, "ERROR setting Report year property")
        XCTAssertEqual(report.year_, Int16(year), "ERROR setting Report year property")
    }

    func testAddReportError() throws {
        XCTAssertNoThrow(try reportStore.sampleReport())
        XCTAssertThrowsError(try reportStore.sampleReport()) { error in
            XCTAssertEqual(error as! ReportStore.ReportStoreError,
                           ReportError.duplicateReport,
                           "Adding second report for same company and same month should fail")
        }
    }

}
