//
//  DatabaseModel.h
//  FlashCards
//
//  Created by Raul Chacon on 12/2/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
@class SubjectsModel;
@class FlashCardModel;

/*
 * Database Model
 * sqlite file is created from here. all selects, inserts and updates are performed
 * from within this class
*/

@interface DatabaseModel : NSObject
{
    sqlite3 *dbHandle;
    NSString *dbName;
    NSMutableArray *subjects;
    NSMutableArray *flashCards;
    SubjectsModel *subjectsModel;
}
// initializers
- (id)init;
- (void) createDB;

// selects
- (NSMutableArray*) selectAllFromSubjectsWhereIsHidden: (int) isHidden;
- (NSMutableArray*) selectAllFromFlashCardsWhereIsHidden: (int)isHidden;
- (NSMutableArray*) selectAllFromFlashCardsWhereIsHidden:(int)isHidden subjectId: (int)subjectId;
- (int) selectIdFromFlashCardsWhere:(NSString *)flashCardTitle;
- (int) selectIdFromSubjectsWhere:(NSString *)subjectTitle;

// inserts
- (BOOL) insertSubjectIntoSubjects: (NSString *)title;
- (BOOL) insertFlashCardIntoFlashCards: (NSString *)title definition: (NSString *) definition;
- (BOOL) insertFlashCardSubjectIntoFlashCardSubjects: (int)flashCardId subjectId: (int) subjectId;

// updates
- (BOOL) updateFlashCardsIsHidden:(int)bit flashCard:(NSString *)flashCard;
- (BOOL) updateSubjectsIsHidden:(int)bit subject:(NSString *)title;

@end
