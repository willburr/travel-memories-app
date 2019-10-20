//
//  OptionsVC.h
//  Memories
//
//  Created by William Burr on 06/03/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMViewController.h"
#import "Album.h"
#import "pinPoint.h"

@protocol OptionsVCDelegate <NSObject>

-(void)updatePhotoMapWithChosenAlbum: (Album*)album orYear: (NSString*) year;
-(void)updatePinMapWithChosenYear: (NSString*) year;
@end


typedef enum {Photo,Pin} TMMapType ;

@interface OptionsVC : UIViewController 

@property (strong, nonatomic)TMHeaderView* headerView;

@property (assign, nonatomic)TMMapType mapType;
@property (strong, nonatomic)id <OptionsVCDelegate> delegate;

@property (strong, nonatomic)UIScrollView* albumScrollView;
@property (strong, nonatomic)UIScrollView* yearScrollView;

@property (assign, nonatomic) CGSize screenSize;

@property (strong, nonatomic)UISegmentedControl* albumSegmentedControl;
@property (strong, nonatomic)UISegmentedControl* yearSegmentedControl;

@property (strong, nonatomic)UILabel* albumLabel;
@property (strong, nonatomic)UILabel* yearLabel;
@property (strong, nonatomic)UILabel* infoLabel;

@property (strong, nonatomic)NSArray* albums;
@property (strong, nonatomic)NSArray* pinPoints;
@property (strong, nonatomic)NSMutableArray* years;

@property (assign, nonatomic)Album* selectedAlbum;
@property (assign, nonatomic)NSString* selectedYear;

-(instancetype)initWithSelectedGroup: (Album*)album orYear: (NSString*)year andAlbums:(NSArray*)albums;
-(instancetype)initWithSelectedPinYear: (NSString*)year andPinPoints:(NSArray*) pinPoints;

@end
