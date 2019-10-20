//
//  AlbumSelectorVC.m
//  Memories
//
//  Created by William Burr on 10/03/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import "AlbumSelectorVC.h"


@interface AlbumSelectorVC ()

@end

@implementation AlbumSelectorVC

@synthesize delegate;

//MARK: - Initialisation

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//MARK: With A Memory
-(instancetype)initForMemory: (Memory*)memory{
    self.screenSize = [[UIScreen mainScreen]bounds].size;
    self = [super initWithNibName:@"AlbumSelectorVC" bundle:[NSBundle mainBundle] headerNav:Close];
    [self setCustomHeaderTitle:@"Add to Album"];
    [self.headerView setNavigationAction:@selector(closeAction) withSender:self];
    self.albums = [self loadAlbums];
    self.memory = memory;
    
    self.displayedAlbums = [[NSMutableArray alloc]init];
    //This loops from the second item in the Albums array, checking if the Memory doesn't current exist in the Album.
    for (int i = 1; i<self.albums.count; i++) {
        if (![self album:self.albums[i] containsMemory:self.memory]){
            [self.displayedAlbums addObject:self.albums[i]];
        }
    }
    
    [self setUpTableView];
    return self;
}
//MARK: Without a Memory
-(instancetype)init{
    self.screenSize = [[UIScreen mainScreen]bounds].size;
    self = [super initWithNibName:@"AlbumSelectorVC" bundle:[NSBundle mainBundle] headerNav:Close];
    [self setCustomHeaderTitle:@"Add to Album"];
    [self.headerView setNavigationAction:@selector(closeAction) withSender:self];
    self.albums = [self loadAlbums];
    //The first object is removed since it is not an option for one to add an album to the 'All Memories' album.
    [self.albums removeObjectAtIndex:0];
    self.displayedAlbums = self.albums;
    
    [self setUpTableView];
    return self;
}

//MARK: - Table View
//MARK: Set up

-(void)setUpTableView{
    
    //This instantiates the previously programmed class for an album table view.
    self.albumTableView = [[AlbumTableView alloc]init];
    [self.albumTableView commonInit: self.displayedAlbums];
    self.albumTableView.translatesAutoresizingMaskIntoConstraints = false;
    self.albumTableView.albumTableViewDelegate = self;
    [self.view addSubview:self.albumTableView];
    
    [self layoutTableView];
}

//MARK: Layout

-(void)layoutTableView{
    NSDictionary *views = @{@"albumTableView":self.albumTableView};
    NSDictionary *metrics = @{@"headerHeight":@(self.screenSize.height*0.132)};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(headerHeight)-[albumTableView]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[albumTableView]|" options:0 metrics:nil views:views]];
    
}
//MARK: Delegate

-(void)didSelectAlbumAtPath: (NSIndexPath*)indexPath{
    //When an album in the table is selected, the controller should be dismissed, and it should pass the index of selected album to the delegate that created the selector.
    NSUInteger index = [self.albums indexOfObject:self.displayedAlbums[indexPath.row]];
    [self.delegate albumSelected:index];
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)closeAction{
    [self dismissViewControllerAnimated:true completion:nil];
}

-(void)didDeleteAlbumAtPath:(NSIndexPath *)indexPath{}



@end
