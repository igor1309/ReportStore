//
//  ReportStore.swift
//  RBizReportApp
//
//  Created by Igor Malyarov on 18.01.2021.
//

import CoreData
import CoreDataTengizReportSP

final class ReportStore: ObservableObject {
    // var coreDataStack: CoreDataStack!
    private let context: NSManagedObjectContext!
    
    init(coreDataStack: CoreDataStack) {
        // self.coreDataStack = coreDataStack
        self.context = coreDataStack.context
    }

    func count(for fetchRequest: NSFetchRequest<NSFetchRequestResult>) -> Int {
        (try? context.count(for: fetchRequest)) ?? 0
    }

    #warning("Sandbox")
    // 1. Create Sandbox (child context)
    //    smth like: private let sandbox: NSManagedObjectContext? = nil
    // 2. Import tokenized report structure and map tokenized report structure to Report
    // 3. If ok save sandbox
    // 4. set sandbox to nil

}

// MARK: - Helpers

extension ReportStore {

    func hasReport(forCompany company: String, month: Int) -> Bool {
        let request = Report.fetchRequest(forCompany: company, month: month)
        let count = (try? context.count(for: request)) ?? 0
        return count > 0
    }

    // MARK: - Get (fetch)

    func getReports() -> [Report] {
        let request = Report.fetchRequest(NSPredicate.all)
        return (try? context.fetch(request)) ?? []
    }

    func getReports(forCompany company: String) -> [Report] {
        let predicate = NSPredicate(format: "%K == %@", #keyPath(Report.company_), company)
        let request = Report.fetchRequest(predicate)
        return (try? context.fetch(request)) ?? []
    }

    func getReport(forCompany company: String, month: Int) -> Report? {
        let reports = getReports(forCompany: company, month: month)
        return reports.first
    }

    func getReports(forCompany company: String, month: Int) -> [Report] {
        let request = Report.fetchRequest(forCompany: company, month: month)
        return (try? context.fetch(request)) ?? []
    }

    func getReportGroups() -> [ReportGroup] {
        let request = ReportGroup.fetchRequest(NSPredicate.all)
        return (try? context.fetch(request)) ?? []
    }

    func getReportItems() -> [ReportItem] {
        let request = ReportItem.fetchRequest(NSPredicate.all)
        return (try? context.fetch(request)) ?? []
    }

    enum ReportStoreError: Error, Equatable {
        case duplicateReport
        case validation(EntityError.ReportValidationError)
    }

    // MARK: - Add

    @discardableResult
    func addReport(company: String,
                   month: Int,
                   year: Int,
                   date: Date,
                   revenue: Double,
                   dailyAverage: Double,
                   totalExpenses: Double,
                   balance: Double,
                   openingBalance: Double,
                   runningBalance: Double,
                   note: String
    ) -> Result<Report, ReportStoreError> {

        if let error = Report.validationError(company: company, month: month, year: year, revenue: revenue, dailyAverage: dailyAverage, totalExpenses: totalExpenses) {
            return .failure(.validation(error))
        }

        if hasReport(forCompany: company, month: month) {
            return .failure(.duplicateReport)
        }

        let report = Report(context: context)
        report.company = company
        report.month = month
        report.year = year
        report.date = date
        report.revenue = revenue
        report.dailyAverage = dailyAverage
        report.totalExpenses = totalExpenses
        report.balance = balance
        report.openingBalance = openingBalance
        report.runningBalance = runningBalance
        report.note = note

        context.saveContext()
        return .success(report)
    }

    @discardableResult
    func addReportGroup(report: Report,
                        groupNumber: Int,
                        title: String,
                        amount: Double,
                        target: Double,
                        note: String
    ) -> Result<ReportGroup, EntityError.ReportGroupValidationError> {

        if let error = ReportGroup.validationError(title: title, groupNumber: groupNumber) {
            return .failure(error)
        }

        let group = ReportGroup(context: context)
        group.report = report
        group.groupNumber = groupNumber
        group.title = title
        group.amount = amount
        group.target = target
        group.note = note

        context.saveContext()
        return .success(group)
    }

    @discardableResult
    func addReportItem(group: ReportGroup,
                       itemNumber: Int,
                       title: String,
                       amount: Double,
                       hasIssue: Bool,
                       note: String
    ) -> Result<ReportItem, EntityError.ReportItemValidationError> {

        if let error = ReportItem.validationError(title: title, itemNumber: itemNumber) {
            return .failure(error)
        }

        let item = ReportItem(context: context)
        item.group = group
        item.itemNumber = itemNumber
        item.title = title
        item.amount = amount
        item.hasIssue = hasIssue
        item.note = note

        context.saveContext()
        return .success(item)
    }

    // MARK: - Delete

    func delete(_ report: Report) {
        context.delete(report)
        context.saveContext()
    }

    func delete(_ group: ReportGroup) {
        context.delete(group)
        context.saveContext()
    }

    func delete(_ item: ReportItem) {
        context.delete(item)
        context.saveContext()
    }

    // MARK: - Update

    func update(_ report: Report) -> Report {
        context.saveContext()
        return report
    }

    func update(_ group: ReportGroup) -> ReportGroup {
        context.saveContext()
        return group
    }

    func update(_ item: ReportItem) -> ReportItem {
        context.saveContext()
        return item
    }

    func update<T, U: Updatable>(_ object: U,
                   keyPath: WritableKeyPath<U, T>,
                   to value: T) -> U {
        let updated = object.update(keyPath, to: value)
        context.saveContext()
        return updated
    }

}
