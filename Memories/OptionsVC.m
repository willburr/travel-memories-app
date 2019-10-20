//
//  OptionsVC.m
//  Memories
//
//  Created by William Burr on 06/03/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import "OptionsVC.h"

@interface OptionsVC ()

@end

@implementation OptionsVC

//MARK - Initialisation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//MARK: For Photo Map
-(instancetype)initWithSelectedGroup: (Album*)album orYear: (NSString*)year andAlbums:(NSArray*)albums{
    self = [super init];
    self.screenSize = [[UIScreen mainScreen]bounds].size;
    self.mapType = Photo;
    self.albums = albums;
    //The selected album/years are established.
    if (album!=nil){
        self.selectedAlbum = album;
    }else if (year != nil){
        self.selectedYear = year;
    }
    [self setUpHeaderView];
    self.headerView.titleLabel.text = @"Photo Map Options";
    //The photo map options are set up.
    [self setUpPhotoMapOptions];
    
    return self;
}

//MARK: For Pin Map
-(instancetype)initWithSelectedPinYear:(NSString *)year andPinPoints:(NSArray *)pinPoints{
    self = [super init];
    self.screenSize = [[UIScreen mainScreen]bounds].size;
    self.mapType = Pin;
    self.pinPoints = pinPoints;
     //The selected year is established.
    if (year!= nil){
        self.selectedYear = year;
    }
    [self setUpHeaderView];
    self.headerView.titleLabel.text = @"Pin Map Options";
    //The pin map options are set up.
    [self setUpPinMapOptions];
    return self;
}

//MARK: - Header View
//MARK: Set up
-(void)setUpHeaderView{
    //The header view is created, similarly to the TMViewController.
    self.headerView = [[TMHeaderView alloc]initWithFrame:CGRectZero navStyle:Close];
    self.view.backgroundColor = [UIColor colorWithRed:0.99 green:0.99 blue:0.99 alpha:1];
    self.headerView.translatesAutoresizingMaskIntoConstraints = false;
    [self.headerView setNavigationAction:@selector(closeAction) withSender:self];
    self.headerView.titleLabel.font = [UIFont fontWithName:@"Marker Felt" size:20];
    [self.view addSubview:self.headerView];
    [self layoutHeaderView];
    
    [self.headerView setUpDoneButton];
    [self.headerView setDoneAction:@selector(doneAction) withSender:self];
}

//MARK: Layout
-(void)layoutHeaderView{
    //The header view is positioned at the top of the view controller.
    NSDictionary *views = @{@"headerView": self.headerView};
    NSDictionary *metrics = @{@"headerHeight": @(self.screenSize.height*0.105)};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerView(headerHeight)]" options:0 metrics:metrics views:views]];
    
    [self.view layoutIfNeeded];
}

//MARK: - Photo Map Options
//MARK: Set up
-(void)setUpPhotoMapOptions{
    
    //These labels indicate to the user what they are selecting.
    self.albumLabel = [[UILabel alloc]init];
    self.albumLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.albumLabel.backgroundColor = [UIColor clearColor];
    self.albumLabel.text = @"Pick Album: ";
    self.albumLabel.font = [UIFont fontWithName:@"Noteworthy" size:self.screenSize.width*0.047];
    self.albumLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.albumLabel];
    
    self.yearLabel = [[UILabel alloc]init];
    self.yearLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.yearLabel.backgroundColor = [UIColor clearColor];
    self.yearLabel.text = @"Pick Year: ";
    self.yearLabel.font = [UIFont fontWithName:@"Noteworthy" size:self.screenSize.width*0.047];
    self.yearLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.yearLabel];
    
    //Here I create an array of album names, since album objects cannot be passed into the segmented control
    
    NSMutableArray *albumNames = [[NSMutableArray alloc]init];
    
    //This is used to loop through each album and add the album name to the album names array
    for (int i=0; i<self.albums.count; i++) {
        Album *album = self.albums[i];
        [albumNames addObject:album.albumName];
        album = nil;
    }
    
    //The scroll view allows for more albums to fully appear in the segmented control.
    self.albumScrollView = [[UIScrollView alloc]init];
    self.albumScrollView.translatesAutoresizingMaskIntoConstraints = false;
    self.albumScrollView.backgroundColor = [UIColor clearColor];
    self.albumScrollView.layer.cornerRadius = 3;
    self.albumScrollView.scrollEnabled = true;
    self.albumScrollView.pagingEnabled = false;
    self.albumScrollView.bounces = false;
    self.albumScrollView.showsVerticalScrollIndicator = false;
    self.albumScrollView.showsHorizontalScrollIndicator = false;
    self.albumScrollView.userInteractionEnabled = true;
    self.albumScrollView.contentSize = CGSizeMake(albumNames.count*self.screenSize.width*0.25, self.screenSize.height*0.0704);
    
    [self.view addSubview:self.albumScrollView];
    
    
    //The array of album names that has been created is now used to initialise the segmented control
    
    self.albumSegmentedControl = [[UISegmentedControl alloc]initWithItems:albumNames];
    self.albumSegmentedControl.backgroundColor = [UIColor whiteColor];
    self.albumSegmentedControl.translatesAutoresizingMaskIntoConstraints = false;
    
    //The target is set to the segmentedControlValueDidChange function
    [self.albumSegmentedControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    //If there is a valid selected album, then the respective button is highlighted on the segmented view
    
    if (self.selectedAlbum != nil){
        NSInteger index = [self.albums indexOfObject:self.selectedAlbum];
        [self.albumSegmentedControl setSelectedSegmentIndex:index];
    }
    
    [self.albumScrollView addSubview:self.albumSegmentedControl];
    
    //The list of available years is established.
    NSArray *memories = [self.albums.firstObject memories];
    self.years = [[NSMutableArray alloc]init];
    //This loops through all the memories and identifies the years.
    for (int i = 0; i<memories.count; i++) {
        NSString *dateTaken = [memories[i] dateTaken];
        NSString *year = [dateTaken substringFromIndex:dateTaken.length - 4 ];
        if (![self.years containsObject:year]){
            [self.years addObject:year];
        }
        dateTaken = nil;
        year = nil;
    }
    
    //The scroll view allows for more years to be shown by the segmented control.
    self.yearScrollView = [[UIScrollView alloc]init];
    self.yearScrollView.translatesAutoresizingMaskIntoConstraints = false;
    self.yearScrollView.backgroundColor = [UIColor clearColor];
    self.yearScrollView.layer.cornerRadius = 3;
    self.yearScrollView.scrollEnabled = true;
    self.yearScrollView.pagingEnabled = false;
    self.yearScrollView.bounces = false;
    self.yearScrollView.showsVerticalScrollIndicator = false;
    self.yearScrollView.showsHorizontalScrollIndicator = false;
    self.yearScrollView.userInteractionEnabled = true;
    self.yearScrollView.contentSize = CGSizeMake(self.years.count*self.screenSize.width*0.25, self.screenSize.height*0.0704);
    [self.view addSubview:self.yearScrollView];
    
    self.yearSegmentedControl = [[UISegmentedControl alloc]initWithItems:self.years];
    self.yearSegmentedControl.translatesAutoresizingMaskIntoConstraints = false;
    self.yearSegmentedControl.backgroundColor = [UIColor whiteColor];
    for (NSUInteger i = 0; i<self.years.count; i++) {
        [self.yearSegmentedControl setWidth:self.screenSize.width*0.25 forSegmentAtIndex:i];
    }
    
    [self.yearSegmentedControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    
    //If there is a selected year, then the index on the year segmented control is selected.
    if (self.selectedYear != nil){
        NSInteger index = [self.years indexOfObject:self.selectedYear];
        [self.yearSegmentedControl setSelectedSegmentIndex:index];
    }
    
    [self.yearScrollView addSubview:self.yearSegmentedControl];
    
    if(self.years.count == 0){
        [self.yearLabel setAlpha:0];
        [self.yearScrollView setAlpha:0];
        [self.yearSegmentedControl setAlpha:0];
    }
    
    [self layoutPhotoMapOptions];
    
    
}
//MARK: Layout
-(void)layoutPhotoMapOptions{
    NSDictionary *views = @{@"albumSegmentedControl":self.albumSegmentedControl, @"yearSegmentedControl":self.yearSegmentedControl, @"albumLabel":self.albumLabel, @"yearLabel":self.yearLabel, @"albumScrollView":self.albumScrollView, @"yearScrollView":self.yearScrollView};
    NSDictionary *metrics = @{@"topGap":@(self.screenSize.height*0.141),@"labelHeight":@(self.screenSize.height*0.035), @"scrollViewHeight":@(self.screenSize.height*0.072),@"labelWidth":@(self.screenSize.width*0.3125), @"segmentedControlHeight":@(self.screenSize.height*0.0704)};
    //In the constraint below, the vertical structure of the options VC is dictated.
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topGap)-[albumLabel(labelHeight)]-10-[albumScrollView(scrollViewHeight)]-(labelHeight)-[yearLabel(labelHeight)]-10-[yearScrollView(scrollViewHeight)]" options:0 metrics:metrics views:views]];
    //The album scroll view fills horizontally with edges of 10 on either side
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[albumScrollView]-10-|" options:0 metrics:nil views:views]];
    //The album segmented control fills the scroll view horizontally.
    [self.albumScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[albumSegmentedControl]|" options:0 metrics:nil views:views]];
    //The album segmented control fills the scroll view vertically with a slighly smaller height.
    [self.albumScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[albumSegmentedControl(segmentedControlHeight)]|" options:0 metrics:metrics views:views]];
    //The year scroll view fills horizontally with edges of 10 on either side
     [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[yearScrollView]-10-|" options:0 metrics:nil views:views]];
    //The year segmented control fills the scroll view horizontally
    [self.yearScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[yearSegmentedControl]|" options:0 metrics:nil views:views]];
    //The year segmented control fills the scroll view vertically with a slightly smaller height
    [self.yearScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[yearSegmentedControl(segmentedControlHeight)]|" options:0 metrics:metrics views:views]];
    //The album label is positioned with a gap from the left edge.
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(labelHeight)-[albumLabel(labelWidth)]" options:0 metrics:metrics views:views]];
    //The year label is positioned with a gap from the left edge.
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(labelHeight)-[yearLabel(labelWidth)]" options:0 metrics:metrics views:views]];
    [self.view layoutIfNeeded];
}

//MARK: - Pin Map Options
//MARK: Set up
-(void)setUpPinMapOptions{
    //This label indicates to the user what they are doing.
    self.yearLabel = [[UILabel alloc]init];
    self.yearLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.yearLabel.backgroundColor = [UIColor clearColor];
    self.yearLabel.text = @"Pick Year: ";
    self.yearLabel.font = [UIFont fontWithName:@"Noteworthy" size:self.screenSize.width*0.047];
    self.yearLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.yearLabel];
    
    //This identifies all the available years using the pin points.
    self.years = [[NSMutableArray alloc]init];
    [self.years addObject:@"All"];
    //This loops through each pin point and appends any new years that appear.
    for (int i=0; i<self.pinPoints.count; i++) {
        PinPoint *pinPoint = self.pinPoints[i];
        if (![self.years containsObject:pinPoint.year]){
            [self.years addObject:pinPoint.year];
        }
    }
    
    self.yearScrollView = [[UIScrollView alloc]init];
    self.yearScrollView.translatesAutoresizingMaskIntoConstraints = false;
    self.yearScrollView.backgroundColor = [UIColor clearColor];
    self.yearScrollView.layer.cornerRadius = 3;
    self.yearScrollView.scrollEnabled = true;
    self.yearScrollView.pagingEnabled = false;
    self.yearScrollView.bounces = false;
    self.yearScrollView.showsVerticalScrollIndicator = false;
    self.yearScrollView.showsHorizontalScrollIndicator = false;
    self.yearScrollView.userInteractionEnabled = true;
    self.yearScrollView.contentSize = CGSizeMake(self.years.count*self.screenSize.width*0.25, self.screenSize.height*0.0704);
    [self.view addSubview:self.yearScrollView];
    
    self.yearSegmentedControl = [[UISegmentedControl alloc]initWithItems:self.years];
    self.yearSegmentedControl.translatesAutoresizingMaskIntoConstraints = false;
    self.yearSegmentedControl.backgroundColor = [UIColor whiteColor];
    [self.yearSegmentedControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    NSInteger index = [self.years indexOfObject:self.selectedYear];
    [self.yearSegmentedControl setSelectedSegmentIndex:index];
    for (NSUInteger i = 0; i<self.years.count; i++) {
        [self.yearSegmentedControl setWidth:self.screenSize.width*0.25 forSegmentAtIndex:i];
    }
    [self.yearScrollView addSubview:self.yearSegmentedControl];
    
    self.infoLabel = [[UILabel alloc]init];
    self.infoLabel.text = @"NOTE: Select 'All' for adding and removing points";
    self.infoLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.infoLabel.font = [UIFont fontWithName:@"Noteworthy" size:self.screenSize.width*0.05];
    self.infoLabel.textColor = [UIColor blackColor];
    [self.view addSubview:self.infoLabel];
    [self layoutPinMapOptions];
    
}
//MARK: Layout
-(void)layoutPinMapOptions{
    NSDictionary *views = @{@"yearSegmentedControl":self.yearSegmentedControl, @"yearLabel":self.yearLabel, @"infoLabel":self.infoLabel, @"yearScrollView":self.yearScrollView};
    NSDictionary *metrics = @{@"topGap":@(self.screenSize.height*0.141),@"labelHeight":@(self.screenSize.height*0.035), @"scrollViewHeight":@(self.screenSize.height*0.072),@"labelWidth":@(self.screenSize.width*0.3125), @"segmentedControlHeight":@(self.screenSize.height*0.0704), @"infoHeight":@(self.screenSize.height*0.044)};
    //The vertical structure of the options are set.
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(topGap)-[yearLabel(labelHeight)]-10-[yearScrollView(scrollViewHeight)]-30-[infoLabel(25)]" options:0 metrics:metrics views:views]];
    //The year scroll view fills horizontally with a gap either side.
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[yearScrollView]-10-|" options:0 metrics:nil views:views]];
    //The year segmented control fills the scroll view horizontally and vertically.
    [self.yearScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[yearSegmentedControl]|" options:0 metrics:nil views:views]];
    [self.yearScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[yearSegmentedControl(segmentedControlHeight)]|" options:0 metrics:metrics views:views]];
    //The year label is positioned with a gap from the left edge.
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(labelHeight)-[yearLabel(labelWidth)]" options:0 metrics:metrics views:views]];
    //The info label is positioned in the centre X.
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
}

//MARK: - Button Press
//MARK: Segmented Control
-(void)segmentedControlValueDidChange: (UISegmentedControl*)segmentedControl{
    //The first task of the function is to identify which segmented control's value has changed
    if(segmentedControl == self.albumSegmentedControl){
        //If the selected album has changed, then the selected year is nil.
        self.selectedAlbum = self.albums[self.albumSegmentedControl.selectedSegmentIndex];
        self.selectedYear = nil;
        [self.yearSegmentedControl setSelectedSegmentIndex:-1];
    }else if (segmentedControl == self.yearSegmentedControl){
        //If the selected year has changed, then (providing its photo map options)the selected album is nil.
        self.selectedYear = self.years[self.yearSegmentedControl.selectedSegmentIndex];
        if(self.albumSegmentedControl != nil){
            self.selectedAlbum = nil;
            [self.albumSegmentedControl setSelectedSegmentIndex:-1];
        }
    }
}
//MARK: Close Button
-(void)closeAction{
    [self dismissViewControllerAnimated:true completion:nil];
}

//MARK: Done Button
-(void)doneAction{
    //The delegate function called depends on the type of options that are being displayed.
    if (self.mapType == Photo){
        //Either parameter can be nil, but one will be a valid value used by the target function.
        [self.delegate updatePhotoMapWithChosenAlbum:self.selectedAlbum orYear:self.selectedYear];
    }else{
        //The selected year is passed into the Map VC's delegate function.
        [self.delegate updatePinMapWithChosenYear:self.selectedYear];
    }
    [self dismissViewControllerAnimated:true completion:nil];
}


@end
