//
//  VegObjektController.h
//  Vegdata
//
//  Created by Lars Smeby on 05.03.13.
//
//  Copyright (C) 2013  Henrik Hermansen og Lars Smeby
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import <Foundation/Foundation.h>
#import "NVDB_RESTkit.h"

@class NVDB_DataProvider, Vegreferanse, Avstand;

@protocol VegObjektDelegate
@required
- (void)vegObjekterErOppdatert:(NSDictionary *)data;
- (void)avstandTilPunktobjekt:(NSDecimalNumber *)avstand MedKey:(NSString *)key;
@end

@interface VegObjektKontroller : NSObject <NVDBResponseDelegate>
{
    NVDB_DataProvider * dataProv;
}

typedef enum { UKJENT, STIGENDE, SYNKENDE } Retning;

@property (nonatomic, assign) id delegate;
@property (nonatomic, strong) Vegreferanse * vegRef;
@property (nonatomic, strong) NSDecimalNumber * forrigePosisjon;
@property (nonatomic) Retning forrigeRetning;
@property (nonatomic, strong) NSNumber * gjettetVeglenkeID;
@property (nonatomic, strong) NSNumber * forrigeNyeVeglenkeID;
@property (nonatomic, strong) NSArray * objektreferanse;

- (id)initMedDelegate:(id)delegat OgManagedObjectContext:(NSManagedObjectContext *)context;
- (void)oppdaterMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad;

@end
