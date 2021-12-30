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
 *  @file       ARGHumanARConfig.h
 *  @brief      Declaration of ARGHumanARConfig, the Objective-C++ wrapper for HumanARConfig.
 *  @author     Mujun Kim < mujun@seerslab.com >
 *
 */

#ifndef ARGHumanARConfig_h
#define ARGHumanARConfig_h

#import <Foundation/Foundation.h>

/**
 * Human AR configurations
 */
@interface ARGHumanARConfig : NSObject

/** CMS server URL */
@property (nullable, setter=setCMSURL:) NSURL *cmsURL;

/** API key that issued for the project from argear.io */
@property (nullable, setter=setAPIKey:) NSString *apiKey;

/** Secret key that issued for the project from argear.io */
@property (nullable) NSString *secretKey;

/** Authentication key that issued for the project from argear.io */
@property (nullable) NSString *authKey;

/** Path for the compressed content file that downloaded from the CMS server */
@property (nullable) NSString *compressedContentPath;

/** Path for the uncompressed content file */
@property (nullable) NSString *uncompressedContentPath;

@end

#endif /* ARGHumanARConfig_h */
