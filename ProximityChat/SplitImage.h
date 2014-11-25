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
    
}

@property UIImageView *imageView;
@property UIImage *image;
@property CGPoint current_point;
@property CGPoint original_point;
@property int index;

-(id) initWithImage : (UIImage *) image current_point: (CGPoint) cp original_point:(CGPoint) op index:(int) i ;

-(BOOL) imageCloseToOriginal :(CGPoint) p index:(int) i;
@end
