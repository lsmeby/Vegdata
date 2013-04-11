//
//  GoogleMapsAvstand.m
//  Vegdata
//
//  Created by Lars Smeby on 07.04.13.
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

#import "MapQuestRoute.h"

@implementation MapQuestRoute

@synthesize status, avstand;

+ (RKObjectMapping *)mapping
{
    RKObjectMapping * mapQuestMapping = [RKObjectMapping mappingForClass:[self class]];
    [mapQuestMapping addAttributeMappingsFromDictionary:@{@"distance" : @"avstand", @"info.statuscode" : @"status"}];
    
    return mapQuestMapping;
}

@end
