//
//  GoogleMapsAvstand.h
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

#import <Foundation/Foundation.h>

@interface GoogleMapsAvstand : NSObject
@property (nonatomic, strong) NSString * status;
@property (nonatomic, strong) NSArray * rader;
+ (RKObjectMapping *)mapping;
@end

@interface Rad : NSObject
@property (nonatomic, strong) NSArray * elementer;
@end

@class Avstand;
@interface Element : NSObject
@property (nonatomic, strong) Avstand * avstand;
@end

@interface Avstand : NSObject
@property (nonatomic, strong) NSString * tekst;
@property (nonatomic, strong) NSNumber * verdi;
@end