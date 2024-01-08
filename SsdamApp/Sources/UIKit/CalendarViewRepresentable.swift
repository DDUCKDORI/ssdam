//
//  CalendarViewController.swift
//  Ssdam
//
//  Created by 김재민 on 2024/01/07.
//  Copyright © 2024 com.dduckdori. All rights reserved.
//

import SwiftUI

struct CalendarViewRepresentable: UIViewRepresentable {
    @Binding var selectedDate: DateComponents?
    
    func makeUIView(context: Context) -> UICalendarView {
        let view = UICalendarView()
        view.availableDateRange = DateInterval(start: .distantPast, end: .now)
        view.wantsDateDecorations = true
        view.tintColor = UIColor(Color(.mint50))
        view.delegate = context.coordinator
        view.selectionBehavior = UICalendarSelectionSingleDate(delegate: context.coordinator)
        return view
    }
    
    func updateUIView(_ uiView: UICalendarView, context: Context) {
        let calendar = Calendar.current
        guard let selectedDate = self.selectedDate else { return }
        uiView.reloadDecorations(forDateComponents: [selectedDate], animated: true)
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
            if self.parent.selectedDate == dateComponents {
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

#Preview {
    CalendarViewRepresentable(selectedDate: .constant(.init()))
}
