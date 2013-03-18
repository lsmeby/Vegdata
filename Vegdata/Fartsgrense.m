//
//  Fartsgrense.m
//  Vegdata
//
//  Created by Lars Smeby on 20.02.13.
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

#import "Fartsgrense.h"
#import "Egenskap.h"
#import "Veglenke.h"
#import "SokResultater.h"

@implementation Fartsgrense

@synthesize strekningsLengde, egenskaper, veglenker;

- (NSString *)hentFartFraEgenskaper
{
    for (Egenskap * e in egenskaper)
    {
        if([e.navn isEqualToString:@"Fartsgrense"])
        {
            return e.verdi;
        }
    }
    return @"-1";
}

#pragma mark - Statiske hjelpemetoder

+ (RKObjectMapping *)mapping
{
    RKObjectMapping * fartsgrenseMapping = [RKObjectMapping mappingForClass:[self class]];
    [fartsgrenseMapping addAttributeMappingsFromDictionary:@{@"strekningslengde" : @"strekningsLengde"}];
    [fartsgrenseMapping addPropertyMapping:[RKRelationshipMapping
                                             relationshipMappingFromKeyPath:@"lokasjon.veglenker"
                                             toKeyPath:@"veglenker"
                                             withMapping:[Veglenke mapping]]];
    [fartsgrenseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"egenskaper"
                                                                                       toKeyPath:@"egenskaper"
                                                                                     withMapping:[Egenskap mapping]]];
    
    RKObjectMapping * fartsgrenseArrayMapping = [RKObjectMapping mappingForClass:[Fartsgrenser class]];
    [fartsgrenseArrayMapping addPropertyMapping:[RKRelationshipMapping
                                                 relationshipMappingFromKeyPath:@"vegObjekter"
                                                                      toKeyPath:@"objekter"
                                                                    withMapping:fartsgrenseMapping]];
    
    return fartsgrenseArrayMapping;
}
@end
