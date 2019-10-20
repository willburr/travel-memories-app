//
//  AlbumTableViewCell.m
//  Memories
//
//  Created by William Burr on 01/03/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import "AlbumTableViewCell.h"

@implementation AlbumTableViewCell

//MARK: - Initialisation

- (void)awakeFromNib {
    [self setUpAppearance];
    self.screenSize = [[UIScreen mainScreen]bounds].size;
    [self setUpLabels];
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//MARK: Appearance
-(void)setUpAppearance {
    self.backgroundColor = [UIColor clearColor];
   
}
//MARK: Set up
-(void)setUpLabels{
    //A title label and the date label are created.
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont fontWithName:@"Noteworthy" size:25];
    [self addSubview:self.titleLabel];
    
    self.dateLabel = [[UILabel alloc]init];
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.dateLabel.textColor = [UIColor whiteColor];
    self.dateLabel.font = [UIFont fontWithName:@"Noteworthy" size:10];
    [self addSubview:self.dateLabel];
    
    [self layoutLabels];
}
//MARK: Layout
-(void)layoutLabels{
    //The title label is positioned in the centre co-ordinate of the cell, the date label is positioned on the bottom right.
    NSDictionary *views = @{@"titleLabel":self.titleLabel, @"dateLabel": self.dateLabel};
    NSDictionary *metrics = @{@"titleHeight":@(self.screenSize.height*0.08), @"dateHeight":@(self.screenSize.height*0.053)};
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[titleLabel(titleHeight)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel(dateHeight)]-4-|" options:0 metrics:metrics views:views]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.dateLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:-5]];
    
    [self layoutIfNeeded];
    
}

@end
