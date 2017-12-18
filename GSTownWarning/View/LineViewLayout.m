//
//  ViewLayout.m
//  ZhenBanWeather
//
//  Created by Tcy on 2017/7/21.
//  Copyright © 2017年 Tcytachiever. All rights reserved.
//

#import "LineViewLayout.h"

//Item的大小
#define ITEM_Width 56.0
#define ITEM_Height 84.0

//放大的有效范围(离中线的距离)
#define ACTIVE_DISTANCE 160
//图片缩放的系数
#define ZOOM_FACTOR 0.5

#define Line_Space 30.0

@implementation LineViewLayout

-(id)init
{
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(ITEM_Width, ITEM_Height);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //  top, left, bottom, right
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0.0);
        self.minimumLineSpacing = Line_Space;
    }
    return self;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)oldBounds
{
    return YES;
}

-(NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray* array = [super layoutAttributesForElementsInRect:rect];
    CGRect visibleRect;
    visibleRect.origin = self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.bounds.size;
    
    for (UICollectionViewLayoutAttributes* attributes in array) {
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            CGFloat distance = CGRectGetMidX(visibleRect) - attributes.center.x;
            CGFloat normalizedDistance = distance / ACTIVE_DISTANCE;
            if (ABS(distance) < ACTIVE_DISTANCE) {
                CGFloat zoom = 1 + ZOOM_FACTOR*(1 - ABS(normalizedDistance));
                attributes.transform3D = CATransform3DMakeScale(zoom, zoom, 1.0);
                attributes.zIndex = 1;
            }
        }
    }
    return array;
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect targetRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (ABS(itemHorizontalCenter - horizontalCenter) < ABS(offsetAdjustment)) {
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
