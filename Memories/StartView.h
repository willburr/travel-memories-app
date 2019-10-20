//
//  StartView.h
//  Memories
//
//  Created by User on 13/02/2017.
//  Copyright © 2017 User. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface StartView : UIView
@property (assign, nonatomic) CGSize screenSize;
@property (strong, nonatomic) UIButton *photoButton;
@property (strong, nonatomic) UIButton *cameraButton;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UILabel *subInfoLabel;


-(void) commonInit;
-(void) setUpItems;
-(void) layoutItems;


@end




