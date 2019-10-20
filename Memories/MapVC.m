//
//  MapVC.m
//  Memories
//
//  Created by William Burr on 22/02/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import "MapVC.h"


@interface MapVC ()

@end

@implementation MapVC

@synthesize delegate;
//MARK: - Initialisation

-(instancetype)init{
    self = [super initWithNibName:@"MapVC" bundle: [NSBundle mainBundle] headerNav:None] ;
    [self setCustomHeaderTitle:@"Maps"];
    //The edit button here is used for adding Memories to albums and deleting them.
    [self.headerView setUpEditButton];
    [self setEditBtnAction];
    //The date formatter is used for the selected year.
    self.dateFormatter = [[NSDateFormatter alloc]init];
    self.dateFormatter.dateFormat = @"yyyy";
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //When the view loads, everything is set up.
    //If there are no albums, then one is created
    if ([self loadAlbums] != nil){
        self.albums = [self loadAlbums];
    } else{
        self.albums = [[NSMutableArray alloc]init];
        [self.albums addObject:[[Album alloc]init:@"All Memories"]];
    }
    //The selected album by default is the 'All Memories' album.
    self.selectedAlbum = self.albums.firstObject;
    //The selected pin year by default is the 'All' group.
    self.selectedPinYear = @"All";
    
    [self setUpMapViews];
    [self setUpSegmentedControl];
    [self setUpOptionsButton];
    [self setUpPinButtons];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)updateData {
    self.albums = [self loadAlbums];
}

//MARK: - Map Views
//MARK: Setup

-(void)setUpMapViews {
    //This map view contains the annotations for both Photo Map and the Pin Map
    self.mapView = [[MGLMapView alloc] initWithFrame:CGRectMake(1, 1, 100, 100)];
    self.mapView.translatesAutoresizingMaskIntoConstraints = false;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    //The pin recognizer is for the pin map.
    
    self.touchRecognizer = [[UITapGestureRecognizer alloc]init];
    [self.touchRecognizer addTarget:self action:@selector(userDidScratch)];
    self.touchRecognizer.delegate = self;
    [self.touchRecognizer setEnabled:false];
    [self.mapView addGestureRecognizer:self.touchRecognizer];
    
    [self layoutMapView];
    Album *album = self.albums.firstObject;
    self.memories = album.memories;
    [self plotMemories];
    //Pin points are loaded, and if the array does not exist then one is created/
    self.pinPoints = [self loadPinPoints];
    if (self.pinPoints == nil){
        self.pinPoints = [[NSMutableArray alloc]init];
    }
}


//MARK: Layout
-(void)layoutMapView {
    //The map view is positioned below the header view, but allows space for the buttons.
    NSDictionary *views = @{@"mapView": self.mapView};
    NSDictionary *metrics = @{@"headerHeight":@(self.screenSize.height*0.132), @"mapHeight":@(self.screenSize.height*0.625)};
    
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(headerHeight)-[mapView(mapHeight)]" options:0 metrics:metrics views:views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapView]|" options:0 metrics:nil views:views]];
    
    
    [self.view layoutIfNeeded];
    
}


//MARK: Plot Memories for Photo Map
-(void)plotMemories {
    
    int i = 0;
    //While loop that adds annotations for all the memories in the array
    while (i != self.memories.count) {
        //Creates a memoryPointAnnotation with the coordinate and title (caption)
        MGLPointAnnotation* memoryPointAnnotation = [[MGLPointAnnotation alloc]init];
        Memory *memory = self.memories[i];
        memoryPointAnnotation.coordinate = memory.location.coordinate;
        memoryPointAnnotation.title = memory.caption;
        [self.mapView addAnnotation:memoryPointAnnotation];
        
        i += 1;
        
    }
    //This is used to loop through the memories for the annotation image delegate function.
    self.memoryIndex = 0;
    
    
}


//MARK: Plot points for pin map


-(void)plotPinPoints {
    //The visible pin points array represents all the pin points actually plotted.
    NSMutableArray *visiblePinPoints = [[NSMutableArray alloc]init];
    //If the selected pin year is all, then the visible pin points are simply all the existing ones.
    if ([self.selectedPinYear isEqualToString:@"All"]){
        visiblePinPoints = self.pinPoints;
    }else{
        //Otherwise, the pin points are selected with the specific year.
        for (int j = 0; j<self.pinPoints.count; j++) {
            PinPoint *pinPoint = self.pinPoints[j];
            //If the pin point year is equal to selected year then it is added to visible pin points array.
            if ([pinPoint.year isEqualToString:self.selectedPinYear]) {
                [visiblePinPoints addObject:pinPoint];
            }
        }
    }
    //Each of the established visible pin points is plotted.
    int i = 0;
    while (i!=visiblePinPoints.count) {
        PinPoint *pinPoint = visiblePinPoints[i];
        MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc]init];
        annotation.coordinate = pinPoint.location.coordinate;
        [self.mapView addAnnotation:annotation];
        i += 1;
    }
    
    
}
//MARK: User did Scratch
-(void)userDidScratch{
    //The touch point is established within the view.
    CGPoint touchPoint = [self.touchRecognizer locationInView:self.mapView];
    //This touch point is used to identify the map coordinate.
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    //An annotation is created using the identified location.
    MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc]init];
    annotation.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:annotation];
    //A pin point is created for the location.
    [self.pinPoints addObject:[[PinPoint alloc]initWithLocation:[[CLLocation alloc]initWithLatitude:touchMapCoordinate.latitude longitude:touchMapCoordinate.longitude]andYearPlotted:[self.dateFormatter stringFromDate:[NSDate date]]]];
    //If this was the first pin point, then the undo button appears.
    if (self.pinPoints.count == 1){
        [self.undoButton setEnabled:true];
        [self.undoButton setAlpha:1];
    }
    [self savePinPoints];
    
}
//MARK: - Segmented Control
//MARK: Setup

-(void)setUpSegmentedControl{
    //This is the creation of the segmented control which allows selection between the photo map and a pin map.
    self.mapSelector = [[UISegmentedControl alloc]initWithItems:@[@"Photo", @"Pin"]];
    
    self.mapSelector.backgroundColor = [UIColor whiteColor];
    self.mapSelector.tintColor = [UIColor blackColor];
    
    //The initial segmented control value is 0 (photo map)
    [self.mapSelector setSelectedSegmentIndex:0];
    [self.mapSelector addTarget:self action:@selector(segmentedControlValueChange) forControlEvents:UIControlEventValueChanged];
    self.mapSelector.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview:self.mapSelector];
}

//MARK: - Options Button
//MARK: Setup

-(void)setUpOptionsButton {
    //Setting up the button which brings up an options menu
    self.optionsButton = [[UIButton alloc] init];
    self.optionsButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.optionsButton setTitle:@"  OPTIONS  " forState:UIControlStateNormal];
    self.optionsButton.backgroundColor = [UIColor clearColor];
    [self.optionsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.optionsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [self.optionsButton addTarget:self action:@selector(optionButtonPress) forControlEvents:UIControlEventTouchUpInside];
    self.optionsButton.titleLabel.font = [UIFont fontWithName:@"Arial" size:self.screenSize.width*0.040625];
    self.optionsButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.optionsButton.layer.borderWidth = 1.5;
    self.optionsButton.layer.cornerRadius = 3;
    [self.view addSubview:self.optionsButton];
    
    
}

//MARK: - Pin Buttons
//MARK: Setup

-(void)setUpPinButtons{
    //The pin button determines whether the use can or cannot plot Pin Points.
    self.pinButton = [[UIButton alloc]init];
    self.pinButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.pinButton setImage:[UIImage imageNamed:@"Pin"] forState:UIControlStateNormal];
    self.pinButton.imageEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3);
    [self.pinButton addTarget:self action:@selector(pinButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.pinButton setHidden: true];
    [self.pinButton setEnabled: false];
    [self.pinButton setAlpha:0.5];
    self.pinButton.backgroundColor = [UIColor clearColor];
    self.pinButton.layer.borderColor = [[UIColor blackColor]CGColor];
    self.pinButton.layer.borderWidth = 2;
    self.pinButton.layer.cornerRadius = 5;
    
    [self.view addSubview:self.pinButton];
    
    //The undo button removes the last posted pin point. It is only active if there is at least one pin point.
    self.undoButton = [[UIButton alloc]init];
    self.undoButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.undoButton setImage:[UIImage imageNamed:@"Undo"] forState:UIControlStateNormal];
    self.undoButton.backgroundColor = [UIColor clearColor];
    [self.undoButton setHidden: true];
    [self.undoButton setEnabled: false];
    self.undoButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    self.undoButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    if (self.pinPoints.count == 0){
        [self.undoButton setEnabled:false];
        [self.undoButton setAlpha:0.5];
    }
    [self.undoButton addTarget:self action:@selector(undoButtonPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.undoButton];
    
    [self layoutButtons];
}

//MARK: - Layout

-(void)layoutButtons{
    CGFloat itemHeight = self.screenSize.height*0.044;
    
    //Map Selector - centre X, below the Map View
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapSelector attribute:NSLayoutAttributeTop multiplier:1 constant:-self.screenSize.height*0.018]];
   
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapSelector attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.mapSelector attribute: NSLayoutAttributeLeft multiplier:1 constant:self.screenSize.width*0.40625]];

    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapSelector attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.mapSelector attribute:NSLayoutAttributeTop multiplier:1 constant:itemHeight]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapSelector attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    //Options Button - centre X, below Map Selector
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.optionsButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.mapSelector attribute:NSLayoutAttributeBottom multiplier:1 constant:self.screenSize.height*0.012]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.optionsButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.optionsButton attribute:NSLayoutAttributeTop multiplier:1 constant:itemHeight]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.optionsButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    //Pin Button - On the right, below Map View
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.pinButton attribute:NSLayoutAttributeTop multiplier:1 constant:-self.screenSize.height*0.018]];
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.pinButton attribute:NSLayoutAttributeRight multiplier:1 constant:self.screenSize.height*0.026]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pinButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.pinButton attribute: NSLayoutAttributeLeft multiplier:1 constant:itemHeight]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.pinButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.pinButton attribute:NSLayoutAttributeTop multiplier:1 constant:itemHeight]];
    
    //Undo Button - Left of pin button, below Map View
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.undoButton attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.undoButton attribute: NSLayoutAttributeLeft multiplier:1 constant:self.screenSize.height*0.035]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.undoButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.undoButton attribute:NSLayoutAttributeTop multiplier:1 constant:self.screenSize.height*0.035]];
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.pinButton attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.undoButton attribute:NSLayoutAttributeRight multiplier:1 constant:self.screenSize.height*0.0106]];
    
    [self.view addConstraint: [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.undoButton attribute:NSLayoutAttributeTop multiplier:1 constant:-self.screenSize.height*0.0229]];
    
    
    
    [self.view layoutIfNeeded];
    
}

//MARK: - Saving and Loading Pin Points

-(NSMutableArray*)loadPinPoints {
    //This loads the Pin points.
    NSData *pinPointData = [[NSUserDefaults standardUserDefaults] objectForKey:@"PinPoints"];
    NSMutableArray *pinPoints =  [NSKeyedUnarchiver unarchiveObjectWithData:pinPointData];
    return pinPoints;
}

-(void)savePinPoints {
    //This saves the Pin points.
    NSData *pinPointData = [NSKeyedArchiver archivedDataWithRootObject:self.pinPoints];
    [[NSUserDefaults standardUserDefaults] setObject:pinPointData forKey:@"PinPoints"];
}


//MARK: - Button Presses
//MARK: Segmented Control Press

-(void)segmentedControlValueChange {
    //When the mapSelector is clicked, this function is called
    //A switch statement is used to act upon which segment is now selected
    switch (self.mapSelector.selectedSegmentIndex) {
        case 0:
            //If the Photo map is selected, the annotations are removed. The Memory annotations are displayed.
            self.mapType = Photo;
            self.mapView.delegate = self;
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self plotMemories];
            //The pin and undo button disappears, and the touch recognizer is disabled.
            [self.pinButton setHidden:true];
            [self.pinButton setEnabled:false];
            [self.undoButton setHidden:true];
            [self.undoButton setEnabled:false];
            [self.pinButton setAlpha:0.5];
            [self.touchRecognizer setEnabled:false];
            break;
            
        case 1:
            //If the Edit button currently says 'Done', then it changes to 'Edit'.
            if (![self.headerView.editBtn.titleLabel.text isEqualToString:@"Edit"]){
                [self.headerView.editBtn setTitle: @"Edit"forState:UIControlStateNormal];
            }
            //The annotations are removed, the pin annotations are displayed.
            self.mapType = Pin;
            self.mapView.delegate = nil;
            [self.mapView removeAnnotations:self.mapView.annotations];
            [self plotPinPoints];
            //Pin button and undo button appear if the chosen selected pin year is 'All'
            if ([self.selectedPinYear isEqualToString:@"All"]) {
                [self.pinButton setHidden:false];
                [self.pinButton setEnabled:true];
                [self.undoButton setHidden:false];
                [self.undoButton setEnabled:true];
            }
            
            break;
        default:
            break;
    }
}

//MARK: Option Button Press

-(void)optionButtonPress{
    //Called when the options button is pressed.
    if(self.mapType == Photo){
        //Photo map options are displayed.
        OptionsVC *optionsVC = [[OptionsVC alloc]initWithSelectedGroup:self.selectedAlbum orYear:self.selectedPhotoYear andAlbums:self.albums];
        optionsVC.delegate = self;
        optionsVC.modalPresentationStyle = UIModalPresentationCustom;
        optionsVC.transitioningDelegate = self;
        [self presentViewController:optionsVC animated:true completion:nil];
    }else{
        //Pin Map options are displayed.
        OptionsVC *optionsVC = [[OptionsVC alloc]initWithSelectedPinYear:self.selectedPinYear andPinPoints:self.pinPoints];
        optionsVC.delegate = self;
        optionsVC.modalPresentationStyle = UIModalPresentationCustom;
        optionsVC.transitioningDelegate = self;
        [self presentViewController:optionsVC animated:true completion:nil];
    }
    
}

//MARK: Pin Button Press

-(void)pinButtonPress{
    //The recognizer is enabled and disabled respectively, depending on the state of the pin button.
    if (self.touchRecognizer.isEnabled){
        [self.pinButton setAlpha:0.5];
        [self.touchRecognizer setEnabled:false];
    }else {
        [self.touchRecognizer setEnabled:true];
        [self.pinButton setAlpha:1];
    }
}

//MARK: Undo Button Press

-(void)undoButtonPress{
    //When the undo button is pressed, the last pin point is removed, and if there are none left, then the undo button is disabled.
    [self.pinPoints removeObject:self.pinPoints.lastObject];
    [self.mapView removeAnnotation:self.mapView.annotations.lastObject];
    if (self.pinPoints.count == 0){
        [self.undoButton setEnabled:false];
        [self.undoButton setAlpha:0.5];
    }
    [self savePinPoints];
}

//MARK: Edit Button Press

-(void)editAction{
    //This function overrides the TMViewController function of editAction, called when the editButton is clicked.
    [super editAction];
    if ([self.headerView.editBtn.titleLabel.text isEqualToString:@"Edit"]){
        [self.headerView.editBtn setTitle: @"Done"forState:UIControlStateNormal];
    }else{
        [self.headerView.editBtn setTitle: @"Edit"forState:UIControlStateNormal];
    }
}


//MARK: - Delegates

//MARK: Options VC Delegate
-(void)updatePhotoMapWithChosenAlbum: (Album*)album orYear: (NSString*) year {
    //The selected album/year is established.
    self.selectedAlbum = album;
    self.selectedPhotoYear = year;
    //If an album is selected, then the memories are assigned to the memories of the album.
    if (self.selectedAlbum != nil){
        self.memories = self.selectedAlbum.memories;
    }else{
        //If a year is selected, then the Memories are checked based on their date taken.
        NSArray *allMemories = [self.albums.firstObject memories];
        NSMutableArray *chosenMemories = [[NSMutableArray alloc]init];
        for (int i = 0; i<allMemories.count; i++) {
            Memory *memory = allMemories[i];
            if ([[memory.dateTaken substringFromIndex: memory.dateTaken.length -4] isEqualToString: year]){
                [chosenMemories addObject:memory];
            }
        }
        self.memories = chosenMemories;
    }
    //The annotations are removed, the selected ones are plotted.
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self plotMemories];
    
}

-(void)updatePinMapWithChosenYear:(NSString *)year{
    //The selected year is established, annotations are removed and replotted.
    [self.mapView removeAnnotations:self.mapView.annotations];
    self.selectedPinYear = year;
    [self plotPinPoints];
    //If the year selected is'All', then the undo button and pin button appears, otherwise it disappears.
    if (![year isEqualToString:@"All"]) {
        [self.undoButton setHidden:true];
        [self.undoButton setUserInteractionEnabled:false];
        [self.pinButton setHidden:true];
        [self.pinButton setUserInteractionEnabled:false];
        
    }else{
        [self.undoButton setHidden:false];
        [self.undoButton setUserInteractionEnabled:true];
        [self.pinButton setHidden:false];
        [self.pinButton setUserInteractionEnabled:true];
    }
    
}

//MARK: Album VC Delegate

-(void)albumSelected: (NSInteger)index{
    //When an album is selected for Memory to be added to, then the Memory is added to the Album.
    [self.albums[index] addMemory:self.selectedMemory];
    self.selectedMemory = nil;
    [self saveAlbums:self.albums];
    [self.delegate albumsUpdateFromMapVC];
    
}

//MARK: Map View Delegate

//This function means that every time a pin is touched, the title of the annotation is shown, but also displaying options for adding to an album or deleting from album.

-(BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id<MGLAnnotation>)annotation{
    
    //The function checks if the editing mode is enabled
    if ([self.headerView.editBtn.titleLabel.text isEqualToString:@"Done"]){
        
        //This loop is used to identify which memory has been selected by comparing captions.
        int index;
        for (int i = 0; i<self.memories.count; i++) {
            if ([[annotation title]isEqualToString:[self.memories[i] caption]]) {
                index = i;
                self.selectedMemory = self.memories[index];
                break;
            }
        }
        //The alert controller is created with its title being the capion of the memory.
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:self.selectedMemory.caption preferredStyle:UIAlertControllerStyleActionSheet];
        //The cancel button allows the user to not act upon either option.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [alertController dismissViewControllerAnimated:true completion:nil];
        }];
        [alertController addAction:cancelAction];
        
        //This code determines the visible string for the delete prompt. It depends on the album in which it is selected.
        NSString *deleteString;
        //If there is a selected album, then this is the subject of the delete prompt.
        if (self.selectedPhotoYear == nil){
            deleteString = [NSString stringWithFormat:@"Delete From %@", self.selectedAlbum.albumName];
        } else {
            //If there is no selected album, then the option is simply to delete from All Memories.
            deleteString = [NSString stringWithFormat:@"Delete From All Memories"];
        }
        //The delete action is created using the delete string.
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle: deleteString style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
            //If delete is pressed, the following code is executed.
            //If the Memory is to be deleted from 'All Memories', then the memory is removed from all the Albums in which it appears
            if ([deleteString isEqualToString:@"Delete From All Memories"]){
                [[self.albums firstObject] removeMemory:self.selectedMemory];
                for (int i = 1; i<self.albums.count; i++) {
                    if ([self album:self.albums[i] containsMemory:self.selectedMemory]){
                        [self.albums[i] removeMemory:self.selectedMemory];
                    }
                }
            }else{
                //If the Memory is only being deleted from one Album, then the index is determined and used to directly change the albums array.
                NSInteger ind = [self.albums indexOfObject:self.selectedAlbum];
                [self.albums[ind] removeMemory:self.selectedMemory];
            }
            //The changes are saved and updated across the app.
            [self saveAlbums:self.albums];
            [self.delegate albumsUpdateFromMapVC];
            [self.memories removeObject:self.selectedMemory];
            [self.mapView removeAnnotation:annotation];
            [alertController dismissViewControllerAnimated:true completion:nil];
            
        }];
        [alertController addAction:deleteAction];
        
        //The add action is created and used to add the chosen Memory to an album.
        UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add To Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            //The album selector is presented.
            AlbumSelectorVC *albumSelectorVC = [[AlbumSelectorVC alloc]initForMemory:self.selectedMemory];
            albumSelectorVC.delegate = self;
            
            [alertController dismissViewControllerAnimated:true completion:nil];
            [self presentViewController:albumSelectorVC animated:true completion:nil];
            
        }];
        [alertController addAction:addAction];
        
        [self presentViewController:alertController animated:true completion:nil];
    }
    return true;
}

//This function allows me to change the image of a pin annotation.

-(MGLAnnotationImage *)mapView:(MGLMapView *)mapView imageForAnnotation:(id<MGLAnnotation>)annotation {
    
    Memory *memory = self.memories[self.memoryIndex];
    
    MGLAnnotationImage *pinImage = [mapView dequeueReusableAnnotationImageWithIdentifier:[[NSString alloc] initWithFormat:@"%ld", (long)memory.identifier]];
    if (!pinImage){
        //Create an imageView with a border (for the frame) and set the colour
        //Set the size of the imageView so that the created image will not fill the screen
        CGFloat imageWidth = self.screenSize.height*0.1;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, imageWidth, imageWidth)];
        imageView.image = memory.photo;
        imageView.layer.borderWidth = 4;
        imageView.layer.borderColor = [memory.frameColour CGColor];
        
        //Take a screenshot of the imageView including the frame, and this screenshot is used as the pin image
        
        UIGraphicsBeginImageContext(imageView.bounds.size);
        [imageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        pinImage = [MGLAnnotationImage annotationImageWithImage:screenShot reuseIdentifier: [[NSString alloc] initWithFormat:@"%ld", (long)memory.identifier]];
    }
    self.memoryIndex += 1;
    
    memory = nil;
    return pinImage;
}



-(UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source{
    return [[HalfSizePresentationController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
}

@end


