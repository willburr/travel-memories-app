//
//  ScrollVC.m
//  Memories
//
//  Created by William Burr on 21/02/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import "ScrollVC.h"

@interface ScrollVC ()

@end

@implementation ScrollVC

//MARK: - Initialisation

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenSize = [[UIScreen mainScreen]bounds].size;
    [self setUpScrollView];
    [self setUpVCViews];
    [self setUpButtons];\
    //The following line of code causes the app to appear on the Start VC (so they are immediately prompted to make a new Memory.
    [self.scrollView setContentOffset:CGPointMake(self.screenSize.width, self.scrollView.contentOffset.y)];

    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidLayoutSubviews{
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    //If a memory warning is recieved, an alert controller is presented if not already
    if (!self.memoryWarningAC){
        self.memoryWarningAC =  [UIAlertController
                                  alertControllerWithTitle:@"Memory Warning"
                                  message:@"Free up some space on your device for Memories App"
                                  preferredStyle:UIAlertControllerStyleAlert];
        //The following action directs the user to the settings
        UIAlertAction* settings = [UIAlertAction actionWithTitle:@"Settings" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                                                       [self.memoryWarningAC dismissViewControllerAnimated:YES completion:nil];
                                                   }];
        [self.memoryWarningAC addAction:settings];
 
    }
    if (![self.memoryWarningAC isBeingPresented]){
        [self presentViewController:self.memoryWarningAC animated:YES completion:nil];
    }
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: Scroll View

-(void)setUpScrollView {
    //Sets up the scroll view which contains all the TMViewControllers.
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
    self.scrollView.scrollEnabled = true;
    self.scrollView.showsVerticalScrollIndicator = false;
    self.scrollView.showsHorizontalScrollIndicator = false;
    self.scrollView.pagingEnabled = true;
    self.scrollView.delegate = self;
    self.scrollView.bounces = false;
    [self.view addSubview:self.scrollView];
    
    
    [self layoutScrollView];
    
}

-(void)layoutScrollView{
    NSDictionary* views = @{@"scrollView":self.scrollView};
    
    NSDictionary* metrics = @{@"footerHeight":@(self.screenSize.height*0.105)};
    //The scroll view is contained above the footer and fills vertically.
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollView]-(footerHeight)-|" options:0 metrics:metrics views:views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:views]];
    
    [self.view layoutIfNeeded];
    
}

//MARK: VC views

-(void)setUpVCViews{
    //Here, each of the VC views are created and declared as child view controllers as part of the parent view controller
    //Then, the VC.view is added as a subview to the scrollView. This is because the VC itself is not a view.
    self.startVC = [[StartVC alloc]init];
    [self addChildViewController:self.startVC];
    [self.startVC didMoveToParentViewController:self];
    self.startVC.delegate = self;
    self.startVC.view.translatesAutoresizingMaskIntoConstraints = false;
    [self.scrollView addSubview:self.startVC.view];
    
    self.mapVC = [[MapVC alloc]init];
    [self addChildViewController:self.mapVC];
    self.mapVC.delegate = self;
    [self.mapVC didMoveToParentViewController:self];
    self.mapVC.view.translatesAutoresizingMaskIntoConstraints = false;
    [self.scrollView addSubview:self.mapVC.view];
    
    self.albumVC = [[AlbumVC alloc]init];
    [self addChildViewController:self.albumVC];
    [self.albumVC didMoveToParentViewController:self];
    self.albumVC.delegate = self;
    self.albumVC.view.translatesAutoresizingMaskIntoConstraints = false;
    [self.scrollView addSubview:self.albumVC.view];
    
    [self layoutVCViews];
    
}

-(void)layoutVCViews {
    
    NSDictionary* views = @{@"scrollView": self.scrollView,@"startVC":self.startVC.view, @"mapVC": self.mapVC.view, @"albumVC": self.albumVC.view};
    //The Map VC is positioned on the left, the Start VC in the centre, and the Album VC on the right.
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[startVC(scrollView)]|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapVC(scrollView)][startVC(scrollView)][albumVC(scrollView)]|" options: NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
    
    [self.scrollView layoutIfNeeded];
    
}

//MARK: Buttons


-(void)setUpButtons {
    
    //This is a view which will contain the buttons at the bottom of the screen for selecting a page
    self.footerView = [[UIView alloc]init];
    self.footerView.translatesAutoresizingMaskIntoConstraints = false;
    self.footerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.footerView];
    
    //The following are buttons that are in the footer view
    
    self.startButton = [[UIButton alloc] init];
    self.startButton.translatesAutoresizingMaskIntoConstraints = false;
    //Adds the target for the button, the function that will be called when the button is clicked
    [self.startButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.startButton setImage:[UIImage imageNamed:@"Photo"] forState:normal];
    self.startButton.imageEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
    [self.footerView addSubview:self.startButton];
    
    self.mapButton = [[UIButton alloc] init];
    self.mapButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.mapButton setImage:[UIImage imageNamed:@"Map"] forState:normal];
    //Adds the target for the button, the function that will be called when the button is clicked
    [self.mapButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    self.mapButton.imageEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
    [self.footerView addSubview:self.mapButton];
    
    self.albumButton = [[UIButton alloc] init];
    self.albumButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.albumButton setImage:[UIImage imageNamed:@"Book"] forState:normal];
    //Adds the target for the button, the function that will be called when the button is clicked
    [self.albumButton addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
    self.albumButton.imageEdgeInsets = UIEdgeInsetsMake(5, 20, 5, 20);
    [self.footerView addSubview:self.albumButton];
    
    //The scroll bar is similar to a scroll indicator except it will be easier to control
    
    self.scrollBar = [[UIView alloc]init];
    self.scrollBar.translatesAutoresizingMaskIntoConstraints = false;
    self.scrollBar.backgroundColor = [UIColor blackColor];
    
    [self.footerView addSubview:self.scrollBar];
    
    [self layoutButtons];
}

-(void)layoutButtons {
    
    NSDictionary* views = @{@"scrollView":self.scrollView, @"footerView":self.footerView, @"startButton": self.startButton, @"mapButton": self.mapButton, @"albumButton": self.albumButton, @"scrollBar": self.scrollBar};
    
    
    //This determines the positioning of the footerView. It is positioned just below the scrollView but spreads across the view controller's width
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[scrollView][footerView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[footerView]|" options:0 metrics:nil views:views]];
    
    
    NSDictionary* metrics = @{@"buttonWidth":@(self.screenSize.width/3)};
    
    //Each of the buttons are placed in the center Y coordinate of the footerView. The start button is placed in the center X of the footerView. The Map button is placed at the left edge of the footerView. The Album button is placed at the right edge of the footer view.
    
    //Start Button
    
    [self.footerView addConstraint:[NSLayoutConstraint constraintWithItem:self.startButton attribute:NSLayoutAttributeCenterX relatedBy: NSLayoutRelationEqual toItem:self.footerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self.footerView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[startButton]|" options:0 metrics:metrics views:views]];
    [self.footerView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:[startButton(buttonWidth)]" options:0 metrics:metrics views:views]];
    
    
    //Map Button
    [self.footerView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[mapButton(buttonWidth)]" options:0 metrics:metrics views:views]];
    [self.footerView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[mapButton]|" options:0 metrics:metrics views:views]];
    
    //Album Button
    [self.footerView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:[albumButton(buttonWidth)]|" options:0 metrics:metrics views:views]];
    [self.footerView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[albumButton]|" options:0 metrics:metrics views:views]];
    
    //Scroll Bar
    
    //The bar width is equivalent to two times the buttonGap plus 30 (for button width)
    
    [self.footerView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:[scrollBar(buttonWidth)]" options:0 metrics:metrics views:views]];
    
    //A changeable layout constraint is necessary so that the position of the scroll bar can change when one of the buttons is clicked, it shall be initially set to 0 in relation to the center.
    
    self.scrollBarConstraint = [NSLayoutConstraint constraintWithItem:self.footerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scrollBar attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    
    [self.footerView addConstraint:self.scrollBarConstraint];
    [self.footerView addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[scrollBar(2)]" options:0 metrics:nil views:views]];
    
    
    [self.view layoutIfNeeded];
    [self.footerView layoutIfNeeded];
    
    
    
}

//MARK: Button tap recognisers

-(void)buttonTap: (UIButton*) button {
    //This function is called when one of the three buttons is tapped.
    //This function shall determine which button was pressed and therefore adjusts the position of the scroll view accordingly.
    
    if (button == self.startButton) {
        //If startButton was the button clicked, then the scroll view goes to second page
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, self.scrollView.contentOffset.y) animated:true];
        
        
    } else if (button == self.mapButton) {
        //If mapButton was the button clicked, then the scroll view goes to first page
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:true];
        
        
        
    } else if (button == self.albumButton){
        //If mapButton was the button clicked, then the scroll view goes to third page
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width*2, self.scrollView.contentOffset.y) animated:true];
        
    }
    
    
}

//MARK: - Delegate

//MARK: Scroll View Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    float location = scrollView.contentOffset.x/scrollView.frame.size.width;
        
    //If the value is 0, then the new scroll bar coordinate is -self.view.frame.size.width/3
    //If the value is 2, then the new scroll bar coordinate is +self.view.frame.size.width/3
    //If the value is 1 then the new scroll bar coordinate is 0
    //Hence
        
    self.scrollBarConstraint.constant = (self.view.frame.size.width/3)*(1-location);
    [self.footerView layoutIfNeeded];
    
}
//MARK: Album VC Delegate

-(void)albumsUpdateFromAlbumVC{
    
    //Function to update albums for StartVC
    [self.startVC updateData];
    
    //Function to update albums for MapVC
    [self.mapVC updateData];
    //If the selected map type is Photo, then the photo map is updated with new album changes.
    if (self.mapVC.mapSelector.selectedSegmentIndex == 0){
        [self.mapVC updatePhotoMapWithChosenAlbum:self.mapVC.albums.firstObject orYear:nil];

    }
}

//MARK: Start VC Delegate

-(void)albumsUpdateFromStartVC{
    //Function to update albums for AlbumVC
    [self.albumVC updateData];
    //Function to update albums for MapVC
    [self.mapVC updateData];
    //If the selected map type is Photo, then the photo map is updated with new album changes.
    if (self.mapVC.mapSelector.selectedSegmentIndex == 0){
        [self.mapVC updatePhotoMapWithChosenAlbum:self.mapVC.albums.firstObject orYear:nil];
        
    }
}

//MARK: Map VC Delegate

-(void)albumsUpdateFromMapVC{
    
    //Function to update albums for StartVC
    [self.startVC updateData];
    
    //Function to update albums for AlbumVC
    [self.albumVC updateData];
    
}

//MARK: VC Delegate

-(void)disableSuperScroll{
    [self.scrollView setScrollEnabled:false];
    [self.footerView setUserInteractionEnabled:false];
}
-(void)enableSuperScroll{
    [self.scrollView setScrollEnabled:true];
    [self.footerView setUserInteractionEnabled:true];
}


@end

