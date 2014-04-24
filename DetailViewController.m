//
//  DetailViewController.m
//  LazyLoading
//
//  Created by Ashish Tripathi on 21/04/14.
//  Copyright (c) 2014 Ashish Tripathi. All rights reserved.
//

#import "DetailViewController.h"
#import "AFImageRequestOperation.h"
#import "UIImage+Resize.h"
@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        
        NSURL *url = [NSURL URLWithString:[self.detailItem description]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage* scaledImgH = [image resizedImageToFitInSize:_imgView.frame.size scaleIfSmaller:NO];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (scaledImgH) {
                
                        _imgView.image = scaledImgH;
                 }
                    
                });
            });
        }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
           _imgView.image = [UIImage imageNamed:@"noimage.png"];
            
            
        }];
        
        [operation start];
        
        
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
