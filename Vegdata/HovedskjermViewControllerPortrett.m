//
//  HovedskjermViewControllerPortrett.m
//  Vegdata
//
//  Created by Lars Smeby on 14.03.13.
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

#import "HovedskjermViewControllerPortrett.h"
#import "HovedskjermViewControllerLandskap.h"

@implementation HovedskjermViewControllerPortrett

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([self erFireTommerRetina])
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_p_4in.jpg"]];
    else
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_p.jpg"]];
}

- (void)awakeFromNib
{
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orienteringEndret:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)orienteringEndret:(NSNotification *)notifikasjon
{
    if(self.hudSwitch.isOn || self.landskapViewController.hudSwitch.isOn)
        return;
    
    UIDeviceOrientation orientering = [UIDevice currentDevice].orientation;
    
    if(UIDeviceOrientationIsLandscape(orientering) && self.presentedViewController == nil)
    {
        if(!self.landskapViewController)
        {
            self.landskapViewController = [[UIStoryboard storyboardWithName:VEGDATA_STORYBOARD bundle:nil] instantiateViewControllerWithIdentifier:VEGDATA_HOVEDSKJERM_LANDSKAP];
            
            self.landskapViewController.pos = self.pos;
            self.landskapViewController.vegObjKont = self.vegObjKont;
        }

        [self presentViewController:self.landskapViewController animated:NO completion:nil];

        if(self.nyesteData)
            [self.landskapViewController vegObjekterErOppdatert:self.nyesteData];
        
        self.pos.delegate = self.landskapViewController;
        self.vegObjKont.delegate = self.landskapViewController;
    }
    else if(orientering == UIDeviceOrientationPortrait && self.presentedViewController != nil)
    {
        [self dismissViewControllerAnimated:NO completion:nil];
        
        if(self.landskapViewController.nyesteData)
            [self vegObjekterErOppdatert:self.landskapViewController.nyesteData];
        
        self.pos.delegate = self;
        self.vegObjKont.delegate = self;
    }
    
    [self settOppLayoutArray];
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)hudKnappTrykket:(UISwitch *)knapp
{
    [super hudKnappTrykket:knapp];
    
    if(knapp.isOn)
        self.view.backgroundColor = [UIColor blackColor];
    else if([self erFireTommerRetina])
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_p_4in.jpg"]];
    else
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_p.jpg"]];
}

@end
