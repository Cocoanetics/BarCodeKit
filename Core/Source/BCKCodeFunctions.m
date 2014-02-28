//
//  BCKCodeFunctions.m
//  BarCodeKit
//
//  Created by Oliver Drobnik on 28.02.14.
//  Copyright (c) 2014 Oliver Drobnik. All rights reserved.
//

#import "BCKCodeFunctions.h"

NSUInteger BCKCodeMaxBarScaleThatFitsCodeInSize(BCKCode *code, CGSize size, NSDictionary *options)
{
   NSInteger retScale = 1;
   NSMutableDictionary *mutableOptions = [NSMutableDictionary dictionaryWithDictionary:options];
   
   for (NSUInteger scale=1;;scale++)
   {
      mutableOptions[BCKCodeDrawingBarScaleOption] = @(scale);
      CGSize neededSize = [code sizeWithRenderOptions:mutableOptions];
      
      if (neededSize.width > size.width || neededSize.height > size.height) {
         return retScale;
      }
      
      retScale = scale;
   }
}
