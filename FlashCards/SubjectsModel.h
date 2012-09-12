//
//  SubjectsModel.h
//  FlashCards
//
//  Created by Raul Chacon on 12/2/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 * Subjects Model:
 * each property corresponds to a column in the subjects database table.
 */

@interface SubjectsModel : NSObject

@property (nonatomic, assign) int iD;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) int isHidden;
@property (nonatomic, strong) NSString *insertDate;

// initialize a new subject model
- (id) initWithId: (int) aId title: (NSString *) aTitle isHidden: (int) isHiddenBit insertDate: (NSString *) aInsertDate;

@end
