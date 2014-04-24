//
//  MasterViewController.m
//  LazyLoading
//
//  Created by Ashish Tripathi on 21/04/14.
//  Copyright (c) 2014 Ashish Tripathi. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"
#import "MessageCell.h"
#import "UIImage+Resize.h"
#import "AFImageRequestOperation.h"
@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSArray *arr = [NSArray arrayWithObjects:
     @"http://www.hdesktops.com/wp-content/uploads/2013/09/Full-HD-Abstract-Wallpapers-85.jpg",
     @"http://wonderfulengineering.com/wp-content/uploads/2013/12/hd-wallpaper-desktop-1.jpeg",
     @"http://www.hdwallpapers.in/walls/dream_village_hd-HD.jpg",
     @"http://www.hdesktops.com/wp-content/uploads/2014/04/windows_8_hd_wallpaper_organic.jpg",
     @"http://www.hdesktops.com/wp-content/uploads/2013/12/abstract-michael-michael-jordan-wallpaper-wings-129.jpg",
     @"http://www.wallpaperfunda.com/wp-content/uploads/2013/08/Top-Hd-Wallpapers-2.jpg",
     @"http://www.hdpaperz.com/wp-content/gallery/wallpaper_wallpaper_04/beach-wallpaper-hd-11.jpg",
     @"http://www.genovic.com/thumbs/2013/02/6/hd-wallpapers-for-vista-hd-wallpapers.jpg",
     @"http://newevolutiondesigns.com/images/freebies/hd-wallpaper-25.jpg",
     @"http://echomon.co.uk/wp-content/uploads/2013/07/Free-Widescreen-Wallpaper-Downloads.jpg",
     @"http://2.bp.blogspot.com/-l2QVNj2AglQ/UEhi9bUCd7I/AAAAAAAABDo/dzltwYD5Xr8/s1600/waterfall-forest-green-full-HD-nature-background-wallpaper-for-laptop-widescreen.jpg",
     @"http://1.bp.blogspot.com/-KbiXbRJQ6aE/UTgU_zLpEtI/AAAAAAAAB9g/aLROuhhGvjU/s1600/Animals-african-leopard-high-definition-wallpaper-hd-wallpaper.jpg",
     @"http://www.desktopict.com/wp-content/uploads/2014/03/hd-golf-wallpaper-6.jpg",
     @"http://bigbackground.com/wp-content/uploads/2013/07/golf-wallpaper-widescreen.jpg",
     @"http://www.hd-wallpapers.com/download/closeup-golf-ball-over-the-golf_1920x1080_549-hd.jpg",
     @"http://3.bp.blogspot.com/-rtKfaHpAecs/UPS4o4COHwI/AAAAAAAAAtQ/4RWR-drZRLw/s1600/HD-Dark-with-Yellow-Wallpaper-Screensavers.jpg",
     @"http://beautifulcoolwallpapers.files.wordpress.com/2011/08/tree_wallpaper_hd_wallpaper_hd.jpg",
     @"http://beautifulcoolwallpapers.files.wordpress.com/2011/08/tree_wallpaper_hd_wallpaper_hd.jpg",
     @"http://www.wallpaperspictures.net/image/my-studio-tree-wallpaper-for-1920x1080-hdtv-1080p-2463-15.jpg",
     @"http://www.wallpapersad.com/wp-content/uploads/2013/05/Old-Tree-.jpg",
     @"http://www.hdwallpaperscool.com/wp-content/uploads/2014/03/lamborghini-gallardo-black.jpg",
     @"http://www.blogorola.com/wp-content/uploads/2014/03/2010-Lamborghini-Murcielago-Reventon-Roadster-18.jpg", nil];

    _objects = [[NSMutableArray alloc]init];
    [_objects addObjectsFromArray:arr];
    //[self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 160.0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Message_Cell";
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessageCell_iPhone" owner:self options:nil];
        cell = (MessageCell *)[nib objectAtIndex:0];
    }
    [cell.activityIndicator startAnimating];
    NSURL *url = [NSURL URLWithString:[_objects objectAtIndex:indexPath.row]];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    BOOL valid = [NSURLConnection canHandleRequest:req];
    cell.imageViewGroup.image = [UIImage imageNamed:@"noimage.png"];
    if (valid){
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request imageProcessingBlock:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImage* scaledImgH = [image resizedImageToFitInSize:cell.imageViewGroup.frame.size scaleIfSmaller:NO];
                
                dispatch_async(dispatch_get_main_queue(), ^{

                    if (scaledImgH) {
                        
                        MessageCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        if (updateCell)
                            
                        updateCell.imageViewGroup.image = scaledImgH;
                        [updateCell.activityIndicator stopAnimating];
                    }

                });
            });
        }
        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                                                                                   
        cell.imageViewGroup.image = [UIImage imageNamed:@"noimage.png"];
            [cell.activityIndicator stopAnimating];
        
        }];
       
        [operation start];
    }
    else{
     
        cell.imageViewGroup.image = [UIImage imageNamed:@"noimage.png"];
        [cell.activityIndicator stopAnimating];
    
    }
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)saveImage: (UIImage*)image withName:(NSString *)name
{
    if (image != nil)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                             NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString* path = [documentsDirectory stringByAppendingPathComponent:name];
        NSData* data = UIImageJPEGRepresentation(image,0.4);
        [data writeToFile:path atomically:YES];
    }
}
- (UIImage*)loadImagewithName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString* path = [documentsDirectory stringByAppendingPathComponent:name];
    UIImage* image = [UIImage imageWithContentsOfFile:path];
    return image;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSString *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
