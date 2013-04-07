//
//  Fartsdemper.m
//  Vegdata
//
//  Created by Lars Smeby on 21.03.13.
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

#import "Fartsdemper.h"
#import "Egenskap.h"
#import "SokResultater.h"

@implementation Fartsdemper

@synthesize egenskaper, veglenker, lokasjon;

-(NSString *)hentTypeFraEgenskaper
{
    for (Egenskap * e in egenskaper)
    {
        if([e.navn isEqualToString:@"Type"])
        {
            return e.verdi;
        }
    }
    return @"Ingen type";
}

+(RKObjectMapping *)mapping
{
    return [self standardMappingMedKontainerKlasse:[Fartsdempere class]];
}

@end
