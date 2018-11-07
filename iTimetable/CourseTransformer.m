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
    NSSet *unarchivedClasses = [NSSet setWithObjects:[NSArray class], [Course class], [CourseInfo class], nil];
    return [NSKeyedUnarchiver unarchivedObjectOfClasses:unarchivedClasses fromData:value error:nil];
}

@end
