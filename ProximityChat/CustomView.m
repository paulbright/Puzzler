//
//  CustomView.m
//  ProximityChat
//
//  Created by Paul Bright on 2014/09/18.
//  Copyright (c) 2014 Paul Bright. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
 // Drawing code
NSLog(@"drawRect %.02f %.02f", rect.size.width, rect.size.height);
   
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.0);   //this is the transparent color
    CGContextSetRGBStrokeColor(context, 0.0, 0.0, 0.0, 0.5);
    CGContextFillRect(context, rect);
    CGContextStrokeRect(context, rect);    //this will draw the border

}
*/

@end
