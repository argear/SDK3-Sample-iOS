/*******************************************************************************
 * Copyright(C) 2021 SEERSLAB Inc. All Rights Reserved.
 *
 * PROPRIETARY/CONFIDENTIAL
 *
 * This software is the confidential and proprietary information of
 * SEERSLAB Inc. You shall not disclose such Confidential Information
 * and shall use it only in accordance with the terms of the license
 * agreement you entered into with SEERSLAB Inc.
 *
 * "SEERSLAB Inc." MAKES NO REPRESENTATIONS OR WARRANTIES ABOUT THE SUITABILITY
 * OF THE SOFTWARE, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
 * NON-INFRINGEMENT. "SEERSLAB Inc." SHALL NOT BE LIABLE FOR ANY DAMAGES
 * SUFFERED BY LICENSEE AS A RESULT OF USING, MODIFYING OR DISTRIBUTING THIS
 * SOFTWARE OR ITS DERIVATIVES.
 *******************************************************************************/

/**
 *
 *  @file       ARGContentInfo.h
 *  @brief      Declaration of ARGContentInfo, the Objective-C++ wrapper for ContentInfo
 *  @author     Mujun Kim < mujun@seerslab.com >
 *
 */

#ifndef ARGContentInfo_h
#define ARGContentInfo_h

#import <Foundation/Foundation.h>

/**
 * Content info provided for CMS
 */
@interface ARGContentInfo : NSObject

/** URI of the content thumbnail image */
@property (nonnull, setter=setUUID:) NSString *uuid;

/** URI of the content */
@property (nonnull, setter=setURI:) NSURL *uri;

/** URI of the content thumbnail image */
@property (nonnull) NSURL *thumbnailURI;

/**
 * Initializer
 *
 * @param   uuid                      URI of the content thumbnail image
 * @param   uri                        URI of the content
 * @param   thumbnailURI    URI of the content thumbnail image
 */
- (nonnull instancetype)initWithUUID:(nonnull NSString *)uuid
                                 uri:(nonnull NSURL *)uri
                        thumbnailURI:(nonnull NSURL *)thumbnailURI;

/**
 * Set the content property
 *
 * @param   key   Key string
 * @param   val   Value string
 */
- (void)setProperty:(nonnull NSString *)key val:(nonnull NSString *)val;

/**
 * Get content attribute value according to the key.
 * The attribute key should be set from the project setting in https://argear.io
 *
 * @param   key     Key string of the attribute
 * @return  String of the key
 */
- (nullable NSString *)getAttribute:(nonnull NSString *)key;

@end

#endif /* ARGContentInfo_h */
