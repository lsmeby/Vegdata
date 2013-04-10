//
//  ViewController.h
//  Vegdata
//
//  Created by Lars Smeby on 14.02.13.
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

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import "Posisjon.h"
#import "VegObjektKontroller.h"

@interface HovedskjermViewController : UIViewController <PosisjonDelegate, VegObjektDelegate>

@property (nonatomic, strong) PosisjonsKontroller * pos;
@property (nonatomic, strong) VegObjektKontroller * vegObjKont;
@property (nonatomic, strong) NSDictionary * nyesteData;
@property (nonatomic, strong) NSMutableArray * layoutArray;

@property (nonatomic, strong) IBOutlet UIImageView * bilde1;
@property (nonatomic, strong) IBOutlet UIImageView * bilde2;
@property (nonatomic, strong) IBOutlet UIImageView * bilde3;
@property (nonatomic, strong) IBOutlet UIImageView * bilde4;
@property (nonatomic, strong) IBOutlet UIImageView * bilde5;
@property (nonatomic, strong) IBOutlet UIImageView * bilde6;
@property (nonatomic, strong) IBOutlet UIImageView * bilde7;

@property (nonatomic, strong) IBOutlet UILabel * label1;
@property (nonatomic, strong) IBOutlet UILabel * label2;
@property (nonatomic, strong) IBOutlet UILabel * label3;
@property (nonatomic, strong) IBOutlet UILabel * label4;
@property (nonatomic, strong) IBOutlet UILabel * label5;
@property (nonatomic, strong) IBOutlet UILabel * label6;
@property (nonatomic, strong) IBOutlet UILabel * label7;

@property (nonatomic, strong) IBOutlet UILabel * detalj1;
@property (nonatomic, strong) IBOutlet UILabel * detalj2;
@property (nonatomic, strong) IBOutlet UILabel * detalj3;
@property (nonatomic, strong) IBOutlet UILabel * detalj4;
@property (nonatomic, strong) IBOutlet UILabel * detalj5;
@property (nonatomic, strong) IBOutlet UILabel * detalj6;
@property (nonatomic, strong) IBOutlet UILabel * detalj7;

@property (nonatomic, strong) NSString * key1;
@property (nonatomic, strong) NSString * key2;
@property (nonatomic, strong) NSString * key3;
@property (nonatomic, strong) NSString * key4;
@property (nonatomic, strong) NSString * key5;
@property (nonatomic, strong) NSString * key6;
@property (nonatomic, strong) NSString * key7;

@property (nonatomic, strong) IBOutlet UISwitch * hudSwitch;
@property (nonatomic, strong) IBOutlet UILabel * hudLabel;

@property (nonatomic) SystemSoundID lydID;

- (NSMutableArray *)settOppLayoutArray;

@end
