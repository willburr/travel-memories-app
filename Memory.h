//
//  Memory.h
//  Memories
//
//  Created by William Burr on 17/02/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface Memory : NSObject <NSCoding>

@property (assign, nonatomic) NSInteger identifier;
@property (strong, nonatomic) UIImage* photo;
@property (strong, nonatomic) NSString* caption;
@property (strong, nonatomic)CLLocation* location;
@property (strong, nonatomic) NSString* dateTaken;
@property (strong, nonatomic) UIColor* frameColour;

-(instancetype)init:(UIImage*)photo withCaption: (NSString*)caption;

-(instancetype)initWithIdentifier:(NSInteger)identifier andPhoto: (UIImage*)photo withCaption: (NSString*)caption;
-(instancetype)initWithIdentifier:(NSInteger)identifier andPhoto: (UIImage*)photo withCaption: (NSString*)caption withLocation: (CLLocation*)location withDateTaken: (NSString*) dateTaken withFrameColour: (UIColor*) frameColour;
@end
