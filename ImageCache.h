//
//  ImageCache.h
//  FlashRe
//
//  Created by Niranjan Ambildhok on 26/04/13.
//  Copyright (c) 2013 Niranjan Ambildhok. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ImageCacheDownloadCompletionHandler)(UIImage *image);

@interface ImageCache : NSObject

+ (id)sharedInstance;

- (UIImage*)imageForKey:(NSString*)key;
- (void)setImage:(UIImage*)image forKey:(NSString*)key;
- (void)downloadImageAtURL:(NSURL*)url completionHandler:(ImageCacheDownloadCompletionHandler)completion;

@end
