//
//  FlashCardBackSideController.h
//  FlashCards
//
//  Created by Raul Chacon on 12/4/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlashCardFrontSideController;

/*
 * FlashCardBackSideController:
 * view controller for back side of flash card
 */

@interface FlashCardBackSideController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *backSideLabel;
@property (nonatomic, strong) NSMutableString *backSideString;

@end
