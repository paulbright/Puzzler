//
//  PROCAppDelegate.h
//  ProximityChat
//
//  Created by Paul Bright on 2014/09/05.
//  Copyright (c) 2014 Paul Bright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface PROCAppDelegate : UIResponder <UIApplicationDelegate, ADBannerViewDelegate>
{
    ADBannerView *adview;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)  ADBannerView *adview;

@end
