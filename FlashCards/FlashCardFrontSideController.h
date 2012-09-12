//
//  FlashCardFrontSideController.h
//  FlashCards
//
//  Created by Raul Chacon on 12/4/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FlashCardFrontSideController;
@class FlashCardBackSideController;
@class FlashCardListController;
@class DatabaseModel;
@class FlashCardModel;
@class WebViewController;

/*
 * FlashCardFrontSideController:
 * view controller for front side of flash card.
 */


@interface FlashCardFrontSideController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UILabel *frontSideLabel;
@property (nonatomic, strong) NSMutableString *stringForFrontSideToPassToBackSide;
@property (nonatomic, strong) NSMutableString *subjectTitleFromFlashCardList;
@property (nonatomic, strong) NSMutableArray *flashCards;
@property (nonatomic, assign) int flashCardPosition;
@property (nonatomic, strong) DatabaseModel *databaseModel;
@property (nonatomic, strong) FlashCardBackSideController *backSideController;
@property (nonatomic, strong) FlashCardListController *listView;


@end
