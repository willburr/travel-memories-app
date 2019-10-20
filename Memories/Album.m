//
//  Album.m
//  Memories
//
//  Created by User on 15/02/2017.
//  Copyright © 2017 User. All rights reserved.
//

#import "Album.h"

@implementation Album

//MARK: - Initialisation

-(instancetype)init: (NSString*)albumName withMemories: (NSMutableArray*)memories{
    self = [super init];
    self.albumName = albumName;
    self.memories = memories;
    return self;
    
}

-(instancetype)init: (NSString*)albumName{
    self = [super init];
    self.albumName = albumName;
    self.memories = [[NSMutableArray alloc]init];
    return self;
    
}
//MARK: - Functions
-(void)addMemory: (Memory*) memory {
    [self.memories addObject:memory];
}

-(void)removeMemory: (Memory*)memory{
    [self.memories removeObject:memory];
}

//MARK: - Encode
-(void)encodeWithCoder:(NSCoder *)aCoder{
    //Each property is encoded with a specific key, which is part of storing the Memory.
    [aCoder encodeObject:self.albumName forKey:@"AlbumPropertyName"];
    [aCoder encodeObject:self.memories forKey:@"AlbumPropertyMemories"];
}
//MARK: - Decode
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    //Each property is decoded by retrieving it from their respective key, which is part of loading the Album.
    NSString *albumName = [aDecoder decodeObjectForKey:@"AlbumPropertyName"];
    NSMutableArray* memories = [aDecoder decodeObjectForKey:@"AlbumPropertyMemories"];
     //These properties are then used to create a Album object using my instantiation method.
    
    self = [self init:albumName withMemories:memories];
    return self;
}


@end
