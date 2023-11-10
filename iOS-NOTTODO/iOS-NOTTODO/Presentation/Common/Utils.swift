//
//  Utils.swift
//  iOS-NOTTODO
//
//  Created by JEONGEUN KIM on 2023/03/04.
//

import Foundation

import FSCalendar
import SafariServices

final class Utils {
    
    class func myInfoUrl(vc: UIViewController, url: String) {
        let url = URL(string: url)
        let safariView: SFSafariViewController = SFSafariViewController(url: url!)
        vc.present(safariView, animated: true, completion: nil)
    }
    
    class func push(_ naviViewController: UINavigationController?, _ viewController: UIViewController, animated: Bool = true) {
        DispatchQueue.main.async {
            naviViewController?.isNavigationBarHidden = true
            naviViewController?.pushViewController(viewController, animated: true)
        }
    }
    class func modal(_ viewController: UIViewController, _ modalViewController: UIViewController, _ modalStyle: UIModalPresentationStyle) {
        let modalViewController = modalViewController
        modalViewController.modalPresentationStyle = modalStyle
        viewController.present(modalViewController, animated: false)
    }
    
    class func dateFormatterString(format: String?, date: Date) -> String {
        let formatter = Foundation.DateFormatter()
        formatter.dateFormat = format ?? "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        let convertStr = formatter.string(from: date)
        return convertStr
    }
    
    class func scrollCurrentPage(calendar: WeekMonthFSCalendar, isPrev: Bool) {
        let gregorian = Calendar(identifier: .gregorian)
        calendar.setCurrentPage( gregorian.date(byAdding: calendar.scope == .week ? .weekOfMonth : .month, value: isPrev ? -1 : 1, to: calendar.currentPage)!, animated: true)
    }
    
    class func calendarTitleColor(today: Date, date: Date, selected: Bool) -> UIColor? {
        switch Calendar.current.compare(today, to: date, toGranularity: .day) {
        case .orderedSame:
            print("\(date) is the same as \(today)")
            return selected ? .black : .white
        case .orderedDescending:
            print("\(date) is before \(today)")
            return  .gray4
        case .orderedAscending:
            print("\(date) is after \(today)")
            let sevenDays = Calendar.current.date(byAdding: .day, value: +6, to: Date())!
            if date < sevenDays {
                return selected ? .black : .white
            }
            return .gray4
        }
    }
    
    class func calendarSelected(today: Date, date: Date) -> Bool {
        switch Calendar.current.compare(today, to: date, toGranularity: .day) {
        case .orderedSame:
            print("\(date) is the same as \(today)")
            return true
        case .orderedDescending:
            print("\(date) is before \(today)")
            return false
        case .orderedAscending:
            print("\(date) is after \(today)")
            let sevenDays = Calendar.current.date(byAdding: .day, value: +6, to: Date())!
            if date < sevenDays {
                return true
            }
            return false
        }
    }
    
    static var version: String? {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String
        else { return nil }
        return version
    }
}
