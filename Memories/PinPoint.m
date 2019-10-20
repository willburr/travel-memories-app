//
//  PinPoint.m
//  Memories
//
//  Created by User on 04/03/2017.
//  Copyright © 2017 User. All rights reserved.
//

#import "PinPoint.h"


@implementation PinPoint

//MARK: - Initialisation

-(instancetype)initWithLocation: (CLLocation*)location andYearPlotted:(NSString *)year{
    self = [super init];
    self.location = location;
    self.year = year;
    return self;
}

//MARK: - Encoding
-(void)encodeWithCoder:(NSCoder *)aCoder{
    //Each property is encoded with a specific key, which is part of storing the pin Point.
    [aCoder encodeObject:self.location forKey:@"PinPropertyLocation"];
    [aCoder encodeObject:self.year forKey:@"PinPropertyYear"];
}

//MARK: - Decoding
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    //Each property is decoded by retrieving it from their respective key, which is part of loading the Pin Point.
    CLLocation *location = [aDecoder decodeObjectForKey:@"PinPropertyLocation"];
    NSString *year = [aDecoder decodeObjectForKey:@"PinPropertyYear"];
    //These properties are then used to create a Pin Point object using my instantiation method.
    self = [self initWithLocation:location andYearPlotted:year];
    return self;
}


@end
