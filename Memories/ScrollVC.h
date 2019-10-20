//
//  ScrollVC.h
//  Memories
//
//  Created by William Burr on 21/02/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapVC.h"
#import "AlbumVC.h"
#import "StartVC.h"

@interface ScrollVC : UIViewController <UIScrollViewDelegate, StartVCDelegate, AlbumVCDelegate, MapVCDelegate>

@property (assign, nonatomic) CGSize screenSize;

@property (strong, nonatomic) UIScrollView* scrollView;
@property (strong, nonatomic) MapVC* mapVC;
@property (strong, nonatomic) AlbumVC* albumVC;
@property (strong, nonatomic) StartVC* startVC;

@property (strong, nonatomic) UIAlertController* memoryWarningAC;

@property (strong, nonatomic)UIView* footerView;
@property (strong, nonatomic)UIButton* mapButton;
@property (strong, nonatomic)UIButton* albumButton;
@property (strong, nonatomic)UIButton* startButton;
@property (strong, nonatomic)UIView* scrollBar;
@property (strong, nonatomic)NSLayoutConstraint* scrollBarConstraint;

@end
