//
//  FSCalendarCell.h
//  Pods
//
//  Created by Wenchao Ding on 12/3/15.
//
//

#import "FSCalendar.h"

@interface ResoCalendarCellTwo : FSCalendarCell

// The circle border for Today
@property (weak, nonatomic) CAShapeLayer *circleLayer;

// The top line border for each cell
@property (weak, nonatomic) CALayer *topBorder;


@property (weak, nonatomic) UIImageView *circleImageView;

@end

