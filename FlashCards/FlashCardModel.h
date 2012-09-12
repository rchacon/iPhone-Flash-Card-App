//
//  FlashCardModel.h
//  FlashCards
//
//  Created by Raul Chacon on 12/2/11.
//  Copyright (c) 2011 Student. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 * Flash Card Model:
 * each property corresponds to a column in the flash cards database table.
 */

@interface FlashCardModel : NSObject

@property (nonatomic, assign) int primaryKey;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *definition;
@property (nonatomic, assign) int isHidden;
@property (nonatomic, strong) NSString *insertDate;

// initialize a new flash card model
- (id) initWithId: (int) aId title: (NSString *) aTitle definition: (NSString *) aDefinition isHidden: (int) isHiddenBit insertDate: (NSString *) aInsertDate;

// help prevent name space clash warning
- (NSString *) getDefinition;

@end
