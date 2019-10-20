//
//  JournalView.m
//  Memories
//
//  Created by William Burr on 03/03/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import "JournalView.h"

@implementation JournalView

//MARK: - Initialisation

-(void)commonInit: (NSMutableArray*)memories{
    
    //A journal view uses an array of memory objects, each of which is used to instantiate a page
    self.memories = memories;
    if (self.memories.count != 0){
        [self setUpPageScrollView];
        [self setUpPageViews];
    }else{
        [self setUpInformationLabel];
    }
   
}



//MARK: - Page Scroll View
//MARK: Set up

-(void)setUpPageScrollView{
    
    //The page scroll view is used to contain all the sub pages as dictated by the memories array.
    self.pageScrollView = [[UIScrollView alloc]init];
    self.pageScrollView.translatesAutoresizingMaskIntoConstraints = false;
    self.pageScrollView.delegate = self;
    self.pageScrollView.bounces = false;
    self.pageScrollView.pagingEnabled = true;
    //It should be possible to simply scroll between the pages.
    self.pageScrollView.scrollEnabled = true;
    self.pageScrollView.showsVerticalScrollIndicator = false;
    self.pageScrollView.showsHorizontalScrollIndicator = false;
    [self addSubview:self.pageScrollView];
    
    [self layoutPageScrollView];
}

//MARK: Layout

-(void)layoutPageScrollView{
    NSDictionary *views = @{@"pageScrollView": self.pageScrollView};
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pageScrollView]|" options: NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageScrollView]|" options: NSLayoutFormatAlignAllCenterY metrics:nil views:views]];
    
    [self layoutIfNeeded];

}

//MARK: - Page Views
//MARK: Set up

-(void)setUpPageViews{
    
    //I need to declare the pageViews as a NSMutableArray in order for me to add objects to it.
    
    self.pageViews = [[NSMutableArray alloc]init];
    
    //A for-loop loops through every memory in the array, and creates a pageView for it, adding it to the page scroll view.
    
    for (int i = 0; i<self.memories.count; i++) {
        
        Memory *memory = self.memories[i];
        PageView *pageView = [[PageView alloc]initWithMemory:memory];
        pageView.delegate = self;
        pageView.translatesAutoresizingMaskIntoConstraints = false;
        [self.pageScrollView addSubview:pageView];
        [self.pageViews addObject:pageView];
        memory = nil;
        
    }
    
    [self layoutPageViews];
    
}

//MARK: Layout

-(void)layoutPageViews{
    
    //The first and last page views need to be done individually, because the first needs to be against the left edge of the page scroll view and the last needs to be against the right edge of the page scroll view. 
    
    NSDictionary *views = @{@"pageScrollView":self.pageScrollView, @"pageView":self.pageViews.firstObject};
    
    [self.pageScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[pageView(pageScrollView)]|" options:0 metrics:nil views:views]];
    [self.pageScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[pageView(pageScrollView)]" options: 0 metrics:nil views:views]];
    
    //For the page views inbetween the first and last, this for loop increments the page views and positions the current page view next to the previous page view and gives it the same width and length.
    
    for (int i = 1; i<self.memories.count-1; i++){
        NSDictionary *views = @{@"previousPageView":self.pageViews[i-1], @"currentPageView":self.pageViews[i]};
        [self.pageScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[currentPageView(previousPageView)]|" options:0 metrics:nil views:views]];
        [self.pageScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousPageView][currentPageView(previousPageView)]" options: 0 metrics:nil views:views]];
        
    }
    
    if (self.memories.count > 1){
        NSDictionary *endViews = @{@"previousPageView":self.pageViews[self.pageViews.count-2], @"currentPageView":self.pageViews.lastObject};
        [self.pageScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[currentPageView(previousPageView)]|" options:0 metrics:nil views:endViews]];
        [self.pageScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[previousPageView][currentPageView(previousPageView)]|" options:0 metrics:nil views:endViews]];
    }
    [self layoutIfNeeded];

    
}

//MARK: - Information Label
//MARK: Set up and Layout
-(void)setUpInformationLabel{
    //If there are no Memories in the Album, then this information label appears
    self.infoLabel = [[UILabel alloc]init];
    self.infoLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.infoLabel.text = @"Oops! No Memories found";
    self.infoLabel.textColor = [UIColor blackColor];
    self.infoLabel.font = [UIFont fontWithName:@"Noteworthy" size:[[UIScreen mainScreen]bounds].size.height*0.04];
    self.infoLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.infoLabel];
    //It is positioned in the centre X and centre Y. The width and height is determined by the size of the text.
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [self layoutIfNeeded];
}
//MARK: - Delegate


//MARK: Page View Delegate

-(void)memoryCaptionWasChanged:(Memory *)memory andCaption:(NSString *)caption{
    [self.delegate memoryCaptionWasChanged:memory andCaption:caption];
}


@end
