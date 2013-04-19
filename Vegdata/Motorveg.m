//
//  Motorveg.m
//  Vegdata
//
//  Created by Lars Smeby on 11.04.13.
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

#import "Motorveg.h"
#import "Egenskap.h"
#import "SokResultater.h"

@implementation Motorveg

@synthesize egenskaper, veglenker, strekningsLengde;

- (NSString *)hentTypeFraEgenskaper
{
    for (Egenskap * e in egenskaper)
    {
        if([e.navn isEqualToString:MOTORVEG_TYPE_KEY])
        {
            return e.verdi;
        }
    }
    return INGEN_OBJEKTER;
}

+ (RKObjectMapping *)mapping
{
    return [self standardMappingMedKontainerKlasse:[Motorveger class]];
}

+(NSArray *)filtere
{
    return nil;
}

+ (NSNumber *)idNr
{
    return [[NSNumber alloc] initWithInt:MOTORVEG_ID];
}

+ (NSString *)key
{
    return MOTORVEG_KEY;
}

@end
