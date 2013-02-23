//
//  Posisjon.h
//  Vegdata
//
//  Created by Lars Smeby on 15.02.13.
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
#import <CoreLocation/CoreLocation.h>

@class Posisjon;

@protocol PosisjonDelegate
@required
- (void) posisjonOppdatering:(Posisjon *)posisjon;
- (void) posisjonFeil:(NSError *)feil;
@end


@interface PosisjonsKontroller : NSObject <CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager * lokMan;
@property (nonatomic, strong) NSDate * forrigeOppdatering;
@property (nonatomic, assign) id delegate;

@end


@interface Posisjon : NSObject

@property (nonatomic, strong) NSDecimalNumber * breddegrad;
@property (nonatomic, strong) NSDecimalNumber * lengdegrad;
@property (nonatomic, strong) NSDecimalNumber * hastighetIMeterISek;
@property (nonatomic, strong) NSDecimalNumber * retning;
@property (nonatomic, strong) NSDecimalNumber * meterOverHavet;
@property (nonatomic, strong) NSDecimalNumber * presisjon;

- (NSDecimalNumber *) hastighetIKmT;

@end