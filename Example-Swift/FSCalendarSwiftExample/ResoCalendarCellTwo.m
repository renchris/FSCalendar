//
//  FSCalendarCell.m
//  Pods
//
//  Created by Wenchao Ding on 12/3/15.
//
//

#import "ResoCalendarCellTwo.h"
#import "FSCalendarExtensions.h"

@interface ResoCalendarCellTwo ()

@property (readonly, nonatomic) CGFloat borderRadius;

@end

@implementation ResoCalendarCellTwo

- (CGFloat)borderRadius
{
    return self.preferredBorderRadius >= 0 ? self.preferredBorderRadius : self.appearance.borderRadius;
}

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    UILabel *label;
    CAShapeLayer *shapeLayer;
    UIImageView *imageView;
    CAShapeLayer *circleLayer;

    FSCalendarEventIndicator *eventIndicator;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [self.contentView addSubview:label];
    self.titleLabel = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:label];
    self.subtitleLabel = label;
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 1.0;
    shapeLayer.borderColor = [UIColor clearColor].CGColor;
    shapeLayer.opacity = 0;
    [self.contentView.layer insertSublayer:shapeLayer below:self.titleLabel.layer]; //underscore to self
    self.shapeLayer = shapeLayer;
    
    circleLayer = [CAShapeLayer layer];//[[CAShapeLayer alloc] init];
    circleLayer.backgroundColor = [UIColor clearColor].CGColor;
    circleLayer.borderWidth = 1.0;
    circleLayer.borderColor = [UIColor clearColor].CGColor;
    
    circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    circleLayer.lineWidth = 2.0;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
//    [circleLayer setStrokeColor:[[UIColor redColor] CGColor]];
//    [circleLayer setLineWidth:(2.0)];
//    [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
    [self.contentView.layer insertSublayer:circleLayer below:self.titleLabel.layer]; //underscore to self
    self.circleLayer = circleLayer;
    
    eventIndicator = [[FSCalendarEventIndicator alloc] initWithFrame:CGRectZero];
    eventIndicator.backgroundColor = [UIColor clearColor];
    eventIndicator.hidden = YES;
    [self.contentView addSubview:eventIndicator];
    self.eventIndicator = eventIndicator;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeBottom|UIViewContentModeCenter;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    self.clipsToBounds = NO;
    self.contentView.clipsToBounds = NO;
    
}

//Need this or inner circle is placed incorrectly to the bottom right.
- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    self.circleLayer.frame = self.contentView.bounds;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.subtitle) {
        self.subtitleLabel.text = self.subtitle;
        if (self.subtitleLabel.hidden) {
            self.subtitleLabel.hidden = NO;
        }
    } else {
        if (!self.subtitleLabel.hidden) {
            self.subtitleLabel.hidden = YES;
        }
    }
    
    if (self.subtitle) {
        CGFloat titleHeight = self.titleLabel.font.lineHeight;
        CGFloat subtitleHeight = self.subtitleLabel.font.lineHeight;
        
        CGFloat height = titleHeight + subtitleHeight;
        self.titleLabel.frame = CGRectMake(
                                       self.preferredTitleOffset.x,
                                       (self.contentView.fs_height*5.0/6.0-height)*0.5+self.preferredTitleOffset.y,
                                       self.contentView.fs_width,
                                       titleHeight
                                       );
        self.subtitleLabel.frame = CGRectMake(
                                          self.preferredSubtitleOffset.x,
                                          (self.titleLabel.fs_bottom-self.preferredTitleOffset.y) - (self.titleLabel.fs_height-self.titleLabel.font.pointSize)+self.preferredSubtitleOffset.y,
                                          self.contentView.fs_width,
                                          subtitleHeight
                                          );
    } else {
        self.titleLabel.frame = CGRectMake(
                                       self.preferredTitleOffset.x,
                                       self.preferredTitleOffset.y,
                                       self.contentView.fs_width,
                                       floor(self.contentView.fs_height*5.0/6.0)
                                       );
    }
    
    self.imageView.frame = CGRectMake(self.preferredImageOffset.x, self.preferredImageOffset.y, self.contentView.fs_width, self.contentView.fs_height);
    
    CGFloat titleHeight = self.bounds.size.height*5.0/6.0;
    CGFloat diameter = MIN(self.bounds.size.height*5.0/6.0,self.bounds.size.width);
    
    //increasing the integer here will make the cirlce smaller. Thus decreasing diameter decreases size.
    //Was originally 0.5.
    //Also decreasing this also contains fill within it too
    diameter = diameter > FSCalendarStandardCellDiameter ? (diameter - (diameter-FSCalendarStandardCellDiameter)*0.5) : diameter;
    
    //decreasing first int moves space to right, increasing moves more space to left
    self.shapeLayer.frame = CGRectMake((self.bounds.size.width-diameter)/2,
                                   (titleHeight-diameter)/2,
                                   diameter,
                                   diameter);
    
    //printf("lineWidth: %f", self.shapeLayer.lineWidth);
    
    self.shapeLayer.lineWidth = 2.0;

    //if today, create circle for white circle, which you wont see as background is white until selected.
    if(self.dateIsToday){
        printf("is today");
        
        self.circleLayer.opacity = 1;
        
        CGFloat circleDiameter = MIN(self.bounds.size.height*5.0/6.0,self.bounds.size.width);
        
        circleDiameter = circleDiameter > FSCalendarStandardCellDiameter ? (circleDiameter - (circleDiameter-FSCalendarStandardCellDiameter)*0.75) : circleDiameter;
        
        self.circleLayer.frame = CGRectMake((self.bounds.size.width-circleDiameter)/2,
        (titleHeight-circleDiameter)/2,
        circleDiameter,
        circleDiameter);
   
        [_circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake((self.bounds.size.width-circleDiameter)/2,
        (titleHeight-circleDiameter)/2,
        circleDiameter,
        circleDiameter)] CGPath]];
    }
    
    
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:self.shapeLayer.bounds
                                                cornerRadius:CGRectGetWidth(self.shapeLayer.bounds)*0.5*self.borderRadius].CGPath;
    if (!CGPathEqualToPath(self.shapeLayer.path,path)) {
        self.shapeLayer.path = path;
    }
    
    CGFloat eventSize = self.shapeLayer.frame.size.height/6.0;
    self.eventIndicator.frame = CGRectMake(
                                       self.preferredEventOffset.x,
                                       CGRectGetMaxY(self.shapeLayer.frame)+eventSize*0.17+self.preferredEventOffset.y,
                                       self.fs_width,
                                       eventSize*0.83
                                      );
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    if (self.window) { // Avoid interrupt of navigation transition somehow
        [CATransaction setDisableActions:YES]; // Avoid blink of shape layer.
    }
    self.circleLayer.opacity = 0;
    [self.contentView.layer removeAnimationForKey:@"opacity"];

    //[self.circleLayer removeAllAnimations];
    //[self.circleLayer removeFromSuperlayer];
}

@end
