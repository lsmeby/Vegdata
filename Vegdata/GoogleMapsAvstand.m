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

#import "GoogleMapsAvstand.h"

@implementation GoogleMapsAvstand

@synthesize status, rader;

+ (RKObjectMapping *)mapping
{
    RKObjectMapping * avstandsMapping = [RKObjectMapping mappingForClass:[Avstand class]];
    [avstandsMapping addAttributeMappingsFromDictionary:@{@"text" : @"tekst", @"value" : @"verdi"}];
    
    RKObjectMapping * elementMapping = [RKObjectMapping mappingForClass:[Element class]];
    [elementMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"distance"
                                                                                   toKeyPath:@"avstand"
                                                                                 withMapping:avstandsMapping]];
    
    RKObjectMapping * radMapping = [RKObjectMapping mappingForClass:[Rad class]];
    [radMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"elements"
                                                                               toKeyPath:@"elementer"
                                                                             withMapping:elementMapping]];
    
    RKObjectMapping * googleMapsMapping = [RKObjectMapping mappingForClass:[self class]];
    [googleMapsMapping addAttributeMappingsFromDictionary:@{@"status" : @"status"}];
    [googleMapsMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"rows"
                                                                                      toKeyPath:@"rader"
                                                                                    withMapping:radMapping]];
    
    return googleMapsMapping;
}

@end

@implementation Rad
@synthesize elementer;
@end

@implementation Element
@synthesize avstand;
@end

@implementation Avstand
@synthesize tekst, verdi;
@end
