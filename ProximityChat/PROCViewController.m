//
//  PROCViewController.m
//  ProximityChat
//
//  Created by Paul Bright on 2014/09/05.
//  Copyright (c) 2014 Paul Bright. All rights reserved.
//

#import "PROCViewController.h"
#import "PROCAppDelegate.h"; 
#import "SplitImage.h"


#define kGameKitSessionID @"proximity chat(1.0)"

@implementation PROCViewController

@synthesize adview;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    lbl_info.text = @"data";
    
    adview.delegate = self;
    
    UIImage *originalImage = [UIImage imageNamed:@"lighthouse.jpg"];
    
    UIImage *image = [self normalizedImage:originalImage];
    
    UIImage *img = [self resizeImage:image resizeTo:puzzleImageView.frame];
    
    imageView.image = img;
    //[self drawRect:puzzleImageView.frame];
}


- (UIImage *)normalizedImage  : (UIImage *) image
{
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}

-(UIImage *) resizeImage : (UIImage *) image resizeTo: (CGRect) rect
{
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGRect rec = CGRectMake(0, 0, rect.size.width, rect.size.height);
    [image drawInRect:rec];
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    NSData *imageData = UIImagePNGRepresentation(picture1);
    return [UIImage imageWithData:imageData];
}


-(void)splitImage:(UIImage *)image
{
    CGFloat imgWidth = image.size.width/2;
    CGFloat imgheight = image.size.height;
    CGRect leftImgFrame = CGRectMake(0, 0, imgWidth, imgheight);
    CGRect rightImgFrame = CGRectMake(imgWidth, 0, imgWidth, imgheight);
    
    CGImageRef left = CGImageCreateWithImageInRect(image.CGImage, leftImgFrame);
    CGImageRef right = CGImageCreateWithImageInRect(image.CGImage, rightImgFrame);
    
    CGImageRelease(left);
    CGImageRelease(right);
}

- (void)tap:(UITapGestureRecognizer*)gesture
{
    SplitImage *si = (SplitImage *)[puzzleArray objectAtIndex:gesture.view.tag];
    
    NSLog(@"image tap=%d original_loc:%d", gesture.view.tag, si.index);
}

- (void)panPuzzlePiece:(UIPanGestureRecognizer *)recognizer
{
    
    CGPoint translation = [recognizer translationInView:self.view];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.view];
    
    for(SplitImage *si in puzzleArray)
    {
        if([si imageView] == recognizer.view)
        {
            si.current_point = recognizer.view.center;
            if([si imageCloseToOriginal:recognizer.view.frame.origin index:si.index])
            {
                recognizer.enabled = NO;
                recognizer.enabled = YES;
                si.imageView.frame = CGRectMake(si.original_point.x, si.original_point.y, si.image.size.width, si.image.size.height) ;
            }
            break;
        }
    }
    /*
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        
        CGPoint velocity = [recognizer velocityInView:self.view];
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
        CGFloat slideMult = magnitude / 200;
        NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
        
        float slideFactor = 0.1 * slideMult; // Increase for more of a slide
        CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                         recognizer.view.center.y + (velocity.y * slideFactor));
        finalPoint.x = MIN(MAX(finalPoint.x, 0), self.view.bounds.size.width);
        finalPoint.y = MIN(MAX(finalPoint.y, 0), self.view.bounds.size.height);
        
        [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            recognizer.view.center = finalPoint;
        } completion:nil];
        
    }
     */
}

-(NSMutableArray *)getImagesFromImage:(UIImage *)image withRow:(NSInteger)rows withColumn:(NSInteger)columns
{
    
    NSMutableArray *images = [NSMutableArray array];
    puzzleArray = [[NSMutableArray alloc] init];
    CGSize imageSize = image.size;
    CGFloat xPos = 0.0, yPos = 0.0;
    CGFloat width = imageSize.width/columns;
    CGFloat height = imageSize.height/rows;
    int array_index = 0;
    CGFloat destX = 0.0, destY = 0.0;
    
    destX = puzzleImageView.frame.origin.x;
    destY = puzzleImageView.frame.origin.y;
    
    for (int y = 0; y < rows; y++) {
        xPos = 0.0;
        destX = puzzleImageView.frame.origin.x;
        for (int x = 0; x < columns; x++) {
            
            CGRect rect = CGRectMake(xPos , yPos , width , height );
            
            NSLog(@"scale:%.02f %.02f %.02f - %.02f %.02f", image.scale, xPos, yPos, width,height);
            
            CGImageRef cImage = CGImageCreateWithImageInRect(image.CGImage,  rect);
            
            UIImage *dImage = [UIImage imageWithCGImage:cImage scale:image.scale orientation:image.imageOrientation];
            [images addObject:dImage];
            SplitImage *si = [[SplitImage alloc] initWithImage:dImage current_point:CGPointMake(destX, destY) original_point:CGPointMake(destX, destY) index:array_index];
            [puzzleArray addObject:si];
            
            xPos += width;
            destX += width;
            ++array_index;
        }
        yPos  += height;
        destY +=height;
    }
    return images;

}

-(void) saveImagetoFile : (UIImage *) image  file: (NSString *) filename
{
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    
    NSData * binaryImageData = UIImagePNGRepresentation(image);
    
    [binaryImageData writeToFile:[basePath stringByAppendingPathComponent:filename] atomically:TRUE];
}

- (void)shuffle
{
    NSUInteger count = [puzzleArray count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger exchangeIndex = arc4random_uniform(count);
        if (i != exchangeIndex) {
            [puzzleArray exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
        }
    }
}

-(void) displaySplitImages : (BOOL) scrambled
{
    
    CGPoint startPoint;
    int vgap = 10;
    int hgap = 10;
    int array_index = 0;
    int num_splits = [puzzleArray count] ;
    
    num_splits = sqrt(num_splits);
    
    startPoint = imageView.frame.origin;
    startPoint.y = startPoint.y + imageView.frame.size.height + 20;
    
    if(scrambled) [self shuffle];
    
    for (int r=0; r < num_splits; r++)
    {
        for (int c=0; c < num_splits; c++)
        {
            SplitImage *si = [puzzleArray objectAtIndex:array_index];
            UIImage *img = si.image;
            
            int y = startPoint.y +  (img.size.height * r) + r * vgap;
            int x = startPoint.x +  (img.size.width * c ) + c * hgap;
            
            CGRect rect = CGRectMake(x , y , img.size.width , img.size.height);
            
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:rect];
            imgV.userInteractionEnabled = TRUE;
            [imgV setBounds:rect];
            [imgV setImage:img];
            si.imageView = imgV;
            [self.view addSubview:imgV];
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tap:)];
            
            
            UIPanGestureRecognizer* panPuzzlePieceGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(panPuzzlePiece:)];
            
            panPuzzlePieceGesture.delegate = self;
            
            tap.delegate = self;
            tap.numberOfTapsRequired = 1;
            [imgV addGestureRecognizer:tap];
            [imgV addGestureRecognizer:panPuzzlePieceGesture];
            imgV.tag  = array_index;
            ++array_index;
        }
    }

}

-(IBAction) clickSplitButton : (id) sender
{
    int num_splits = [textNumberOfSplits text].intValue;
    splitImageArray = [self getImagesFromImage:imageView.image withRow:num_splits withColumn:num_splits];
    [self displaySplitImages:TRUE];
}

-(void) viewWillAppear:(BOOL)animated
{
    adview = [[self appDelegate] adview];
    adview.delegate = self;
    [adview setFrame:CGRectMake(10, 20, 300, 50)];
    [self.view addSubview:adview];
}

-(PROCAppDelegate *) appDelegate
{
    return (PROCAppDelegate *) [[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark iAd delegate methods

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    adview.hidden = true;
    NSLog(@"no ad. hiding");
}

-(void) bannerViewWillLoadAd:(ADBannerView *)banner
{
    
}

-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    adview.hidden = false;
    NSLog(@"has ad. displaying");
}

@end
