//
//  TMHeaderView.m
//  Memories
//
//  Created by William Burr on 14/02/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import "TMHeaderView.h"


@implementation TMHeaderView

//MARK: - Initialisation

-(instancetype)initWithFrame:(CGRect)frame navStyle: (TMHeaderStyle) headerStyle {
    self = [super initWithFrame: frame];
    self.navStyle = &(headerStyle);
    self.screenSize = [[UIScreen mainScreen]bounds].size;
    [self commonInit];
    return self;
}

-(void) commonInit{
    self.navigationBtnWidth = self.screenSize.height*0.0605;
    self.backgroundColor = [UIColor whiteColor];
    [self setUpTitleLabel];
    [self setUpNavigationBtn];

    
}

//MARK:- Title Label
//MARK: Set up

-(void) setUpTitleLabel {
    //Sets up the title Label
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.titleLabel.font = [UIFont fontWithName: @"Marker Felt" size:self.screenSize.height*0.044];
    self.titleLabel.textColor = [UIColor blackColor];
    self.titleLabel.shadowOffset = CGSizeMake(3.0, 3.0);
    
    [self addSubview:self.titleLabel];
    
    [self layoutTitleLabel];
    
}


-(void) setTitleText: (NSString*) text {
    self.titleLabel.text = text;
}

//MARK: Layout

-(void) layoutTitleLabel {
    //Title label positoned in centre X and below the centre Y
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:self.screenSize.height*0.01]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self layoutIfNeeded];
    
}

//MARK: - Navigation Button
//MARK: Set up

-(void) setUpNavigationBtn {
    //Navigation button is set up.
    self.navigationBtn = [[UIButton alloc] init];
    self.navigationBtn.translatesAutoresizingMaskIntoConstraints = false;
    self.navigationBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    [self addSubview:self.navigationBtn];
    
    [self styleNavigationBtn];
}

//MARK: Style

-(void) styleNavigationBtn {
    
    TMHeaderStyle styling = *(self.navStyle);
    //Depending on the style chosen, the navigation button will have different images and alpha.
    if (styling == None){
            [self.navigationBtn setAlpha:0];
    } else if (styling == Back) {
            [self.navigationBtn setImage:[UIImage imageNamed:@"Back"] forState:normal];
            [self.navigationBtn setAlpha:1];
    } else if (styling == Close){
        [self.navigationBtn setImage:[UIImage imageNamed:@"Cancel"] forState:normal];
        [self.navigationBtn setAlpha:1];
    } else if (styling == Add){
        [self.navigationBtn setImage:[UIImage imageNamed:@"Add"] forState:normal];
        [self.navigationBtn setAlpha:1];
    }
    
    
    [self layoutNavigationBtn];
    
}

//MARK: Layout

-(void) layoutNavigationBtn {
    NSDictionary *views = @{@"navigationBtn": self.navigationBtn};
    NSDictionary *metrics = @{@"navigationBtnWidth": @(self.navigationBtnWidth)};
    
    //Navigation button always appears in the left of the header view, in line with the title label.
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.navigationBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[navigationBtn(navigationBtnWidth)]" options:0 metrics:metrics views:views]];
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[navigationBtn(navigationBtnWidth)]" options:NSLayoutFormatAlignAllCenterX metrics:metrics views:views]];
    
    [self layoutIfNeeded];
    
}

//MARK: - Edit Button
//MARK: Set up

-(void)setUpEditButton{
    //Edit button is set up.
    self.editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.editBtn.translatesAutoresizingMaskIntoConstraints = false;
    self.editBtn.backgroundColor = [UIColor clearColor];
    [self.editBtn setTitle:@"Edit" forState:UIControlStateNormal];
    [self addSubview:self.editBtn];
    [self layoutEditButton];
    
}

//MARK: Layout
-(void)layoutEditButton{
    NSDictionary *views = @{@"editButton":self.editBtn};
    NSDictionary *metrics = @{@"editBtnWidth":@(self.screenSize.width*0.125), @"editBtnHeight":@(self.screenSize.height*0.053), @"gap":@(self.screenSize.height*0.0176)};
    //The edit button is positioned from the right edge in line with the title label.
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[editButton(editBtnWidth)]-(gap)-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[editButton(editBtnHeight)]" options:0 metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.editBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self layoutIfNeeded];
    
}

//MARK: - Done Button
//MARK: Set up

-(void)setUpDoneButton{
    //Done button is set up.
    self.doneBtn = [[UIButton alloc]init];
    self.doneBtn.translatesAutoresizingMaskIntoConstraints = false;
    [self.doneBtn setImage:[UIImage imageNamed:@"Tick"] forState:UIControlStateNormal];
    self.doneBtn.imageEdgeInsets = UIEdgeInsetsMake(7, 7, 7, 7);
    [self addSubview:self.doneBtn];
    
    [self layoutDoneButton];
}
//MARK: Layout

-(void)layoutDoneButton{
    NSDictionary *views = @{@"doneButton":self.doneBtn};
    NSDictionary *metrics = @{@"btnWidth":@(self.navigationBtnWidth)};
    //Done button is positioned from the right edge of the header view.
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[doneButton(btnWidth)]-5-|" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[doneButton(btnWidth)]" options:0 metrics:metrics views:views]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.doneBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.titleLabel attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self layoutIfNeeded];
}

//MARK: - Actions

-(void)setEditAction: (SEL)action withSender: (id)sender{
    
    [self.editBtn addTarget:sender action:action forControlEvents:UIControlEventTouchUpInside];
    
}



-(void)setNavigationAction: (SEL) action withSender: (id) sender {
    
    [self.navigationBtn removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [self.navigationBtn addTarget:sender action:action forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setDoneAction: (SEL) action withSender: (id)sender{
    [self.doneBtn addTarget:sender action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
