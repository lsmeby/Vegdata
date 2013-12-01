//
//  ATKstrekning.m
//  Vegdata
//
//  Created by Lars Smeby on 01.12.13.
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

#import "ATKstrekning.h"
#import "SokResultater.h"

@implementation ATKstrekning

+ (RKObjectMapping *)mapping
{
    return [self standardMappingMedKontainerKlasse:[ATKstrekninger class]];
}

+ (NSArray *)filtere
{
    return nil;
}

+ (NSNumber *)idNr
{
    return [[NSNumber alloc] initWithInt:ATKSTREKNING_ID];
}

+ (NSString *)key
{
    return ATKSTREKNING_KEY;
}

+ (BOOL)objektSkalVises
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:ATKSTREKNING_BRUKERPREF];
}

@end
