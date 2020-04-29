//  RangePickerViewController.m
//  FSCalendar
//
//  Created by dingwenchao on 5/8/16.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//

import UIKit

class ResoCalendarViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    
    private weak var calendar: FSCalendar!
    private weak var eventLabel: UILabel!
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    // The start date of the range
    private var date1: Date?
    // The end date of the range
    private var date2: Date?

    override func loadView() {
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        self.view = view
        
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
        let calendar = FSCalendar(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY, width: view.frame.size.width, height: height))
    
        calendar.dataSource = self
        calendar.delegate = self
        calendar.pagingEnabled = false
        //calendar.allowsMultipleSelection = true
        calendar.rowHeight = 60
        calendar.placeholderType = FSCalendarPlaceholderType.none
        view.addSubview(calendar)
        self.calendar = calendar

        calendar.appearance.titleDefaultColor = UIColor.black
        //calendar.appearance.headerTitleColor = UIColor.black
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16)
        calendar.weekdayHeight = 20

        calendar.swipeToChooseGesture.isEnabled = true

        calendar.today = nil // Hide the today circle
        
        calendar.register(
            ResoCalendarCellTwo.self,
            forCellReuseIdentifier: "cell")
        
        calendar.appearance.headerTitleColor = .red
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        
        //These work once calendar.today is set
        //Some are default set now that multi select is false
        
        
        
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.todayColor = nil
        //what to do once selected hm
        calendar.appearance.todaySelectionColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0) //FSCalendarStandardSelectionColor   FSColorRGBA(31,119,219,1.0)
        
        //dont have subtitle
        calendar.appearance.subtitleTodayColor = .orange
        
        
        
        //Set 'today' to actual current date. Note perhaps time zone issues later on?
        calendar.today = Date()
        
//        let todaysCell = calendar.dequeueReusableCell(withIdentifier: "cell", for: calendar.today!, at: .current)
//
//        todaysCell.shapeLayer.borderWidth = 5.0
        
        //calendar.appearance.borderDefaultColor = .purple
        //calendar.appearance.borderSelectionColor = .green
        
        /**
        * Asks the delegate for a border radius for the specific date.
         I suppose 0 is a border and 1 is nothing?
        */
        func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
            if gregorian.isDateInToday(date)
            {
                return 0.0
            }
            return 1.0
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.dateFormat = "yyyy-MM-dd"

        // Uncomment this to perform an 'initial-week-scope'
        // self.calendar.scope = FSCalendarScopeWeek;

        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
        
        print("Today's date is: \(Date())")
        
    }

    deinit {
        print("\(#function)")
    }

// MARK: - FSCalendarDataSource
    func minimumDate(for calendar: FSCalendar) -> Date {
        return formatter.date(from: "2016-07-08")!
    }

    func maximumDate(for calendar: FSCalendar) -> Date {
        return self.gregorian.date(
            byAdding: .month,
            value: 10,
            to: Date())!
    }
    
    //return border colour if the if statement
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderDefaultColorFor date: Date) -> UIColor? {
        
        if gregorian.isDateInToday(date){
            return UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0) //FSCalendarStandardSelectionColor   FSColorRGBA(31,119,219,1.0)
            
            //.red
        }
        
        //return colour of border. if appearance.borderDefaultColor that would be probably clear so no visible border. Otherwise color will show on all cells otherwise the if statement
        return appearance.borderDefaultColor //.purple
    }
    
    //return selected border colour
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
//        if gregorian.isDateInToday(date){
//            return
//                //FSCalendar.colorForCellFill
//                .brown
//        }
//        return  appearance.borderSelectionColor //.orange
        //return Standard Blue as border, so looks not bordered but will be same size as Today's border
        return UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0) //FSCalendarStandardSelectionColor   FSColorRGBA(31,119,219,1.0)
    }
    

    func calendar(
        _ calendar: FSCalendar,
        cellFor date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(
            withIdentifier: "cell",
            for: date,
            at: monthPosition)
        
        if gregorian.isDateInToday(date){
            //these going through but not applying
            
            
//            cell.shapeLayer.borderWidth = 5.0
//            cell.appearance.borderRadius = 1
//
            //cell.shapeLayer = createAnotherShapeLayer()
            
            //cell.shapeLayer = createFlowerShapeLayer()
            print("border width today")
        }
        
        return cell
    }
    
    func createAnotherShapeLayer() -> CAShapeLayer{
        let shapeLayer = CAShapeLayer()
        shapeLayer.backgroundColor = UIColor.orange.cgColor
        //[UIColor clearColor].CGColor;
        shapeLayer.borderWidth = 10.0
        shapeLayer.borderColor = UIColor.magenta.cgColor
        shapeLayer.opacity = 0
        
        shapeLayer.strokeColor = UIColor.green.cgColor
        shapeLayer.fillColor = UIColor.yellow.cgColor
        shapeLayer.fillRule = kCAFillRuleEvenOdd
        
        return shapeLayer
    }
    
    func createFlowerShapeLayer() -> CAShapeLayer{
        let width: CGFloat = 640
        let height: CGFloat = 640
             
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0,
                                  width: width, height: height)
             
        let path = CGMutablePath()
             
        stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 6).forEach {
            angle in
            var transform  = CGAffineTransform(rotationAngle: angle)
                .concatenating(CGAffineTransform(translationX: width / 2, y: height / 2))
            
            let petal = CGPath(ellipseIn: CGRect(x: -20, y: 0, width: 40, height: 100),
                               transform: &transform)
            
            path.addPath(petal)
        }
            
        shapeLayer.path = path
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.fillColor = UIColor.yellow.cgColor
        shapeLayer.fillRule = kCAFillRuleEvenOdd
        
        return shapeLayer
    
    }

    func calendar(
        _ calendar: FSCalendar,
        willDisplay cell: FSCalendarCell,
        for date: Date,
        at monthPosition: FSCalendarMonthPosition
    ) {
        configureCell(cell, for: date, at: monthPosition)
    }

// MARK: - FSCalendarDelegate
/**
Asks the delegate whether the specific date is allowed to be selected by tapping.
Not sure what this means?
*/
func calendar(
    _ calendar: FSCalendar,
    shouldSelect date: Date,
    at monthPosition: FSCalendarMonthPosition
) -> Bool {
    return monthPosition == .current
}

/**
Asks the delegate whether the specific date is allowed to be deselected by tapping.
Not sure what this means?
*/
func calendar(
    _ calendar: FSCalendar,
    shouldDeselect date: Date,
    at monthPosition: FSCalendarMonthPosition
) -> Bool {
    return false
}

/**
Tells the delegate a date in the calendar is selected by tapping.
This happens when you click on a date cell
*/
func calendar(
    _ calendar: FSCalendar,
    didSelect date: Date,
    at monthPosition: FSCalendarMonthPosition
) {
    //nothing
}

/**
Tells the delegate a date in the calendar is deselected by tapping.
Not sure what this does?
*/
func calendar(
    _ calendar: FSCalendar,
    didDeselect date: Date,
    at monthPosition: FSCalendarMonthPosition
) {
    
    //print("did deselect date \(formatter.string(from: date))")
    
    configureVisibleCells()
}

    /**
    * Asks the delegate for event colors for the specific date.
     Not sure when this is called? Want to update today colour
    */
    func calendar(
        _ calendar: FSCalendar,
        appearance: FSCalendarAppearance,
        eventDefaultColorsFor date: Date
    ) -> [UIColor]? {
        
        print("befor colour")
        
        if gregorian.isDateInToday(date) {
            print("inside colour")
            return [UIColor.orange]
            
        }
        
        return [appearance.eventDefaultColor].compactMap { $0 }
    }

// MARK: - Private methods
    func configureVisibleCells() {
        
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            self.configureCell(cell, for: date!, at: position)
        }
        
//        (calendar.visibleCells as NSArray).enumerateObjects({ obj, idx, stop in
//            let date = self.calendar.date(for: obj)
//            let position = self.calendar.monthPosition(for: obj)
//            self.configureCell(obj, for: date, at: position)
//        })
    }

    func configureCell(
        _ cell: FSCalendarCell,
        for date: Date,
        at position: FSCalendarMonthPosition
    ) {
        let rangeCell = cell
        if position != .current {
            //rangeCell.middleLayer.hidden = true
            //rangeCell.selectionLayer.hidden = true
            return
        }
        if (date1 != nil) && (date2 != nil) {
            // The date is in the middle of the range
            let isMiddle = date.compare(date1!) != date.compare(date2!)
            //rangeCell.middleLayer.hidden = !isMiddle
        } else {
            //rangeCell.middleLayer.hidden = true
        }
        var isSelected = false
        
        //isSelected |= ((date1 != nil) && gregorian.isDate(date, inSameDayAs: date1!))
        
        
        //isSelected |= ((date2 != nil) && gregorian.isDate(date, inSameDayAs: date2!))
        
        //rangeCell.selectionLayer.hidden = !isSelected
    }
}