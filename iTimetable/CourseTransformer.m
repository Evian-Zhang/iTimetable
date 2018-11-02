//
//  CourseTransformer.m
//  iTimetable
//
//  Created by Evian张 on 2018/11/2.
//  Copyright © 2018 Evian张. All rights reserved.
//

#import "CourseTransformer.h"

@implementation CourseTransformer

+ (Class)transformedValueClass
{
    return [NSArray class];
}

+ (BOOL)allowsReverseTransformation
{
    return YES;
}

- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value requiringSecureCoding:YES error:nil];
}

- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchivedObjectOfClass:[NSArray class] fromData:value error:nil];
}

@end
