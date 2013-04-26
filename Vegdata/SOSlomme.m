//
//  SOSlomme.m
//  Vegdata
//
//  Created by Lars Smeby on 21.04.13.
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

#import "SOSlomme.h"
#import "SokResultater.h"
#import "Sok.h"

@implementation SOSlomme

+(RKObjectMapping *)mapping
{
    return [self standardMappingMedKontainerKlasse:[SOSlommer class]];
}

+(NSArray *)filtere
{
    return [[NSArray alloc]
            initWithObjects:[[Filter alloc]
                             initMedType:SOSLOMME_FILTER_TYPE
                             FilterOperator:FILTER_LIK
                             OgVerdier:[[NSArray alloc] initWithObjects:SOSLOMME_FILTER_HAVARI, nil]],
            nil];
}

+(NSString *)key
{
    return SOSLOMME_KEY;
}

+(NSNumber *)idNr
{
    return [[NSNumber alloc] initWithInt:SOSLOMME_ID];
}

+(BOOL)objektSkalVises
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:SOSLOMME_BRUKERPREF];
}

@end
