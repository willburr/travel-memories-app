//
//  PageView.m
//  Memories
//
//  Created by William Burr on 03/03/2017.
//  Copyright © 2017 William Burr. All rights reserved.
//

#import "PageView.h"


@implementation PageView

//MARK: - Initialisation

-(instancetype)initWithMemory: (Memory*) memory {
    self = [super init];
    self.screenSize = [[UIScreen mainScreen]bounds].size;
    self.memory = memory;
    self.backgroundColor = [UIColor clearColor];
    [self setUpMemory];
    return self;
}
//MARK: - Memory display

//MARK: Set up

-(void)setUpMemory{
    //Below, the keyboard notification targets are set. This is part of managing the views when the keyboard appears.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    //The caption text view is set with the current caption
    self.captionTextView = [[UITextView alloc]init];
    self.captionTextView.translatesAutoresizingMaskIntoConstraints = false;
    self.captionTextView.text = self.memory.caption;
    self.captionTextView.textColor = [UIColor blackColor];
    self.captionTextView.delegate = self;
    [self.captionTextView setScrollEnabled:false];
    self.captionTextView.font = [UIFont fontWithName:@"Noteworthy" size:self.screenSize.height*0.0352];
    [self.captionTextView setEditable:true];
    self.captionTextView.backgroundColor = [UIColor clearColor];
    self.captionTextView.textAlignment = NSTextAlignmentLeft;
    self.captionTextView.returnKeyType = UIReturnKeyDone;
    self.captionTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    [self addSubview:self.captionTextView];
    
    //The date label is set with the date of the Memory and an underline
    self.dateLabel = [[UILabel alloc]init];
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:self.memory.dateTaken];
    [attributeString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:(NSRange){0,[attributeString length]}];
    self.dateLabel.translatesAutoresizingMaskIntoConstraints = false;
    self.dateLabel.attributedText = attributeString;
    self.dateLabel.textColor = [UIColor blackColor];
    self.dateLabel.font = [UIFont fontWithName:@"Noteworthy" size:self.screenSize.height*0.0352];
    self.dateLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:self.dateLabel];
    
    //The image view is set up with the image of the Memory
    self.imageView = [[UIImageView alloc]init];
    self.imageView.image = self.memory.photo;
    self.imageView.translatesAutoresizingMaskIntoConstraints = false;
    self.imageView.layer.borderColor = [self.memory.frameColour CGColor];
    self.imageView.layer.borderWidth = self.screenSize.height*0.014;
    [self addSubview:self.imageView];
    
    //The map view is set up with the centre coordinate and plot of the Memory's location
    self.mapView = [[MGLMapView alloc]initWithFrame:CGRectMake(1, 1, 1, 1)];
    self.mapView.translatesAutoresizingMaskIntoConstraints = false;
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(self.memory.location.coordinate.latitude, self.memory.location.coordinate.longitude)];
    MGLPointAnnotation *annotation = [[MGLPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(self.memory.location.coordinate.latitude, self.memory.location.coordinate.longitude);
    [self.mapView addAnnotation:annotation];
    [self.mapView setUserInteractionEnabled:false];
    [self.mapView setZoomLevel:4];
    [self addSubview:self.mapView];
    
    //The view tap is so that the keyboard can be dismissed using a tap
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(offPress)];
    viewTap.delegate = self;
    [self addGestureRecognizer:viewTap];
    [self setUserInteractionEnabled:true];

    
    [self layoutMemory];
     
}

//MARK: Layout
-(void)layoutMemory{
    
    NSDictionary *views = @{@"captionTextView":self.captionTextView, @"dateLabel":self.dateLabel, @"imageView":self.imageView, @"mapView":self.mapView};
    NSDictionary *metrics = @{@"dateHeight":@(self.screenSize.height*0.044), @"imageTopGap":@(self.screenSize.height*0.0704), @"captionHeight":@(self.screenSize.height*0.211), @"captionWidth": @(self.screenSize.width*0.56), @"mapWidth":@(self.screenSize.height*0.176)};
    
    //Date Label - positioned in the top right corner.
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-5-[dateLabel(dateHeight)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[dateLabel]-10-|" options:0 metrics:metrics views:views]];
    
    //Image View - positioned by default in the centre X, just below the date label.
    
    //Constraints can be changed to alter position of the image view.
    self.imageCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    self.imageHConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeLeft multiplier:1 constant:self.screenSize.height*0.352];
    
    self.imageVConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeTop multiplier:1 constant:self.screenSize.height*0.352];
    
    [self addConstraint:self.imageHConstraint];
    [self addConstraint:self.imageVConstraint];
    [self addConstraint:self.imageCenterXConstraint];
    
    self.captionYConstraintValue = -self.screenSize.height*0.088;
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(imageTopGap)-[imageView]" options:0 metrics:metrics views:views]];

    //Caption - positioned left of centre, just above the bottom of the view.
    //Constraint can be changed to shift it upwards.
    
    self.captionYConstraint = [NSLayoutConstraint constraintWithItem:self.captionTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:self.captionYConstraintValue];
    
    [self addConstraint:self.captionYConstraint];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[captionTextView(captionHeight)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[captionTextView(captionWidth)]" options:0 metrics:metrics views:views]];
   
    //Map View - positioned right of centre, just above the bottom of the view.
    
    self.mapYConstraint = [NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:self.captionYConstraintValue];
    [self addConstraint:self.mapYConstraint];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[mapView(mapWidth)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[mapView(mapWidth)]-(dateHeight)-|" options:0 metrics:metrics views:views]];
    
    
    [self layoutIfNeeded];

}

//MARK: - Keyboard manager

-(void)keyboardWillShow{
    // When the keyboard shows, the constraints are altered so the image view shifts right, and the caption text view shifts upwards.
    self.captionYConstraintValue = -self.screenSize.height*0.493;
    self.captionYConstraint.constant = self.captionYConstraintValue;
    self.imageHConstraint.constant = self.screenSize.height*0.211;
    self.imageVConstraint.constant = self.screenSize.height*0.211;
    self.imageCenterXConstraint.constant = self.screenSize.height*0.141;
    self.imageView.layer.borderWidth = self.screenSize.height*0.0088;
    //The changes occur simultaneously via animation.
    [UIView animateWithDuration:0.7 animations:^(void){
        [self layoutIfNeeded];
    }];
}

-(void)keyboardWillHide{
    // When the keyboard hides, the constraints are altered so the image view shifts left, and the caption text view shifts downwards.
    self.captionYConstraintValue = -self.screenSize.height*0.088;
    self.captionYConstraint.constant = self.captionYConstraintValue;
    self.imageHConstraint.constant = self.screenSize.height*0.352;
    self.imageVConstraint.constant = self.screenSize.height*0.352;
    self.imageCenterXConstraint.constant = 0;
    self.imageView.layer.borderWidth = self.screenSize.height*0.0141;
    //The changes occur simultaneously via animation.
    [UIView animateWithDuration:0.7 animations:^(void){
        [self layoutIfNeeded];
    }];
}

//MARK: Text View Management

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    BOOL shouldChange = true;
    //This function is needed to execute when the 'Done' button is pressed, this acts as a return key and so the change of text is effective "\n". Therefore, when 'Done' is pressed, the text view resigns.
    //The function only dismisses the text view if there is text.
    if ([text  isEqual: @"\n"]&[textView hasText]) {
        [textView resignFirstResponder];
        if (![self.memory.caption isEqualToString:self.captionTextView.text]){
            [self.delegate memoryCaptionWasChanged:self.memory andCaption:self.captionTextView.text];
            self.memory.caption = self.captionTextView.text;
        }
        
    }else if ((textView.text.length*text.length)>40){
        //If there is too much text, it cannot be added.
        shouldChange = false;
    }
    return shouldChange;
}

-(void)offPress{
    if ([self.captionTextView hasText]) {
        //This is the function called by the tap gesture recognizer, when clicked the caption view resigns first responder.
        [self.captionTextView resignFirstResponder];
        if (![self.memory.caption isEqualToString:self.captionTextView.text]){
            [self.delegate memoryCaptionWasChanged:self.memory andCaption:self.captionTextView.text];
            self.memory.caption = self.captionTextView.text;
        }
    }
}


@end
