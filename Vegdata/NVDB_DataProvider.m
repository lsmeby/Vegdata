//
//  NVDB_DataProvider.m
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

#import "NVDB_DataProvider.h"
#import "NVDB_RESTkit.h"
#import "Vegreferanse.h"

@implementation NVDB_DataProvider

+ (Vegreferanse *)hentVegreferanseMedBreddegrad:(NSDecimalNumber *)breddegrad OgLengdegrad:(NSDecimalNumber *)lengdegrad
{
    NSArray * returarray = [NVDB_RESTkit hentDataMedURI:[Vegreferanse getURI]
                                             Parametere:[Vegreferanse parametereForVegreferanseMedBreddegrad:breddegrad
                                                                                                OgLengdegrad:lengdegrad]
                                                Mapping:[Vegreferanse mappingForVegreferanse]
                                              OgKeyPath:[Vegreferanse getKeyPath]];
    
    if(returarray == nil || [returarray count] == 0)
        return nil;
    
    return [returarray objectAtIndex:0];
}

@end
