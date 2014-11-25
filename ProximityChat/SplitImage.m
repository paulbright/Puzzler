//
//  SplitImage.m
//  ProximityChat
//
//  Created by Paul Bright on 2014/09/16.
//  Copyright (c) 2014 Paul Bright. All rights reserved.
//

#import "SplitImage.h"

#define IMAGE_SNAP_THRESHOLD_X  20
#define IMAGE_SNAP_THRESHOLD_Y  20

@implementation SplitImage
{
    
    
}

-(void) initWithImage : (UIImage *) img current_point: (Point) cp original_point:(Point) op index:(int) i
{
    image = img;
    current_point = cp;
    original_point = op;
    index = i;
}


-(BOOL) imageCloseToOriginal :(Point) p index:(int) i
{
    BOOL close_enough = FALSE;
    
    if( index == i )
    {
        short h = p.h - original_point.h;
        short v = p.v - original_point.v;
    
        if (abs(h) <=IMAGE_SNAP_THRESHOLD_X && abs(v) <=IMAGE_SNAP_THRESHOLD_Y)
        {
            close_enough = TRUE;
        }
    }
    return close_enough;
}
@end
