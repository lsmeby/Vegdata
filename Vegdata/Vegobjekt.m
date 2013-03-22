//
//  Vegobjekt.m
//  Vegdata
//
//  Created by Lars Smeby on 18.03.13.
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

#import "Vegobjekt.h"
#import "Veglenke.h"
#import "Egenskap.h"
#import "SokResultater.h"

@implementation Vegobjekt

+ (RKObjectMapping *) standardMappingMedKontainerKlasse:(Class)kontainerklasse
{
    if(![kontainerklasse isSubclassOfClass:[SokResultater class]])
        return nil;
    
    RKObjectMapping * hoydebegrensningMapping = [RKObjectMapping mappingForClass:[self class]];
    
    if([[self class] isSubclassOfClass:[LinjeObjekt class]])
        [hoydebegrensningMapping addAttributeMappingsFromDictionary:@{@"strekningslengde" : @"strekningsLengde"}];
    
    [hoydebegrensningMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"lokasjon.veglenker"
                                                                                            toKeyPath:@"veglenker"
                                                                                          withMapping:[Veglenke mapping]]];
    [hoydebegrensningMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"egenskaper"
                                                                                            toKeyPath:@"egenskaper"
                                                                                          withMapping:[Egenskap mapping]]];
    
    RKObjectMapping * hoydebegrensningArrayMapping = [RKObjectMapping mappingForClass:kontainerklasse];
    [hoydebegrensningArrayMapping addPropertyMapping:[RKRelationshipMapping
                                                      relationshipMappingFromKeyPath:@"vegObjekter"
                                                      toKeyPath:@"objekter"
                                                      withMapping:hoydebegrensningMapping]];
    
    return hoydebegrensningArrayMapping;
}

@end

@implementation LinjeObjekt
@end

@implementation PunktObjekt
@end
