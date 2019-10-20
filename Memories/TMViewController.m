//
//  TMViewController.m
//  Memories
//
//  Created by William Burr on 14/02/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import "TMViewController.h"

@interface TMViewController ()

@end

@implementation TMViewController

//MARK: - Initialisation


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil headerNav: (TMHeaderStyle)headerStyle {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.headerStyle = &(headerStyle);
    self.screenSize = [[UIScreen mainScreen]bounds].size;
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1];
    [self setUpHeaderView];
    return self;
    //
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    /////////
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//MARK: - Header View
//MARK: Set up


-(void)setUpHeaderView {
    //The header view is set up using the chosen navigation style.
    self.headerView = [[TMHeaderView alloc] initWithFrame:CGRectZero navStyle:*(self.headerStyle)];
    self.headerView.translatesAutoresizingMaskIntoConstraints = false;
    [self.view addSubview: self.headerView];
    [self layoutHeaderView];
}

//MARK: Layout

-(void)layoutHeaderView {
    //The header view is laid out with a set height.
    NSDictionary *views = @{@"headerView": self.headerView};
    NSDictionary *metrics = @{@"headerHeight":@(self.screenSize.height*0.132)};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[headerView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[headerView(headerHeight)]" options:0 metrics:metrics views:views]];
    
    [self.view layoutIfNeeded];
    
}

//MARK: Change Header features

-(void)setCustomHeaderTitle: (NSString*)text{
    //Function which enables me to change the title text.
    [self.headerView setTitleText:text];
}

-(void)changeCustomHeaderStyle: (TMHeaderStyle) navStyle {
    //This allows for header style to be changed after instantiation.
    self.headerStyle = &(navStyle);
    self.headerView.navStyle = &(navStyle);
    [self.headerView styleNavigationBtn];
    [self.headerView.navigationBtn removeTarget:nil action:nil forControlEvents:UIControlEventAllEvents];
    [self setNavigationBtnAction];
    [self.view layoutIfNeeded];
}

-(void)backAction {
    //Over-ridable function.
}

-(void)editAction{
    //Over-ridable function.
}

-(void)addAction{
    //Over-ridable function.
}



//MARK: Navigation Button

-(void)setNavigationBtnAction {
    
    //Depending on the styling, the relevant target is set.
    TMHeaderStyle styling = *(self.headerStyle);
    
    if (styling == Back) {
        [self.headerView setNavigationAction:@selector(backAction) withSender:self];
    }else if (styling == Add){
        [self.headerView setNavigationAction:@selector(addAction) withSender:self];
    }
    
    
}

//MARK: Edit Button

-(void)setEditBtnAction{
    [self.headerView setEditAction:@selector(editAction) withSender:self];
    
}


//MARK: Load albums
-(NSMutableArray*)loadAlbums{
    NSData *albumsData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Albums"];
    NSMutableArray *albums = [NSKeyedUnarchiver unarchiveObjectWithData:albumsData];
    return albums;
}

//MARK: Save albums
-(void)saveAlbums: (NSMutableArray*)albums{
    NSData *albumsData = [NSKeyedArchiver archivedDataWithRootObject:albums];
    [[NSUserDefaults standardUserDefaults] setObject:albumsData forKey:@"Albums"];
}

//Function for returning if a memory exists in an album
-(bool)album: (Album*) album containsMemory:(Memory*) memory{
    bool found = false;
    //This loops through the Memories in the album
    for (int j = 0; j<album.memories.count; j++){
        //The memory at the index j is compared to the given memory
        Memory *testMemory = album.memories[j];
        if (testMemory.identifier == memory.identifier){
            found = true;
            break;
        }
        testMemory = nil;
    }
    return found;
}
//Function for retrieving the index of a Memory within the album
-(int)album: (Album*) album getIndexOfMemory:(Memory*) memory{
    int i = 0;
    //This loops through the Memories in the album
    for (int j = 0; j<album.memories.count; j++){
        //The memory at the index j is compared to the given memory
        Memory *testMemory = album.memories[j];
        if (testMemory.identifier == memory.identifier){
            i = j;
            break;
        }
        testMemory = nil;
    }
    return i;
}


@end
