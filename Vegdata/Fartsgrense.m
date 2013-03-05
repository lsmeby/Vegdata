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
#import "Vegreferanse.h"
#import "Egenskap.h"
#import "NVDB_DataProvider.h"

static NSString * const URI = @"/vegobjekter/105";
static NSString * const KEYPATH = @"vegObjekter";

@interface Fartsgrense()
- (NSString *)hentFartFraEgenskaper;
@end

@implementation Fartsgrense

@synthesize fart, strekningsLengde, egenskaper;

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
    RKObjectMapping * egenskapsMapping = [RKObjectMapping mappingForClass:[Egenskap class]];
    [egenskapsMapping addAttributeMappingsFromDictionary:@{@"navn" : @"navn",
                                                           @"verdi" : @"verdi"}];
    
    RKObjectMapping * fartsgrenseMapping = [RKObjectMapping mappingForClass:[self class]];
    [fartsgrenseMapping addAttributeMappingsFromDictionary:@{@"strekningslengde" : @"strekningsLengde"}];
    [fartsgrenseMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"egenskaper"
                                                                                       toKeyPath:@"egenskaper"
                                                                                     withMapping:egenskapsMapping]];
    
    return fartsgrenseMapping;
}

+ (NSString *)getURI
{
    return URI;
}

+ (NSString *)getKeyPath
{
    return KEYPATH;
}

@end
