//
//  AlbumVC.h
//  Memories
//
//  Created by User on 22/02/2017.
//  Copyright © 2017 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMViewController.h"
#import "JournalView.h"
#import "AlbumTableView.h"
#import "Album.h"
#import "Memory.h"

@protocol AlbumVCDelegate <NSObject>

-(void)albumsUpdateFromAlbumVC;
-(void)disableSuperScroll;
-(void)enableSuperScroll;

@end

@interface AlbumVC : TMViewController <UIScrollViewDelegate, AlbumTableViewDelegate, JournalViewDelegate>

@property (strong, nonatomic)JournalView* journalView;
@property (strong, nonatomic)AlbumTableView* albumTableView;
@property (strong, nonatomic)UIScrollView* scrollView;
@property (strong, nonatomic)NSMutableArray* albums;
@property (strong, nonatomic)id <AlbumVCDelegate> delegate;

-(void)updateData;

@end
