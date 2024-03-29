//
//  CalendarViewController.swift
//  Ssdam
//
//  Created by 김재민 on 2024/01/07.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftUI
import CoreData
import Utils

struct CalendarViewRepresentable: UIViewRepresentable {
    @Binding var selectedDate: DateComponents?
    private var decorateFor: [DateComponents] {
        CompletedDateManager.shared.completedDates
    }
    
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.availableDateRange = DateInterval(start: getStartDate(), end: .now)
        view.wantsDateDecorations = true
        view.tintColor = UIColor(Color(.mint50))
        view.delegate = context.coordinator
        view.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return view
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        uiView.availableDateRange.end = .now
        uiView.reloadDecorations(forDateComponents: decorateFor, animated: true)
    }
    
    private func getStartDate() -> Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.year = 2024
        components.month = 1
        components.day = 1
        let startDate = calendar.date(from: components)!
        return startDate
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
        var parent: CalendarViewRepresentable
        
        init(_ parent: CalendarViewRepresentable) {
            self.parent = parent
        }
        
        @MainActor
        func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
            
            if self.parent.decorateFor.contains(where: { $0.isEqual(to: dateComponents) }) {
                return UICalendarView.Decoration.default(color: UIColor(Color(.mint50)), size: .small)
            }
            return nil
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
            selection.selectedDate = dateComponents
            self.parent.selectedDate = dateComponents
        }
        
        func dateSelection(_ selection: UICalendarSelectionSingleDate, canSelectDate dateComponents: DateComponents?) -> Bool {
            return true
        }
    }
}


//#Preview {
//    CalendarViewRepresentable(selectedDate: .constant(.init()))
//}
