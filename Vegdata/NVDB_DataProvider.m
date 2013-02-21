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
{
    NVDB_RESTkit * restkit;
}

- (id)init
{
    restkit = [NVDB_RESTkit alloc];
    return self;
}

- (void)hentVegreferanseMedBreddegrad:(NSDecimalNumber *)breddegrad Lengdegrad:(NSDecimalNumber *)lengdegrad OgAvsender:(NSObject *)avsender
{
    restkit.delegate = avsender;
    [restkit hentDataMedURI:[Vegreferanse getURI]
                 Parametere:[Vegreferanse parametereForVegreferanseMedBreddegrad:breddegrad
                                                                    OgLengdegrad:lengdegrad]
                    Mapping:[Vegreferanse mappingForVegreferanse]
                  OgkeyPath:[Vegreferanse getKeyPath]];
}

@end
