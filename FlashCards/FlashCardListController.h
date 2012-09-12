//
//  FlashCardListController.h
//  FlashCards
//
//  Created by Raul Chacon on 12/2/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DatabaseModel;
@class AddFlashCardController;
@class FlashCardModel;

/*
 * FlashCardListController:
 * table view controller that displays all flash cards for a given subject.
 */


@interface FlashCardListController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *flashCards;
@property (nonatomic, strong) DatabaseModel *databaseModel;
@property (nonatomic, strong) NSMutableString *parentSubjectTitle; // given subject
@property (nonatomic, assign) int needsRefresh;

// Edit button which allow for insert and update to flash card db table
- (IBAction) editButtonPressed:(id)sender;

@end
