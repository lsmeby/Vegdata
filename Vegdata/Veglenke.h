//
//  Veglenke.h
//  Vegdata
//
//  Created by Henrik Hermansen on 05.03.13.
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

#import <Foundation/Foundation.h>
#import "Vegobjekt.h"

@interface Veglenke : NSObject <VegobjektProtokoll>

- (id) initMedId:(NSNumber *)aId Fra:(NSDecimalNumber *)aFra Til:(NSDecimalNumber *)aTil OgRetning:(NSString *)aRetning;

@property (nonatomic, strong) NSNumber * lenkeId;
@property (nonatomic, strong) NSDecimalNumber * fra;
@property (nonatomic, strong) NSDecimalNumber * til;
@property (nonatomic, strong) NSString * retning;

@end