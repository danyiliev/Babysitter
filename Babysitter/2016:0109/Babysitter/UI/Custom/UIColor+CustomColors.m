//
//  UIColor+CustomColors.m
//  Cooleaf
//
//  Created by Haider Khan on 8/29/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "UIColor+CustomColors.h"

@implementation UIColor (CustomColors)

# pragma colorPrimary

+ (UIColor *)colorPrimary {
    return [UIColor colorWithRed:29/255.0 green:174/255.0 blue:235/255.0 alpha:1];
}

# pragma colorPrimaryDark

+ (UIColor *)colorPrimaryDark {
    return [UIColor colorWithRed:0.22 green:0.64 blue:0.61 alpha:1];
}

# pragma colorAccent

+ (UIColor *)colorAccent {
    return [UIColor colorWithRed:1 green:0.42 blue:0.4 alpha:1];
}

# pragma navDrawerStart

+ (UIColor *)navDrawerStart {
    return [UIColor colorWithRed:0.36 green:0.4 blue:0.5 alpha:1];
}

# pragma navDrawerEnd

+ (UIColor *)navDrawerEnd {
    return [UIColor colorWithRed:0.66 green:0.74 blue:0.85 alpha:1];
}

# pragma mark - searchNavBarColor

+ (UIColor *)searchNavBarColor {
    return [self UIColorFromRGB:0x52B6AC];
}

# pragma menuGradientFirstColor

+ (UIColor *)menuGradientFirstColor {
    return [self UIColorFromRGB:0x92A5C5];
}

# pragma menuGradientSecondColor

+ (UIColor *)menuGradientSecondColor {
    return [self UIColorFromRGB:0xa889AB7];
}

# pragma menuGradientThirdColor

+ (UIColor *)menuGradientThirdColor {
    return [self UIColorFromRGB:0x47546E];
}

# pragma menuGradientFourthColor

+ (UIColor *)menuGradientFourthColor {
    return [self UIColorFromRGB:0x47546E];
}

# pragma mark - menuTextColor

+ (UIColor *)menuTextColor {
    return [self UIColorFromRGB:0xFDFDFD];
}

# pragma offWhite

+ (UIColor *)offWhite {
    return [self UIColorFromRGB:0xFDFDFD];
}

# pragma barWhite

+ (UIColor *)barWhite {
    
    return [self UIColorFromRGB:0xF0F0F0];
}

# pragma offBlack

+ (UIColor *)offBlack {
    return  [self UIColorFromRGB:0x252525];
}

# pragma mark - groupNavBarColor

+ (UIColor *)groupNavBarColor {
    return [self UIColorFromRGB:0xF24230];
}

# pragma mark - postButtonColor

+ (UIColor *)postButtonColor {
    return [self UIColorFromRGB:0xE0E1E4];
}

# pragma mark - eventColor

+ (UIColor *)eventColor {
    return [self UIColorFromRGB:0x00BCD5];
}

# pragma mark - commentButtonColor

+ (UIColor *)commentButtonColor {
    return [self UIColorFromRGB:0xE0E1E4];
}

# pragma UIColorFromRGB

+ (UIColor *)UIColorFromRGB:(int)rgbValue {
    return [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) /255.0 \
                           green:((float)((rgbValue & 0xFF00) >> 8)) /255.0 \
                            blue:((float)(rgbValue & 0xFF)) /255.0
                           alpha:1.0];
}

@end
