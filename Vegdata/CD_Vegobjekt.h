//
//  CD_Vegobjekt.h
//  Vegdata
//
//  Created by Lars Smeby on 07.04.13.
//  Copyright (c) 2013 gruppe8. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CD_Egenskap, CD_Veglenke, VeglenkeDBStatus;

@interface CD_Vegobjekt : NSManagedObject

@property (nonatomic, retain) NSString * lokasjon;
@property (nonatomic, retain) NSSet *egenskaper;
@property (nonatomic, retain) VeglenkeDBStatus *veglenke;
@property (nonatomic, retain) NSSet *veglenker;
@end

@interface CD_Vegobjekt (CoreDataGeneratedAccessors)

- (void)addEgenskaperObject:(CD_Egenskap *)value;
- (void)removeEgenskaperObject:(CD_Egenskap *)value;
- (void)addEgenskaper:(NSSet *)values;
- (void)removeEgenskaper:(NSSet *)values;

- (void)addVeglenkerObject:(CD_Veglenke *)value;
- (void)removeVeglenkerObject:(CD_Veglenke *)value;
- (void)addVeglenker:(NSSet *)values;
- (void)removeVeglenker:(NSSet *)values;

@end
