//
//  AlbumTableViewCell.h
//  Memories
//
//  Created by William Burr on 01/03/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlbumTableViewCell : UITableViewCell

@property (assign, nonatomic)CGSize screenSize;
@property (strong, nonatomic)UILabel* titleLabel;
@property (strong, nonatomic)UILabel* dateLabel;


@end
