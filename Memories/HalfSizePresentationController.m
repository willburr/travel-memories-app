//
//  HalfSizePresentationController.m
//  Memories
//
//  Created by William Burr on 07/03/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import "HalfSizePresentationController.h"

@implementation HalfSizePresentationController

-(CGRect)frameOfPresentedViewInContainerView{
    return CGRectMake(0, self.containerView.bounds.size.height/2, self.containerView.bounds.size.width, self.containerView.bounds.size.height/2);
}

@end
