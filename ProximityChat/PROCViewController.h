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

    
    __weak IBOutlet UIImageView *puzzleImageView;
    IBOutlet UIImageView *imageView;
    
    IBOutlet UIButton *buttonSplit;
    
    IBOutlet UITextField *textNumberOfSplits;
    
    NSMutableArray *splitImageArray;
    NSMutableArray *puzzleArray;
    
}

-(UIImage *) resizeImage : (UIImage *) image resizeTo: (CGRect) rect;

-(IBAction) clickSplitButton : (id) sender ;

-(NSMutableArray *)getImagesFromImage:(UIImage *)image withRow:(NSInteger)rows withColumn:(NSInteger)columns;

@property (nonatomic, retain)  ADBannerView *adview;

@end
