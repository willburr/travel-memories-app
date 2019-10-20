
//
//  StartVC.m
//  Memories
//
//  Created by User on 12/02/2017.
//  Copyright © 2017 User. All rights reserved.
//

#import "StartVC.h"

@interface StartVC ()

@end

@implementation StartVC

@synthesize delegate;

//MARK: - Initialisation

-(instancetype)init {
    self = [super initWithNibName:@"StartVC" bundle: [NSBundle mainBundle] headerNav:None];
    [self setCustomHeaderTitle:@"Travel Memories"];
    //If there are no albums, then it creates the first album.
    if ([self loadAlbums] != nil){
        self.albums = [self loadAlbums];
    } else{
        self.albums = [[NSMutableArray alloc]init];
        [self.albums addObject:[[Album alloc]init:@"All Memories"]];
    }
    //The location manager is created, and it requests use from the user.
    self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];
    
    self.dateFormatter = [[NSDateFormatter alloc]init];
    self.dateFormatter.dateFormat = @"dd-MM-yyyy";
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpScrollView];
    [self setUpViews];
    //self.view.backgroundColor = [UIColor colorWithRed:0.4 green:0.8 blue:0.95 alpha:1];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateData{
    self.albums = self.loadAlbums;
}

//MARK: - Items

//MARK: Scroll View

-(void)setUpScrollView {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
    
    //I have first instantiated the scroll view, and made it so that it does not translate autoresizing mask into constraints, allowing me to add constraints.
    
    self.scrollView.delegate = self;
    
    //Every scroll view needs a delegate, a class which handles the related functions and behaviour for the view.
    
    self.scrollView.bounces = NO;
    
    //The user cannot bounce the scroll view, since the design of this scrollview is largely stationary
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    // The scroll view itself should not be visible.
    
    self.scrollView.scrollEnabled = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview: self.scrollView];
    [self layoutScrollView];
}

-(void)layoutScrollView {
    
    NSDictionary *views = @{@"scrollView": self.scrollView};
    
    NSDictionary *metrics = @{@"headerHeight":@(self.screenSize.height*0.132)};
    //The scroll view is positioned below the header view.
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(headerHeight)-[scrollView]|" options: NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options: NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    [self.view layoutIfNeeded];
}

//MARK: Views

-(void)setUpViews {
    //The start view is created.
    self.startView = [[StartView alloc] init];
    [self.startView commonInit];
    self.startView.translatesAutoresizingMaskIntoConstraints = false;
    [self.startView.photoButton addTarget:self action: @selector(photoButtonPress) forControlEvents: UIControlEventTouchUpInside];
    [self.startView.cameraButton addTarget:self action: @selector(cameraButtonPress) forControlEvents: UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.startView];
    //The memory creator view is created.
    self.memoryCreatorView = [[MemoryCreatorView alloc]init];
    [self.memoryCreatorView commonInit];
    self.memoryCreatorView.translatesAutoresizingMaskIntoConstraints = false;
    [self.memoryCreatorView.albumButton addTarget:self action:@selector(albumButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self.memoryCreatorView.postButton addTarget:self action:@selector(postButtonPress) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView addSubview:self.memoryCreatorView];
    [self layoutViews];
}

-(void)layoutViews {
    
    NSDictionary *views = @{@"startView": self.startView , @"memoryCreatorView": self.memoryCreatorView, @"scrollView": self.scrollView};
    //The start view is positioned on the left of the scroll view, the memory creator view is positioned on the right of the scroll view.
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[startView(scrollView)]|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[startView(scrollView)][memoryCreatorView(scrollView)]|" options: NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
    
    [self.view layoutIfNeeded];
}


//MARK: - Delegates
//MARK: Start view Delegate

-(void) photoButtonPress {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //An image picker controller is created
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //The source type refers to where the image is being selected from, here it is from library
    imagePickerController.delegate = self;
    //The delegate is self, meaning the functions for the controller exist in this object
    imagePickerController.allowsEditing = true;
    //The image can be edited to fit a certain size
    [self  presentViewController:imagePickerController animated:true completion:nil];
    
}

-(void)cameraButtonPress {
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //An image picker controller is created
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    //The source type refers to where the image is being selected from, here it is from camera
    imagePickerController.delegate = self;
    //The delegate is self, meaning the functions for the controller exist in this object
    imagePickerController.allowsEditing = true;
    //The image can be edited to fit a certain size
    imagePickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
    //The camera capture mode refers to whether it is from a photo or video
    [self presentViewController:imagePickerController animated:true completion:nil];
}

//MARK: Image Picker Controller Delegate

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:true completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *pickedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    self.memoryCreatorView.imageView.image = pickedImage;
    //When the image is chosen and identified, the picker is dismissed and the scroll view shifts over to the Memory Creator View, the nav style changes to 'Back' and the selected album index is set to 0. Note also that the super scroll is disabled.

    [picker dismissViewControllerAnimated:true completion: ^(void) {
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, self.scrollView.contentOffset.y) animated:true];
        [self changeCustomHeaderStyle:Back];
        [self setCustomHeaderTitle:@"Create a Memory"];
        self.selectedAlbumIndex = 0;
        [self.memoryCreatorView.postButton setEnabled:false];
        self.memoryCreatorView.postButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
        [self.delegate disableSuperScroll];
    }];
    
}

//MARK: Album Selector Delegate

-(void)albumSelected:(NSInteger)index{
    //When an album is selected, the album index is store and the album button is disabled so that another cannot be selected.
    self.selectedAlbumIndex = index;
    [self.memoryCreatorView.albumButton setEnabled:false];
}

//MARK: - Buttons
//MARK: Back Scroll Action

-(void) backAction {
    //When back is pressed, the caption text view resigns, the scroll view shifts, and the Memory Creator View's properties are reset. The super scroll view is enabled.
    [self.memoryCreatorView.captionTextView resignFirstResponder];
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:true];
    self.memoryCreatorView.captionTextView.text = @"Add a caption";
    [self.memoryCreatorView.albumButton setEnabled:true];
    [self changeCustomHeaderStyle:None];
    [self setCustomHeaderTitle:@"Travel Memories"];
    [self.delegate enableSuperScroll];
    
}

//MARK: Album Button
-(void)albumButtonPress{
    //The album button brings up the album selector VC.
    AlbumSelectorVC *albumSelectorVC = [[AlbumSelectorVC alloc]init];
    albumSelectorVC.delegate = self;
    [self presentViewController:albumSelectorVC animated:true completion:nil];
}

//MARK: Post Button
-(void)postButtonPress {
    //When the post button is pressed, the Memory is posted using a unique identifer.
    NSInteger identifier = [NSDate date].timeIntervalSince1970;
    Memory *memory = [[Memory alloc]initWithIdentifier: identifier andPhoto:self.memoryCreatorView.imageView.image withCaption:self.memoryCreatorView.captionTextView.text];
    //If the location services are not currently enabled, then location is nil
    if (!self.locationManager.location){
        //An alert controller is displayed prompting the user to enable location services
        UIAlertController *locationAlertController = [UIAlertController alertControllerWithTitle:@"Location Access is Turned Off" message:@"In order to add location to Memory, please open settings and set location access to 'While Using the App" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            [locationAlertController dismissViewControllerAnimated:true completion:nil];
        }];
        [locationAlertController addAction:cancelAction];
        UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
            [locationAlertController dismissViewControllerAnimated:true completion:nil];
        }];
        [locationAlertController addAction:settingsAction];
        [self presentViewController:locationAlertController animated:true completion:nil];
        
    }else{
        //If there is a valid location, then the Memory is posted.
        memory.location = self.locationManager.location;
        memory.dateTaken = [self.dateFormatter stringFromDate:[NSDate date]];
        memory.frameColour = self.memoryCreatorView.colourButton.backgroundColor;
        [self.albums.firstObject addMemory:memory];
        if (self.selectedAlbumIndex != 0){
            [self.albums[self.selectedAlbumIndex] addMemory: memory];
        }
    
   
        [self saveAlbums:self.albums];
        
        [self.delegate albumsUpdateFromStartVC];
        [self backAction];
     
    }
    
}

@end
