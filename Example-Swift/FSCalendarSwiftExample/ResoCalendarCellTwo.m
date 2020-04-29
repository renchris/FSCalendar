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
    
    if(self.dateIsToday){
        printf("is today");
        self.shapeLayer.lineWidth = 2.0;
        
        CGFloat circleDiameter = MIN(self.bounds.size.height*5.0/6.0,self.bounds.size.width);
        
        circleDiameter = diameter > FSCalendarStandardCellDiameter ? (diameter - (diameter-FSCalendarStandardCellDiameter)*0.75) : diameter;
        
        
        
        CAShapeLayer *circleLayer = [CAShapeLayer layer];
        
   
        [circleLayer setPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake((self.bounds.size.width-circleDiameter)/2,
        (titleHeight-circleDiameter)/2,
        circleDiameter,
        circleDiameter)] CGPath]];
        [self.contentView.layer addSublayer:circleLayer];
        [circleLayer setStrokeColor:[[UIColor whiteColor] CGColor]];
        [circleLayer setLineWidth:(2.0)];
        [circleLayer setFillColor:[[UIColor clearColor] CGColor]];
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

@end
