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
 *  @file       ARGFrame.h
 *  @brief      typedef and declarations of Frame, for Objective-C
 *  @author     Mujun Kim < mujun@seerslab.com >
 *
 */

#ifndef ARGFrame_h
#define ARGFrame_h

#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

/**
 * Input image frame format
 */
typedef NS_ENUM(NSInteger, ARGImageFormat) {
  /** None */
  ARGImageFormatNone,
  
  /** Image file path */
  ARGImageFormatImageFile,
  
  /** OpenGL Texture ID */
  ARGImageFormatTextureId,
  
  /** Android Camera API1(YUV420sp) */
  ARGImageFormatYuvNV21,
  
  /** Android Camera API2 (YUV_420_888, YUV420p) */
  ARGImageFormatYuv420_888,
  
  /** RGB format */
  ARGImageFormatRGB,
  
  /** RGBA format */
  ARGImageFormatRGBA,
  
  /** BGRA format */
  ARGImageFormatBGRA,
};


// MARK: - ARGCameraConfig

/**
 * Camera configurations
 */
struct ARGCameraConfig {
  /** True if the front camera used */
  bool isFrontFacing;

  /** camera orientation, 0, 90, 180, or 270 */
  NSInteger orientation;

  /** horizontal FOV (Field of View) */
  float horizontalFOV;
};


// MARK: - ARGCameraFrameData

/**
 * Camera frame data
 */
@interface ARGCameraFrameData : NSObject

/**
 * Camera configurations.
 * @see `ARGCameraConfig`
 */
@property (readonly) struct ARGCameraConfig cameraConfig;

/** Image raw data */
@property (readonly, nullable) CVPixelBufferRef buffer;

/** Initializer */
- (nonnull instancetype)init NS_UNAVAILABLE;

/**
 * Initializer
 *
 * @param   cameraConfig    Camera configuration
 * @param   buffer                  Image raw data
 *
 * @see     `ARGCameraConfig`
 */
- (nonnull instancetype)initWithCameraConfig:(struct ARGCameraConfig)cameraConfig
                                      buffer:(nullable CVPixelBufferRef)buffer;

@end


// MARK: - ARGResultFrameData

/**
 * Result frame data
 */
@interface ARGResultFrameData : NSObject

/** Image raw data */
@property (readonly, nonnull) CVPixelBufferRef buffer;

/** Metal texure id */
@property (readonly, nullable) id<MTLTexture> textureId;

/** Initializer */
- (nonnull instancetype)init NS_UNAVAILABLE;

/**
 * Initializer
 *
 * @param   buffer            Image raw data
 * @param   textureId     Metal texture id
 */
- (nonnull instancetype)initWithBuffer:(nullable CVPixelBufferRef)buffer
                             textureId:(nullable id<MTLTexture>)textureId;

@end

#endif /* ARGFrame_h */
