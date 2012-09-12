//
//  SubjectListController.h
//  FlashCards
//
//  Created by Raul Chacon on 12/2/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 * SubjectListController:
 * Table view controller for Subjects view which lists all subjects in database.
 */


@class DatabaseModel;
@class SubjectsModel;
@class FlashCardListController;

@interface SubjectListController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *subjects;
@property (nonatomic, strong) DatabaseModel *databaseModel;
@property (nonatomic, strong) FlashCardListController *flashCardListController;

// Edit button which allow for insert and update to subjects db table
- (IBAction) editButtonPressed:(id)sender;

@end
