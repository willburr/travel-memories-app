//
//  MemoryCreatorView.h
//  Memories
//
//  Created by User on 13/02/2017.
//  Copyright © 2017 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memory.h"
#import "Album.h"
#import "AlbumSelectorVC.h"

@interface MemoryCreatorView : UIView <UITextViewDelegate, UIGestureRecognizerDelegate>

@property (assign, nonatomic) CGSize screenSize;
@property (strong, nonatomic) UIImageView* imageView;
@property (strong, nonatomic) UITextView* captionTextView;
@property (strong, nonatomic) UIButton* postButton;

@property (strong, nonatomic) UIButton* colourButton;
@property (strong, nonatomic) UIButton* albumButton;

@property (strong, nonatomic) Memory* memory;

@property (assign, nonatomic) NSLayoutConstraint *captionYConstraint;
@property (assign, nonatomic) CGFloat captionYConstraintValue;
@property (assign, nonatomic) NSLayoutConstraint *imageHConstraint;
@property (assign, nonatomic) NSLayoutConstraint *imageVConstraint;
@property (assign, nonatomic) CGFloat imageConstant;



-(void)commonInit;

@end
