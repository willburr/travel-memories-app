//
//  AlbumSelectorVC.h
//  Memories
//
//  Created by William Burr on 10/03/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMViewController.h"
#import "TMHeaderView.h"
#import "AlbumTableView.h"

@protocol AlbumSelectorVCDelegate <NSObject>

-(void)albumSelected: (NSInteger)index;

@end

@interface AlbumSelectorVC : TMViewController <AlbumTableViewDelegate>

@property (strong, nonatomic)NSMutableArray* albums;
@property (strong, nonatomic)NSMutableArray* displayedAlbums;
@property (strong, nonatomic)Memory* memory;
@property (strong, nonatomic)AlbumTableView* albumTableView;
@property (strong, nonatomic)id <AlbumSelectorVCDelegate> delegate;

-(instancetype)initForMemory: (Memory*)memory;


@end
