//
//  TMViewController.h
//  Memories
//
//  Created by William Burr on 14/02/2017.
//  Copyright © 2017 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMHeaderView.h"
#import "Album.h"
#import "Memory.h"



@interface TMViewController : UIViewController

@property (strong, nonatomic) TMHeaderView *headerView;
@property (assign, nonatomic) TMHeaderStyle *headerStyle;
@property (assign, nonatomic) CGSize screenSize;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil headerNav: (TMHeaderStyle)headerStyle;
-(void)setCustomHeaderTitle: (NSString*)text;
-(void)changeCustomHeaderStyle: (TMHeaderStyle) navStyle;
-(void)setEditBtnAction;
-(void)backAction;
-(void)editAction;
-(void)addAction;


-(NSMutableArray*)loadAlbums;
-(void)saveAlbums: (NSMutableArray*)albums;

-(bool)album: (Album*) album containsMemory:(Memory*) memory;
-(int)album: (Album*) album getIndexOfMemory:(Memory*) memory;

@end
