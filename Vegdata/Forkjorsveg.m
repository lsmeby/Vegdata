//
//  Forkjorsveg.m
//  Vegdata
//
//  Created by Henrik Hermansen on 08.03.13.
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

#import "Forkjorsveg.h"
#import "Veglenke.h"
#import "SokResultater.h"

@implementation Forkjorsveg

@synthesize strekningsLengde, veglenker;

#pragma mark - Statiske hjelpemetoder

+ (RKObjectMapping *)mapping
{
    RKObjectMapping * veglenkeMapping = [RKObjectMapping mappingForClass:[Veglenke class]];
    [veglenkeMapping addAttributeMappingsFromDictionary:@{@"id" : @"lenkeId",
     @"fra" : @"fra",
     @"til" : @"til",
     @"direction" : @"retning"}];
    
    RKObjectMapping * forkjorsvegMapping = [RKObjectMapping mappingForClass:[self class]];
    [forkjorsvegMapping addAttributeMappingsFromDictionary:@{@"strekningslengde" : @"strekningsLengde"}];
    [forkjorsvegMapping addPropertyMapping:[RKRelationshipMapping
                                            relationshipMappingFromKeyPath:@"lokasjon.veglenker"
                                            toKeyPath:@"veglenker"
                                            withMapping:veglenkeMapping]];
    
    RKObjectMapping * forkjorsvegArrayMapping = [RKObjectMapping mappingForClass:[Forkjorsveger class]];
    [forkjorsvegArrayMapping addPropertyMapping:[RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"vegObjekter"
                                                 toKeyPath:@"forkjorsveger"
                                                 withMapping:forkjorsvegMapping]];
    
    return forkjorsvegArrayMapping;
}
@end