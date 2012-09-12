//
//  HomePageController.h
//  FlashCards
//
//  Created by Raul Chacon on 12/14/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SubjectListController;


/*
 * HomePageController:
 * table view controller with options to go to Subjects page or About page
 */


@interface HomePageController : UITableViewController

@property (nonatomic, strong) NSMutableArray *tableOptions;

@end
