//
//  MemoryCreatorView.m
//  Memories
//
//  Created by User on 13/02/2017.
//  Copyright © 2017 User. All rights reserved.
//

#import "MemoryCreatorView.h"

@implementation MemoryCreatorView


//MARK: - Initialise

-(void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    self.screenSize = [[UIScreen mainScreen]bounds].size;
    self.captionYConstraintValue = -self.screenSize.height*0.158;
    self.imageConstant = self.screenSize.height*0.352;
    //The items of the Memory Creator View are set up.
    [self setUpItems];
}

//MARK: - Keyboard management

-(void)keyboardWillShow {
    //When the keyboard appears, the caption text view shifts upwards, the image view shrinks.
    self.captionYConstraintValue = -self.screenSize.height*0.317;
    self.captionYConstraint.constant = self.captionYConstraintValue;
    
    self.imageConstant = self.screenSize.height*0.211;
    self.imageHConstraint.constant = self.imageConstant;
    self.imageVConstraint.constant = self.imageConstant;
    self.imageView.layer.borderWidth = self.screenSize.height*0.0088;
    //The changes occur simultaneously within an animation.
    [UIView animateWithDuration:0.7 animations:^(void){
        [self layoutIfNeeded];
    }];
}

-(void)keyboardWillHide {
    //When the keyboard appears, the caption text view shifts downwards, the image view grows.
    self.captionYConstraintValue = -self.screenSize.height*0.158;
    self.captionYConstraint.constant = self.captionYConstraintValue;
    
    self.imageConstant = self.screenSize.height*0.352;
    self.imageHConstraint.constant = self.imageConstant;
    self.imageVConstraint.constant = self.imageConstant;
    self.imageView.layer.borderWidth = self.screenSize.height*0.014;
    //The changes occur simultaneously within an animation.
    [UIView animateWithDuration:0.7 animations:^(void){
        [self layoutIfNeeded];
    }];
}



//MARK: - Items

-(void)setUpItems {
    
    //The keyboard notifications are set with targets so that the relevant functions are called.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
    //The image view is set up.
    self.imageView = [[UIImageView alloc]init];
    self.imageView.translatesAutoresizingMaskIntoConstraints = false;
    self.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView.layer.borderWidth = self.screenSize.height*0.014;
    [self addSubview:self.imageView];
    
    //The colour button is set up.
    self.colourButton = [[UIButton alloc]init];
    self.colourButton.translatesAutoresizingMaskIntoConstraints = false;
    self.colourButton.backgroundColor = [UIColor whiteColor];
    self.colourButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.colourButton.layer.borderWidth = 2;
    self.colourButton.layer.cornerRadius = 5;
    [self.colourButton addTarget:self action:@selector(colourButtonPress) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: self.colourButton];
    
    //The caption text view is set up..
    self.captionTextView = [[UITextView alloc]init];
    self.captionTextView.translatesAutoresizingMaskIntoConstraints = false;
    self.captionTextView.delegate = self;
    self.captionTextView.text = @"Add a caption";
    self.captionTextView.backgroundColor = [UIColor whiteColor];
    self.captionTextView.textColor = [UIColor blackColor];
    [self.captionTextView setScrollEnabled:false];
    self.captionTextView.font = [UIFont fontWithName:@"Noteworthy" size:self.screenSize.height*0.0352];
    self.captionTextView.returnKeyType = UIReturnKeyDone;
    self.captionTextView.layer.cornerRadius = 5;
    self.captionTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    
    [self addSubview:self.captionTextView];
    
    //The post button is set up.
    self.postButton = [[UIButton alloc] init];
    self.postButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.postButton setTitle:@" Post Memory " forState:UIControlStateNormal];
    self.postButton.titleLabel.font = [UIFont fontWithName:@"Noteworthy" size:self.screenSize.height*0.0352];
    [self.postButton setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];
    [self.postButton setTitleColor: [UIColor grayColor] forState:UIControlStateHighlighted];
    [self.postButton setTitleColor: [UIColor lightGrayColor] forState:UIControlStateDisabled];
    self.postButton.layer.borderColor = [[UIColor blackColor] CGColor];
    self.postButton.layer.borderWidth = 3;
    self.postButton.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.postButton];
    
    //The album button is set up.
    self.albumButton = [[UIButton alloc]init];
    self.albumButton.translatesAutoresizingMaskIntoConstraints = false;
    [self.albumButton setImage:[UIImage imageNamed:@"Add"] forState:UIControlStateNormal];
    [self.albumButton setImage:[UIImage imageNamed:@"Tick"] forState:UIControlStateDisabled];
    self.albumButton.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    self.albumButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    self.albumButton.backgroundColor = [UIColor clearColor];
    [self addSubview:self.albumButton];
    [self layoutItems];
    
    UITapGestureRecognizer *viewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(offTextViewPress)];
    //This view tap is for clicking when the keyboard is currently visible, it is designed to remove the keyboard.
    viewTap.delegate = self;
    [self addGestureRecognizer:viewTap];
    //The view tap gesture recognizer is added to the Memory Creator View
    [self setUserInteractionEnabled:true];
    

    
}

-(void)layoutItems{
    
    NSDictionary *views = @{@"imageView": self.imageView, @"captionTextView": self.captionTextView, @"postButton":self.postButton, @"albumButton":self.albumButton, @"colourButton":self.colourButton};
    
    NSDictionary *metrics = @{@"imageTopGap":@(self.screenSize.height*0.0352), @"captionHeight": @(self.screenSize.height*0.176),@"captionWidth": @(self.screenSize.height*0.458), @"postBtnHeight":@(self.screenSize.height*0.088),@"postBtnGap":@(self.screenSize.height*0.0581),@"colourBtnHeight":@(self.screenSize.height*0.0704)};
    
    
    // Image View - centre X, set height from the top
    //The constraints can be used to change the position of the image view.
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    self.imageHConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeLeft multiplier:1 constant:self.imageConstant];
    
    self.imageVConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.imageView attribute:NSLayoutAttributeTop multiplier:1 constant:self.imageConstant];
    
    [self addConstraint:self.imageHConstraint];
    [self addConstraint:self.imageVConstraint];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(imageTopGap)-[imageView]" options:0 metrics:metrics views:views]];
    
    
    //Caption Text View - centre X, positioned above the post button.
    
    
    self.captionYConstraint = [NSLayoutConstraint constraintWithItem:self.captionTextView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:self.captionYConstraintValue];
    
    
    [self addConstraint:self.captionYConstraint];
    
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[captionTextView(captionHeight)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[captionTextView(captionWidth)]" options:0 metrics:metrics views:views]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.captionTextView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    //Post Button - centre X, positioned just above the bottom.
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[postButton(postBtnHeight)]-(postBtnGap)-|" options:0 metrics:metrics views:views]];
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:[postButton(captionWidth)]" options:0 metrics:metrics views:views]];
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.postButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    //Colour Button - right of image view, same height as image view
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"H:[imageView]-10-[colourButton(colourBtnHeight)]" options:0 metrics:metrics views:views]];
    
    [self addConstraints: [NSLayoutConstraint constraintsWithVisualFormat:@"V:[colourButton(colourBtnHeight)]" options:0 metrics:metrics views:views]];
    
    [self addConstraint: [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.colourButton attribute:NSLayoutAttributeTop multiplier:1 constant:-10]];
    

    //Album Button - left of image view, same hiehgt as colour button
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(imageTopGap)-[albumButton(imageTopGap)]" options:0 metrics:metrics views:views]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(colourBtnHeight)-[albumButton(imageTopGap)]" options:0 metrics:metrics views:views]];
    
    [self layoutIfNeeded];

}

//MARK: - Button Press

//Note that the other buttons are being dealt with by the StartVC

//MARK: Colour Button

-(void)colourButtonPress {
    //The frame colour is toggled between black and white using the colour button.
    if (self.colourButton.backgroundColor == [UIColor whiteColor]){
        self.colourButton.backgroundColor = [UIColor blackColor];
        self.imageView.layer.borderColor = [[UIColor blackColor]CGColor];
    }else{
        self.colourButton.backgroundColor = [UIColor whiteColor];
        self.imageView.layer.borderColor = [[UIColor whiteColor]CGColor];
    }
    
}

//MARK: - Tap Gestures

-(void)offTextViewPress {
    [self.captionTextView resignFirstResponder];
}


//MARK: - Delegates
//MARK: Text Field Delegate

-(void)textViewDidBeginEditing:(UITextView *)textView {
    //If the place-holder text exists, then it disappears.
    if ([textView.text  isEqual: @"Add a caption"]) {
        textView.text = @"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    //If there is no text, then place-holder appears.
    if (![textView hasText]) {
        textView.text = @"Add a caption";
        [self.postButton setEnabled:false];
        self.postButton.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    }else{
        [self.postButton setEnabled:true];
        self.postButton.layer.borderColor = [[UIColor blackColor]CGColor];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    //If the return button is pressed, the text view is resigned.
    BOOL shouldChange = true;
    if ([text  isEqual: @"\n"]) {
        [textView resignFirstResponder];
    }else if((textView.text.length*text.length) > 40){
        shouldChange = false;
    }
    return shouldChange;
}


@end
