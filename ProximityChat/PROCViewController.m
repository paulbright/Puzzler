//
//  PROCViewController.m
//  ProximityChat
//
//  Created by Paul Bright on 2014/09/05.
//  Copyright (c) 2014 Paul Bright. All rights reserved.
//

#import "PROCViewController.h"
#import "PROCAppDelegate.h"; 


#define kGameKitSessionID @"proximity chat(1.0)"

@implementation PROCViewController

@synthesize adview;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    lbl_info.text = @"data";
    
    adview.delegate = self;
    /*
    session = [[GKSession alloc] initWithSessionID:kGameKitSessionID displayName:nil sessionMode:GKSessionModePeer];
    
    session.delegate = self;
    
    GKPeerPickerController * picker = [[GKPeerPickerController alloc] init];
    
    picker.connectionTypesMask = GKPeerPickerConnectionTypeNearby |
                                    GKPeerPickerConnectionTypeOnline;
    
    [picker show];
    
    */
    
    
    imgViewArray = [NSMutableArray arrayWithObjects:  testView1, testView2, testView3 , testView4,
                    testView5,  testView6, testView7, testView8, testView9, nil];
    
    UIImage *originalImage = [UIImage imageNamed:@"lighthouse.jpg"];
    
    UIImage *image = [self normalizedImage:originalImage];
    
    UIImage *img = [self resizeImage:image resizeTo:imageView.frame];
    
    imageView.image = img;
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
    
    UIImage* leftImage = [UIImage imageWithCGImage:left];
    UIImage* rightImage = [UIImage imageWithCGImage:right];
    
    CGImageRelease(left);
    CGImageRelease(right);
}

- (void)tap:(UITapGestureRecognizer*)gesture
{
    NSLog(@"image tap=%d", gesture.view.tag);
}

-(NSMutableArray *)getImagesFromImage:(UIImage *)image withRow:(NSInteger)rows withColumn:(NSInteger)columns
{
    
    NSMutableArray *images = [NSMutableArray array];
    CGSize imageSize = image.size;
    CGFloat xPos = 0.0, yPos = 0.0;
    CGFloat width = imageSize.width/columns;
    CGFloat height = imageSize.height/rows;
    int array_index = 0;

    for (int y = 0; y < rows; y++) {
        xPos = 0.0;
        for (int x = 0; x < columns; x++) {
            
            CGRect rect = CGRectMake(xPos , yPos , width , height );
            
            NSLog(@"scale:%.02f %.02f %.02f - %.02f %.02f", image.scale, xPos, yPos, width,height);
            
            CGImageRef cImage = CGImageCreateWithImageInRect(image.CGImage,  rect);
            
            UIImage *dImage = [UIImage imageWithCGImage:cImage scale:image.scale orientation:image.imageOrientation];
            [images addObject:dImage];
            
            xPos += width;
            ++array_index;
        }
        yPos += height;
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

-(void) displaySplitImages : (BOOL) scrambled
{
    
    CGPoint startPoint;
    int vgap = 10;
    int hgap = 10;
    int array_index = 0;
    NSMutableArray *images = splitImageArray;
    int num_splits = [splitImageArray count] ;
    
    num_splits = sqrt(num_splits);
    
    startPoint = imageView.frame.origin;
    startPoint.y = startPoint.y + imageView.frame.size.height + 20;
    
    for (int r=0; r < num_splits; r++)
    {
        for (int c=0; c < num_splits; c++)
        {
            UIImage *img = ((UIImage *)[images objectAtIndex: array_index]);
            
            int y = startPoint.y +  (img.size.height * r) + r * vgap;
            int x = startPoint.x +  (img.size.width * c ) + c * hgap;
            
            //CGRect rect = CGRectMake(x *.5, y *.5, img.size.width *.5, img.size.height * .5);
            
            CGRect rect = CGRectMake(x , y , img.size.width , img.size.height);
            
            UIImageView *imgV = [[UIImageView alloc] initWithFrame:rect];
            imgV.userInteractionEnabled = TRUE;
            [imgV setBounds:rect];
            [imgV setImage:img];
            [self.view addSubview:imgV];
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tap:)];
            tap.delegate = self;
            tap.numberOfTapsRequired = 1;
            [imgV addGestureRecognizer:tap];
            imgV.tag  = array_index;
            ++array_index;
        }
    }

}

-(IBAction) clickSplitButton : (id) sender
{
    int num_splits = [textNumberOfSplits text].intValue;
    
    //imageView.frame.origin.y + imageView.frame.size.height + vgap;
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
