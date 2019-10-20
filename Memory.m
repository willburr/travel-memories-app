
//
//  Memory.m
//  Memories
//
//  Created by William Burr on 17/02/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import "Memory.h"


@implementation Memory

//MARK: - Initialisation
-(instancetype)init:(UIImage*)photo withCaption: (NSString*)caption {
    self.caption = caption;
    self.photo = photo;
    return self;
}

//This method is for when not all the properties are available.
-(instancetype)initWithIdentifier:(NSInteger)identifier andPhoto: (UIImage*)photo withCaption: (NSString*)caption{
    self = [super init];
    self.identifier = identifier;
    self.caption = caption;
    self.photo = photo;
    return self;
}
//This method is for when all the properties are available.
-(instancetype)initWithIdentifier:(NSInteger)identifier andPhoto: (UIImage*)photo withCaption: (NSString*)caption withLocation: (CLLocation*)location withDateTaken: (NSString*) dateTaken withFrameColour: (UIColor*) frameColour {
    self = [super init];
    self.identifier = identifier;
    self.caption = caption;
    self.photo = photo;
    self.location = location;
    self.dateTaken = dateTaken;
    self.frameColour = frameColour;
    return self;
}
//MARK: - Encoding
-(void)encodeWithCoder:(NSCoder *)aCoder{
    //Each property is encoded with a specific key, which is part of storing the Memory.
    [aCoder encodeInteger:self.identifier forKey:@"MemoryPropertyIdentifier"];
    [aCoder encodeObject:self.caption forKey:@"MemoryPropertyCaption"];
    [aCoder encodeObject:self.photo forKey:@"MemoryPropertyPhoto"];
    [aCoder encodeObject:self.location forKey:@"MemoryPropertyLocation"];
    [aCoder encodeObject:self.dateTaken forKey:@"MemoryPropertyDateTaken"];
    [aCoder encodeObject:self.frameColour forKey:@"MemoryPropertyFrameColour"];
}
//MARK: - Decoding
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    //Each property is decoded by retrieving it from their respective key, which is part of loading the Memory.
    NSInteger identifier = [aDecoder decodeIntegerForKey:@"MemoryPropertyIdentifier"];
    NSString *caption = [aDecoder decodeObjectForKey:@"MemoryPropertyCaption"];
    UIImage *photo = [aDecoder decodeObjectForKey:@"MemoryPropertyPhoto"];
    CLLocation *location = [aDecoder decodeObjectForKey:@"MemoryPropertyLocation"];
    NSString *dateTaken = [aDecoder decodeObjectForKey:@"MemoryPropertyDateTaken"];
    UIColor *frameColour = [aDecoder decodeObjectForKey:@"MemoryPropertyFrameColour"];
    //These properties are then used to create a Memory object using my instantiation method.
    self = [self initWithIdentifier:identifier andPhoto:photo withCaption:caption withLocation:location withDateTaken:dateTaken withFrameColour:frameColour];
    return self;
}


@end
