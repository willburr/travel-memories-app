//
//  Album.h
//  Memories
//
//  Created by User on 15/02/2017.
//  Copyright © 2017 User. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Memory.h"

@interface Album : NSObject <NSCoding>

@property (strong, nonatomic)NSString* albumName;
@property (strong, nonatomic)NSMutableArray* memories;

-(instancetype)init: (NSString*)albumName;
-(instancetype)init: (NSString*)albumName withMemories: (NSMutableArray*)memories;

-(void)addMemory: (Memory*) memory;
-(void)removeMemory: (Memory*)memory;

@end
