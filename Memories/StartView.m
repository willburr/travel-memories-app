//  StartView.m
//  Memories
//
//  Created by William Burr on 13/02/2017.
//  Copyright © 2017 William Burr. All rights reserved.


#import "StartView.h"


@implementation StartView


//MARK: - Initialisation

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.screenSize = [[UIScreen mainScreen]bounds].size;
    [self setUpItems];
    
}

//MARK: - Items

//MARK: Set up

-(void)setUpItems {
    //The info label is set up prompting the user.
    self.infoLabel = [[UILabel alloc] init];
    self.infoLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.infoLabel.text = @"Make a new Memory";
    self.infoLabel.textColor = [UIColor blackColor];
    self.infoLabel.font = [UIFont fontWithName:@"Noteworthy" size:self.screenSize.width*0.09375];
    self.infoLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.infoLabel];
    //This label provides the user with more information.
    self.subInfoLabel = [[UILabel alloc] init];
    self.subInfoLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.subInfoLabel.text = @"(Choose from Camera or Album)";
    self.subInfoLabel.textColor = [UIColor blackColor];
    self.subInfoLabel.font = [UIFont fontWithName:@"Noteworthy" size:self.screenSize.width*0.046875];
    self.subInfoLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.subInfoLabel];
    
    //The photo button is set up.
    self.photoButton = [[UIButton alloc] init];
    self.photoButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.photoButton setImage: [UIImage imageNamed:@"Album"] forState: normal];
    self.photoButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    self.photoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    
    [self addSubview:self.photoButton];
    
    //The camera button is set up.
    self.cameraButton = [[UIButton alloc] init];
    self.cameraButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.cameraButton setImage: [UIImage imageNamed:@"Camera"] forState: normal];
    self.cameraButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    self.cameraButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    [self addSubview:self.cameraButton];
    
    [self layoutItems];

    
}

//MARK: Layout 

-(void) layoutItems {
    
    NSDictionary *views = @{@"infoLabel": self.infoLabel, @"subInfoLabel": self.subInfoLabel, @"photoButton": self.photoButton, @"cameraButton": self.cameraButton};
    
    NSDictionary *metrics = @{@"buttonWidth":@(self.screenSize.height*0.2025)};
    
    //Photo Button - positioned on the right, centre Y
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[photoButton(buttonWidth)]" options: 0 metrics:metrics views:views]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:[photoButton(buttonWidth)]" options: 0 metrics:metrics views:views]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.photoButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.photoButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:self.screenSize.height*0.035]];

    
    //Camera Button - positioned on the left, centre Y
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[cameraButton(buttonWidth)]" options: 0 metrics:metrics views:views]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:[cameraButton(buttonWidth)]" options: 0 metrics:metrics views:views]];
    
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.cameraButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:-self.screenSize.height*0.035]];
    
    //Info Label - positioned in the centre X, above the buttons
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.infoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.infoLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeCenterY multiplier:1 constant:-self.screenSize.height*0.264]];
    
    //Sub Info Label - positioned in the centre X, below info label
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.subInfoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem: self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem: self.subInfoLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem: self.infoLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
    
    
    
    [self layoutIfNeeded];
    
}


@end
