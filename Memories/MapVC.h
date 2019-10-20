//
//  MapVC.h
//  Memories
//
//  Created by William Burr on 22/02/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMViewController.h"
#import "Memory.h"
#import "Album.h"
#import "PinPoint.h"
#import "OptionsVC.h"
#import "HalfSizePresentationController.h"
#import "AlbumSelectorVC.h"
@import MapKit;

@import Mapbox;

@protocol MapVCDelegate <NSObject>

-(void)albumsUpdateFromMapVC;

@end



@interface MapVC : TMViewController <MGLMapViewDelegate,UIScrollViewDelegate, UIGestureRecognizerDelegate, OptionsVCDelegate, UIViewControllerTransitioningDelegate, AlbumSelectorVCDelegate>

@property (strong, nonatomic)MGLMapView* mapView;
@property (strong, nonatomic)UISegmentedControl* mapSelector;
@property (strong, nonatomic)UIButton* optionsButton;

@property (assign, nonatomic)TMMapType mapType;

@property (strong, nonatomic)NSMutableArray* albums;
@property (strong, nonatomic)NSMutableArray* memories;
@property (strong, nonatomic)NSMutableArray* pinPoints;

@property (assign, nonatomic)int memoryIndex;

@property (strong, nonatomic)Album* selectedAlbum;
@property (strong, nonatomic)NSString* selectedPhotoYear;
@property (strong, nonatomic)NSString* selectedPinYear;
@property (strong, nonatomic)Memory* selectedMemory;

@property (strong, nonatomic)id <MapVCDelegate> delegate;

@property (strong, nonatomic)UIGestureRecognizer* touchRecognizer;
@property (strong, nonatomic)UIButton* pinButton;
@property (strong, nonatomic)UIButton* undoButton;

@property (strong, nonatomic)NSDateFormatter* dateFormatter;

-(void)updateData;
-(void)updatePhotoMapWithChosenAlbum: (Album*)album orYear: (NSString*) year;

@end
