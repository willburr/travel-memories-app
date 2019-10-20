//
//  StartVC.h
//  Memories
//
//  Created by User on 12/02/2017.
//  Copyright © 2017 User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "StartView.h"
#import "MemoryCreatorView.h"
#import "TMHeaderView.h"
#import <Photos/Photos.h>

@protocol StartVCDelegate <NSObject>

-(void)albumsUpdateFromStartVC;
-(void)disableSuperScroll;
-(void)enableSuperScroll;

@end

@interface StartVC : TMViewController <UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AlbumSelectorVCDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) StartView *startView;
@property (nonatomic, strong) MemoryCreatorView *memoryCreatorView;
@property (strong, nonatomic)id <StartVCDelegate> delegate;
@property (strong, nonatomic)NSMutableArray* albums;
@property (assign, nonatomic)NSInteger selectedAlbumIndex;
@property (strong, nonatomic)NSDateFormatter* dateFormatter;
@property (strong, nonatomic)CLLocationManager* locationManager;

-(void)updateData;

@end
