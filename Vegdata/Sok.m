//
//  Sok.m
//  Vegdata
//
//  Created by Henrik Hermansen on 05.03.13.
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

#import "Sok.h"

static NSString * const URI = @"/sok";
static NSString * const KEYPATH = @"resultater";

@implementation Sok

@synthesize veglenker, objektTyper;

+ (NSString *)getURI
{
    return URI;
}

+ (NSString *)getKeyPath
{
    return KEYPATH;
}

@end


@implementation Lokasjon

@synthesize veglenker;

@end


@implementation Objekttype

@synthesize typeId, antall, filtere;

- (id) initMedTypeId:(NSNumber *)aTypeId Antall:(NSNumber *)aAntall OgFiltere:(NSArray *)aFiltere
{
    self.typeId = aTypeId;
    self.antall = aAntall;
    self.filtere = aFiltere;
    
    return self;
}

@end


@implementation Filter

@synthesize type, filterOperator, verdier;

- (id) initMedType:(NSString *)aType FilterOperator:(NSString *)aFilterOperator OgVerdier:(NSArray *)aVerdier
{
    self.type = aType;
    self.filterOperator = aFilterOperator;
    self.verdier = aVerdier;
    
    return self;
}

@end