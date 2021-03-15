//
//  ReportStore+Preview.swift
//  RBizReportApp
//
//  Created by Igor Malyarov on 25.01.2021.
//

import Foundation
import CoreDataTengizReportSP

extension ReportStore {
    static let preview: ReportStore = {
        let coreDataStack = CoreDataStack(inMemory: true)
        let preview = ReportStore(coreDataStack: coreDataStack)

        do {
            let report1 = try preview.addReport(company: "Preview", month: 11, year: 2020, date: Date(), revenue: 1_000_000, dailyAverage: 30_000, totalExpenses: 900_000, balance: 100_000, openingBalance: -500_000, runningBalance: -400_000, note: "").get()

            try (0..<5).forEach { index in
                let group = try preview.addReportGroup(
                    report: report1,
                    groupNumber: index + 1,
                    title: "Group \(index + 1)",
                    amount: 100_000 + Double(index) * 50_000,
                    target: 0.2,
                    note: "").get()

                (0..<2).forEach { index in
                    preview.addReportItem(
                        group: group,
                        itemNumber: index + 1,
                        title: "Item \(index + 1)",
                        amount: 50_000 + Double(index) * 10_000,
                        hasIssue: false,
                        note: "")
                }
            }

            let report2 = try preview.addReport(company: "Preview", month: 12, year: 2020, date: Date(), revenue: 1_200_000, dailyAverage: 35_000, totalExpenses: 950_000, balance: 250_000, openingBalance: -400_000, runningBalance: -150_000, note: "").get()

            let group2 = try preview.addReportGroup(report: report2, groupNumber: 1, title: "Group 2-1", amount: 111_000, target: 0.2, note: "").get()

            _ = try preview.addReportItem(group: group2, itemNumber: 1, title: "Item 1", amount: 50_000, hasIssue: false, note: "").get()

        } catch let error {
            print("Error(s) in creating preview")
            print(error.localizedDescription)
        }

        return preview
    }()
}
