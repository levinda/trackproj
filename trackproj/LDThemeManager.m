//
//  LDThemeManager.m
//  trackproj
//
//  Created by Danil on 04/12/2019.
//  Copyright © 2019 levinda. All rights reserved.
//


#import "LDThemeManager.h"

@implementation LDThemeManager

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection
{
	if (@available(iOS 13.0, *)) {
		
		UIUserInterfaceStyle previousStyle = previousTraitCollection.userInterfaceStyle;
		UIUserInterfaceStyle currentStyle = UITraitCollection.currentTraitCollection.userInterfaceStyle;
		
		if(currentStyle != previousStyle){
			[[NSNotificationCenter defaultCenter] postNotificationName:(@"traitInterfaceStyleDidChange") object: nil];
			printf("ChangedStyle");
		}
	} else {
		// Fallback on earlier versions
	}
}

	
@end


