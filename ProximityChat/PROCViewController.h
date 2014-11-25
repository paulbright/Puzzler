//
//  PROCViewController.h
//  ProximityChat
//
//  Created by Paul Bright on 2014/09/05.
//  Copyright (c) 2014 Paul Bright. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import <GameController/GameController.h>
#import <GameKit/GKPeerPickerController.h>
#import <iAd/iAd.h>
#import "CustomView.h"

@interface PROCViewController : UIViewController <GKSessionDelegate, ADBannerViewDelegate, UIGestureRecognizerDelegate>
{
    IBOutlet UILabel *lbl_info;
    
    GKSession * session;
    
    ADBannerView *adview;
    
    IBOutlet CustomView *theView;
    
    IBOutlet UIImageView *testView1;
    IBOutlet UIImageView *testView2;
    IBOutlet UIImageView *testView3;
    IBOutlet UIImageView *testView4;
    IBOutlet UIImageView *testView5;
    IBOutlet UIImageView *testView6;
    IBOutlet UIImageView *testView7;
    IBOutlet UIImageView *testView8;
    IBOutlet UIImageView *testView9;
    
    IBOutlet UIImageView *imageView;
    
    IBOutlet UIButton *buttonSplit;
    
    IBOutlet UITextField *textNumberOfSplits;
    NSMutableArray *imgViewArray;
    
    NSMutableArray *splitImageArray;
    
}

-(UIImage *) resizeImage : (UIImage *) image resizeTo: (CGRect) rect;

-(IBAction) clickSplitButton : (id) sender ;

-(NSMutableArray *)getImagesFromImage:(UIImage *)image withRow:(NSInteger)rows withColumn:(NSInteger)columns;

@property (nonatomic, retain)  ADBannerView *adview;

@end
