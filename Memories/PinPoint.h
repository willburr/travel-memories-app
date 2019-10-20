//
//  PinPoint.h
//  Memories
//
//  Created by William Burr on 04/03/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface PinPoint : NSObject <NSCoding>

@property (strong, nonatomic)CLLocation* location;
@property (strong, nonatomic)NSString* year;


-(instancetype)initWithLocation: (CLLocation*)location andYearPlotted: (NSString*)year;

@end
