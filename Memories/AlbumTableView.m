//
//  AlbumTableView.m
//  Memories
//
//  Created by William Burr on 01/03/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import "AlbumTableView.h"
#import "AlbumTableViewCell.h"


@implementation AlbumTableView

@synthesize albumTableViewDelegate;

//MARK: - Initialisation

-(void)commonInit: (NSMutableArray*) albums{
    self.albums = albums;
    self.screenSize = [[UIScreen mainScreen]bounds].size;
    self.isEditable = NO;
    //The table view is set up
    [self setUpTableView];
    
}

//MARK: Table View

-(void)setUpTableView {
    self.delegate = self;
    self.dataSource = self;
    self.allowsMultipleSelectionDuringEditing = NO;
    self.backgroundColor = [UIColor clearColor];
    [self registerNib:[UINib nibWithNibName:@"AlbumTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"AlbumTableViewCell"];
    
}

//MARK: - Delegate

//This loads the cell for each row.

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AlbumTableViewCell *cell = [self dequeueReusableCellWithIdentifier:@"AlbumTableViewCell"];
    //The album is identified by its location in the array
    Album *album = self.albums[indexPath.row];
    //The memory is the most recently added memory in the array
    UIImageView *blurImageView;
    
    if(album.memories.count != 0){
        //If there are memories, then the album has the view of the last memory photo
        Memory *memory = album.memories.lastObject;
        cell.dateLabel.text = memory.dateTaken;
        cell.backgroundView = [[UIImageView alloc]initWithImage:memory.photo];
        cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        blurImageView = [[UIImageView alloc]initWithImage:memory.photo];
    }else{
        //If there are no memories, then the album has a place holder image.
        cell.dateLabel.text = @"NO DATE";
        cell.backgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CellPlaceholder"]];
        cell.backgroundView.contentMode = UIViewContentModeScaleAspectFill;
        blurImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CellPlaceholder"]];
    }
    
    cell.backgroundView.clipsToBounds = YES;
    //When one of the albums is selected, the view changes to blurred
    blurImageView.contentMode = UIViewContentModeScaleAspectFill;
    blurImageView.clipsToBounds = YES;
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc]initWithEffect: [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular]];
        
    visualEffectView.frame = blurImageView.bounds;
    [blurImageView addSubview:visualEffectView];
        
    cell.selectedBackgroundView =blurImageView;
        
    
    
    //The cell title label is the name of the album
    cell.titleLabel.text = album.albumName;
    
   
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    bool canEdit;
    //The table view is only editable when the edit mode is triggered and it is not the first album.
    if (self.isEditable){
        if (indexPath.row == 0){
            canEdit = NO;
        }else{
            canEdit = YES;
        }
    }else{
        canEdit = NO;
    }
    return canEdit;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete){
        [self.albumTableViewDelegate didDeleteAlbumAtPath:indexPath];
        
    }
}

//MARK: - Data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //This function deals with when a table's row has been picked
    if (!self.isEditable){
        [self.albumTableViewDelegate didSelectAlbumAtPath:indexPath];
    }
    
}

//This function returns the number of sections in the view, there is only one section in this one
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//This function determine the number of rows/cells in the table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.albums.count;
}
//This sets the height of each cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.screenSize.height*0.3345;;
}



@end
