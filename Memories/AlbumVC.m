//
//  AlbumVC.m
//  Memories
//
//  Created by William Burr on 22/02/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import "AlbumVC.h"

@interface AlbumVC ()

@end

@implementation AlbumVC

@synthesize delegate;
//MARK: - Initialisation

-(instancetype)init{
    
    //The style of the initialised VC is none since its appears on the album table view. It has the title of 'Albums'.
    self = [super initWithNibName:@"AlbumVC" bundle: [NSBundle mainBundle]  headerNav:None];
    [self setCustomHeaderTitle:@"Albums"];
    
    //If there are albums in storage, then these are retrieved. If there are no Albums in storage, one is created and saved.
    if ([self loadAlbums] != nil){
        self.albums = [self loadAlbums];
    } else{
        self.albums = [[NSMutableArray alloc]init];
        [self.albums addObject:[[Album alloc]init:@"All Memories"]];
        [self saveAlbums:self.albums];
    }
    //The main items of the Album VC are set up.
    [self setUpScrollView];
    [self setUpViews];
    //The edit button is used for the adding and deleting of Albums.
    [self.headerView setUpEditButton];
    [self setEditBtnAction];
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //If there is a lack of memory space, the page views and page scroll view is removed from the journal view
    //This is because it can be recreated
    [self.journalView.pageScrollView removeConstraints:self.journalView.pageScrollView.constraints];
    [self.journalView.pageScrollView removeFromSuperview];
    [self.journalView removeConstraints:self.journalView.constraints];
    for (int i = 0; i<self.journalView.subviews.count; i++) {
        [self.journalView.subviews[i] removeFromSuperview];
    }
    // Dispose of any resources that can be recreated.
}

-(void)updateData {
    //Called by the Scroll VC whenever the albums are changed by another View Controller
    self.albums = [self loadAlbums];
    self.albumTableView.albums = self.albums;
    [self.albumTableView reloadData];
}

//MARK: - Scroll View
//MARK: Set up
-(void)setUpScrollView {
    
    //The scroll view will contain the album table view and the journal view, it is not scrollable but it has pages.
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
    
    self.scrollView.delegate = self;
    
    self.scrollView.bounces = NO;
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    
    self.scrollView.scrollEnabled = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    [self.view addSubview: self.scrollView];
    [self layoutScrollView];

}
//MARK: Layout
-(void)layoutScrollView {
    //Scroll view positioned directly below the header view, fills the view vertically and horizontally.
    NSDictionary *views = @{@"scrollView": self.scrollView};
    NSDictionary *metrics = @{@"headerHeight":@(self.screenSize.height*0.132)};
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(headerHeight)-[scrollView]|" options: NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
    [self.view addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options: NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    [self.view layoutIfNeeded];
    
}

//MARK: - Sub Views
//MARK: Set up
-(void)setUpViews{
    
    //The album table view displays the albums, and it is a subview of the scroll view
    self.albumTableView = [[AlbumTableView alloc]init];
    [self.albumTableView commonInit: self.albums];
    self.albumTableView.translatesAutoresizingMaskIntoConstraints = false;
    self.albumTableView.albumTableViewDelegate = self;
    [self.scrollView addSubview:self.albumTableView];
    
    //This initialises the journal view with respect to the first album (all memories).
    Album *album = self.albums[0];
    
    //The journal view contains all the pages which each display a single memory.
    self.journalView = [[JournalView alloc]init];
    [self.journalView commonInit: album.memories];
    self.journalView.delegate = self;
    self.journalView.translatesAutoresizingMaskIntoConstraints = false;
    [self.scrollView addSubview:self.journalView];
    
    [self layoutViews];

}
//MARK: Layout
-(void)layoutViews{
    
    //The album table view has the same width of the journal view.
    
    NSDictionary *views = @{@"albumTableView": self.albumTableView , @"journalView": self.journalView, @"scrollView": self.scrollView};
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[albumTableView(scrollView)]|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[albumTableView(scrollView)][journalView(scrollView)]|" options: NSLayoutFormatAlignAllTop | NSLayoutFormatAlignAllBottom metrics:nil views:views]];
    
    [self.view layoutIfNeeded];
    
}
//MARK: - Button Press


//MARK: Back action

-(void)backAction{
    
    //When back is clicked, then the scroll view moves to display the the album table view
    [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:true];
    //The title is changed to albums, the back button disappears, the edit button reappears and any rows are deselcted.
    [self changeCustomHeaderStyle:None];
    [self setCustomHeaderTitle:@"Albums"];
    [self.headerView.editBtn setAlpha:1];
    [self.headerView.editBtn setUserInteractionEnabled:true];
    [self.albumTableView deselectRowAtIndexPath:self.albumTableView.indexPathForSelectedRow animated:false];
    //If the text view of a Page view is currently being edited, then it is resigned in the following line.
    [self.journalView endEditing:YES];
    //The scroll VC's scroll view is now scrollable.
    [self.delegate enableSuperScroll];
    
    
}
//MARK: Edit action
-(void)editAction{
    //This function overrides the TMViewController function of editAction, called when the editButton is clicked. 
    [super editAction];
    //If the edit button displays 'Edit' then it is changed to 'Done' and the add button appears.
    if ([self.headerView.editBtn.titleLabel.text isEqualToString:@"Edit"]){
        [self changeCustomHeaderStyle:Add];
        self.albumTableView.isEditable = YES;
        //The super scroll is disabled and the album view is now editable.
        [self.delegate disableSuperScroll];
        [self.headerView.editBtn setTitle: @"Done"forState:UIControlStateNormal];
    }else{
        //Otherwise, the edit button changes to 'Edit' and the add button disappears.
        [self changeCustomHeaderStyle:None];
        //The super scroll is enabled and the album view is no longer editable.
        self.albumTableView.isEditable = NO;
        [self.delegate enableSuperScroll];
        [self.headerView.editBtn setTitle: @"Edit"forState:UIControlStateNormal];
    }
    
    
}
//MARK: Add action

-(void)addAction{
    [super addAction];
    //The add button triggers an alert controller to appear. This will prompt a user to create a new album
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"New Album"
                                  message:@"Name your new album"
                                  preferredStyle:UIAlertControllerStyleAlert];
    //This action will appear as a button at the bottom of the controller. It saves the new album and dismisses the alert controller.
    UIAlertAction* save = [UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     //This is a function for creating a new album using the text.
                                                     if (alert.textFields.firstObject.text.length != 0) {
                                                         [self createAlbumWithName:alert.textFields.firstObject.text];
                                                         [alert dismissViewControllerAnimated:true completion:nil];
                                                     }
                                                 }];
    //This action will appear as a button at the buttom of the controller. It dismisses the album and the alert controller.
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                                   }];
    
    
    [alert addAction:cancel];
    [alert addAction:save];
    //The preferred action refers to the one which will appear as bold.
    alert.preferredAction = save;
    //This adds a text field with the place holder.
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Name";
    }];
    //The alert controller is presented.
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)createAlbumWithName: (NSString*)name{
    //This function uses the text string as a name of a new album, before saving it and updating the app.
    Album *newAlbum = [[Album alloc]init:name];
    [self.albums addObject:newAlbum];
    [self saveAlbums:self.albums];
    [self.delegate albumsUpdateFromAlbumVC];
    self.albumTableView.albums = self.albums;
    [self.albumTableView reloadData];
}



//MARK: - Delegates
//MARK: Album Table View Delegate
-(void)didSelectAlbumAtPath:(NSIndexPath *)indexPath{
    
    //This function is called as a delegate function from the Album Table View, it uses the index of the table to select the index in the album collection to display the correct memories in the journal view.
    
    //The album is identified
    Album *album = self.albums[indexPath.row];
    
    //If the memories contained within the selected album are different to the memories within the journal View, then the journal view needs to be reloaded.
    if (album.memories != self.journalView.memories){
        
        //The page scroll view's constraints are removed before the view itself is removed from the journal view, including all the page views contained.
        //There is also a loop to remove all the other subviews.
        [self.journalView.pageScrollView removeConstraints:self.journalView.pageScrollView.constraints];
        [self.journalView.pageScrollView removeFromSuperview];
        [self.journalView removeConstraints:self.journalView.constraints];
        for (int i = 0; i<self.journalView.subviews.count; i++) {
            [self.journalView.subviews[i] removeFromSuperview];
        }
        //Then, the common init reloads the new pages.
        [self.journalView commonInit:album.memories];
    }
    //The page scroll view in the journal view  is positioned to the first page (first memory).
    [self.journalView.pageScrollView setContentOffset:CGPointMake(0, self.journalView.pageScrollView.contentOffset.y) animated:true];
    //The scroll view is positioned to show the journal view.
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width, self.scrollView.contentOffset.y) animated:true];
    [self changeCustomHeaderStyle:Back];
    //The edit button is hidden when the journal view is shown.
    [self.headerView.editBtn setAlpha:0];
    [self.headerView.editBtn setUserInteractionEnabled:false];
    //The scroll from Scroll VC is disabled.
    [self.delegate disableSuperScroll];
    //The title shown when Journal View is displayed is the selected album name.
    [self setCustomHeaderTitle:album.albumName];
    
}

-(void)didDeleteAlbumAtPath:(NSIndexPath *)indexPath{
    //When an album is deleted, the albums are updated across the app.
    [self.albums removeObjectAtIndex:indexPath.row];
    [self saveAlbums:self.albums];
    [self.albumTableView reloadData];
    [self.delegate albumsUpdateFromAlbumVC];
    
}

//MARK: Journal View Delegate

-(void)memoryCaptionWasChanged:(Memory *)memory andCaption:(NSString *)caption{
    //This function has the task of changing the caption of a given Memory
    //Since a Memory can exist in multiple albums, the memory has to be altered within each
    for (int i =0; i<self.albums.count; i++) {
        //This next line calls a custom function which checks if the album contains the Memory
        if ([self album:self.albums[i] containsMemory:memory]) {
            //The album is identified
            Album *album = self.albums[i];
            //The index of the Memory within the album is identified.
            int index = [self album:album getIndexOfMemory:memory];
            //The caption is assigned to the Memory's caption
            memory.caption = caption;
            //The memory is replaced in the album
            album.memories[index] = memory;
            //The album is replaced in the albums
            self.albums[i] = album;
        }
    }
    [self saveAlbums:self.albums];
    [self.delegate albumsUpdateFromAlbumVC];
    
}


@end
