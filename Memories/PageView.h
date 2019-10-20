//
//  PageView.h
//  Memories
//
//  Created by William Burr on 03/03/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Memory.h"

@protocol PageViewDelegate <NSObject>

-(void)memoryCaptionWasChanged:(Memory*)memory andCaption: (NSString*)caption;

@end

@import Mapbox;

@interface PageView : UIView <UITextViewDelegate, UIGestureRecognizerDelegate>

@property (assign, nonatomic)Memory* memory;

@property (assign, nonatomic)CGSize screenSize;
@property (strong, nonatomic)UIImageView* imageView;
@property (strong, nonatomic)UITextView* captionTextView;
@property (strong, nonatomic)UILabel* dateLabel;

@property (assign, nonatomic) NSLayoutConstraint *captionYConstraint;
@property (assign, nonatomic) CGFloat captionYConstraintValue;
@property (assign, nonatomic) NSLayoutConstraint *imageHConstraint;
@property (assign, nonatomic) NSLayoutConstraint *imageVConstraint;
@property (assign, nonatomic) NSLayoutConstraint *imageCenterXConstraint;

@property (strong, nonatomic)MGLMapView* mapView;
@property (assign, nonatomic) NSLayoutConstraint* mapYConstraint;
@property (strong, nonatomic)id<PageViewDelegate> delegate;



-(instancetype)initWithMemory: (Memory*) memory;



@end
