//
//  TMHeaderView.h
//  Memories
//
//  Created by William Burr on 14/02/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {None, Back, Close, Add} TMHeaderStyle;


@interface TMHeaderView : UIView

@property (assign, nonatomic) TMHeaderStyle *navStyle;
@property (assign, nonatomic) CGSize screenSize;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIButton *navigationBtn;
@property (assign, nonatomic) float navigationBtnWidth;
@property (strong, nonatomic) UIButton *doneBtn;
@property (strong, nonatomic) UIButton *editBtn;

-(void)commonInit;
-(void)setNavigationAction: (SEL) action withSender: (id) sender;
-(void)setUpEditButton;
-(void)setUpDoneButton;
-(void)setEditAction: (SEL)action withSender: (id)sender;
-(void)setDoneAction: (SEL) action withSender: (id)sender;
-(instancetype)initWithFrame:(CGRect)frame navStyle: (TMHeaderStyle) headerStyle;
-(void) setTitleText: (NSString*) text;
-(void) styleNavigationBtn;
@end
