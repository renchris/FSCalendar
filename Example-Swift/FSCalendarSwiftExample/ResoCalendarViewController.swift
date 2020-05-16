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

    override func loadView() {
        
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor.white
        self.view = view
        
        let height: CGFloat = UIDevice.current.model.hasPrefix("iPad") ? 400 : 300
        
        //Height of stationary top weekday column
        let topStackViewHeight: CGFloat = 25.0
        //Labels in weekday column
        let daysOfWeek: Array<String> = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        //Colours if colouring each day of week view is wanted. Currently not used and using clear for background.
        let coloursOfWeek: Array<UIColor> = [.red, .orange, .yellow, .green, .blue, .magenta, .purple]

        //Stack View
        let stackView   = UIStackView()
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.distribution  = UIStackView.Distribution.fillEqually
        stackView.widthAnchor.constraint(equalToConstant: self.view.frame.width).isActive = true
        stackView.alignment = UIStackView.Alignment.center
        
        for (index, day) in daysOfWeek.enumerated(){
            let textLabel = UILabel()
            textLabel.backgroundColor = .clear//coloursOfWeek[index]
            textLabel.heightAnchor.constraint(equalToConstant: topStackViewHeight).isActive = true
            textLabel.text  = day
            textLabel.textAlignment = .center
            textLabel.font = textLabel.font.withSize(14.0)
            textLabel.textColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
            
            //border under the top weekday labels
            let bottomBorder = CALayer()
            bottomBorder.borderColor = UIColor.gray.cgColor
            bottomBorder.borderWidth = 0.5
            bottomBorder.frame = CGRect(x: 0, y: topStackViewHeight,width: view.frame.size.width, height: bottomBorder.borderWidth)
            
            //border under the calendar
            let underCalendarBorder = CALayer()
            underCalendarBorder.borderColor = UIColor.gray.cgColor
            underCalendarBorder.borderWidth = 0.5
            underCalendarBorder.frame = CGRect(x: 0, y: topStackViewHeight + height, width: view.frame.size.width, height: bottomBorder.borderWidth)
            
            textLabel.layer.addSublayer(bottomBorder)
            textLabel.layer.addSublayer(underCalendarBorder)
            
            stackView.addArrangedSubview(textLabel)
        }

        stackView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(stackView)

        //Constraints
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        stackView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        
        stackView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        
        //move calendar down to make room for static weekday labels

        //In FSCalendar ResoCalendarViewController
        //navigationBar.frame.maxY: 88.0
        //navigationBar.frame.size.height: 44.0
        //navigationBar.frame.origin.y: 44.0
        
        //In tabBarApp ResoCalendarViewController
        //navigationBar.frame.maxY: 44.0
        //navigationBar.frame.size.height: 44.0
        //navigationBar.frame.origin.y: 0.0
        
        //So we can use: navigationBar.frame.maxY + navigationBar.frame.size.height - navigationBar.frame.origin.y
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: self.navigationController!.navigationBar.frame.maxY + self.navigationController!.navigationBar.frame.size.height - self.navigationController!.navigationBar.frame.origin.y + topStackViewHeight, width: view.frame.size.width, height: height))
        
//        print("self.navigationController!.navigationBar.frame.maxY: \(self.navigationController!.navigationBar.frame.maxY)");
//        print("\ntopStackViewHeight: \(topStackViewHeight)");
//        print("\nself.navigationController!.navigationBar.frame.size.height: \(self.navigationController!.navigationBar.frame.size.height)");
//        print("\nself.navigationController!.navigationBar.frame.origin.y: \(self.navigationController!.navigationBar.frame.origin.y)");
    
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.pagingEnabled = false
        //calendar.allowsMultipleSelection = true
        calendar.rowHeight = 70
        calendar.placeholderType = FSCalendarPlaceholderType.none
        view.addSubview(calendar)
        self.calendar = calendar

        calendar.appearance.titleDefaultColor = UIColor.black
        calendar.appearance.titleFont = UIFont.systemFont(ofSize: 16)
        calendar.weekdayHeight = 0

        calendar.swipeToChooseGesture.isEnabled = true

        calendar.today = nil // Hide the today circle
        
        calendar.register(
            ResoCalendarCellTwo.self,
            forCellReuseIdentifier: "cell")
        
        calendar.appearance.headerTitleColor = .red
        calendar.appearance.headerDateFormat = "MMMM yyyy"
        calendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 22)

        //These work once calendar.today is set
        calendar.appearance.titleTodayColor = .black
        calendar.appearance.todayColor = nil
        
        //Sets the selection colour for today to be UIColor
        calendar.appearance.todaySelectionColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0) //FSCalendarStandardSelectionColor   FSColorRGBA(31,119,219,1.0)
        
        //Moves the event dot 3.5 downwards compared to default placement
        calendar.appearance.eventOffset = CGPoint(x: 0.0, y: 3.5)
        
        calendar.appearance.eventDefaultColor = UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
        
        //Set 'today' to actual current date. Note perhaps time zone issues later on?
        calendar.today = Date()
        
        //Sets today as selected
        calendar.select(calendar.today, scrollToDate: false)

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
    func selectedDateFormatted() -> String{
        
        let selectedDate = calendar?.selectedDate ?? formatter.date(from: "0001-01-01")!
        
        let dateFormatterWeekdayAndMonth = DateFormatter()
        dateFormatterWeekdayAndMonth.dateFormat = "EEEE, MMMM"
        let weekdayAndMonth = dateFormatterWeekdayAndMonth.string(from: selectedDate)
        
        let dateFormatterDayDate = DateFormatter()
        dateFormatterDayDate.dateFormat = "d"
        let dayDate: Int = Int(dateFormatterDayDate.string(from: selectedDate)) ?? 0
        
        var dayOrdinal: String {
            if(dayDate > 3 && dayDate < 21){
                return "th"
            }
            switch (dayDate % 10){
            case 1: return "st"
            case 2: return "nd"
            case 3: return "rd"
            default: return "th"
            }
        }
        
        let dateFormatterYear = DateFormatter()
        dateFormatterYear.dateFormat = "yyyy"
        let year = dateFormatterYear.string(from: selectedDate)
        
        let formattedDate = ("\(weekdayAndMonth) \(dayDate)\(dayOrdinal), \(year)")
        
        return formattedDate
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return formatter.date(from: "2019-01-01")! //2016-07-08
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
    
    //adds number of event dot for given date
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        return 1;
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
            //cell.shapeLayer = createAnotherShapeLayer()
        }
        
        return cell
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
        //do stuff for each cell
    }
}
