//
//  DetailViewController.h
//  LazyLoading
//
//  Created by Ashish Tripathi on 21/04/14.
//  Copyright (c) 2014 Ashish Tripathi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;


@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end
