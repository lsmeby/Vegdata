//
//  Jernbanekryssing.m
//  Vegdata
//
//  Created by Lars Smeby on 20.03.13.
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

#import "Jernbanekryssing.h"
#import "SokResultater.h"
#import "Egenskap.h"
#import "Sok.h"

@implementation Jernbanekryssing

@synthesize egenskaper, veglenker, lokasjon;

+(RKObjectMapping *)mapping
{
    return [self standardMappingMedKontainerKlasse:[Jernbanekryssinger class]];
}

+(NSArray *)filtere
{
    return [[NSArray alloc]
            initWithObjects:[[Filter alloc]
                             initMedType:JERNBANEKRYSSING_TYPE_KEY
                             FilterOperator:FILTER_ULIK
                             OgVerdier:[[NSArray alloc] initWithObjects:JERNBANEKRYSSING_FILTER_OVER, JERNBANEKRYSSING_FILTER_UNDER, nil]],
            nil];
}

@end
