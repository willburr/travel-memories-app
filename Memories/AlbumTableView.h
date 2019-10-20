//
//  AlbumTableView.h
//  Memories
//
//  Created by William Burr on 01/03/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"
#import "Memory.h"
@protocol AlbumTableViewDelegate <NSObject>

-(void)didSelectAlbumAtPath: (NSIndexPath*)indexPath;
-(void)didDeleteAlbumAtPath: (NSIndexPath*)indexPath;

@end

@interface AlbumTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (assign, nonatomic)CGSize screenSize;
@property (strong, nonatomic)NSMutableArray* albums;
@property (strong, nonatomic)id <AlbumTableViewDelegate> albumTableViewDelegate;
@property (assign, nonatomic)BOOL isEditable;

-(void)commonInit: (NSMutableArray* )albums;
@end
