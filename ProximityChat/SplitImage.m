//
//  SplitImage.m
//  ProximityChat
//
//  Created by Paul Bright on 2014/09/16.
//  Copyright (c) 2014 Paul Bright. All rights reserved.
//

#import "SplitImage.h"

#define IMAGE_SNAP_THRESHOLD_X  40
#define IMAGE_SNAP_THRESHOLD_Y  40

@implementation SplitImage
{
    
    
}

-(id) initWithImage : (UIImage *) img current_point: (CGPoint) cp original_point:(CGPoint) op index:(int) i
{
    self = [super init];
    
    _image = img;
    _current_point = cp;
    _original_point = op;
    _index = i;
    return self;
}


-(BOOL) imageCloseToOriginal :(CGPoint) p index:(int) i
{
    BOOL close_enough = FALSE;
    
    
        short h = p.x - _original_point.x;
        short v = p.y - _original_point.y;
    
        if (abs(h) <=IMAGE_SNAP_THRESHOLD_X && abs(v) <=IMAGE_SNAP_THRESHOLD_Y)
        {
            close_enough = TRUE;
        }
    
    return close_enough;
}
@end
