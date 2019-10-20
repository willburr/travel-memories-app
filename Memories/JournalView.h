//
//  JournalView.h
//  Memories
//
//  Created by William Burr on 03/03/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageView.h"

@protocol JournalViewDelegate <NSObject>

-(void)memoryCaptionWasChanged:(Memory*)memory andCaption: (NSString*)caption;

@end

@interface JournalView : UIView <UIScrollViewDelegate, PageViewDelegate>

@property (strong, nonatomic)UILabel* infoLabel;
@property (strong, nonatomic)UIScrollView* pageScrollView;
@property (strong, nonatomic)NSMutableArray* pageViews;
@property (strong, nonatomic)NSMutableArray* memories;
@property (strong, nonatomic)id<JournalViewDelegate> delegate;


-(void)commonInit: (NSMutableArray*)memories;

@end
