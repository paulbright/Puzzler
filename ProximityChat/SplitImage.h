//
//  SplitImage.h
//  ProximityChat
//
//  Created by Paul Bright on 2014/09/16.
//  Copyright (c) 2014 Paul Bright. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SplitImage : NSObject
{
    UIImage *image;
    Point current_point;
    Point original_point;
    int index;
}

-(void) initWithImage : (UIImage *) image current_point: (Point) cp original_point:(Point) op index:(int) i ;

-(BOOL) imageCloseToOriginal :(Point) p index:(int) i;
@end
