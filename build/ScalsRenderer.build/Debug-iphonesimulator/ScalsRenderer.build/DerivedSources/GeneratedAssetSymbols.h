#import <Foundation/Foundation.h>

#if __has_attribute(swift_private)
#define AC_SWIFT_PRIVATE __attribute__((swift_private))
#else
#define AC_SWIFT_PRIVATE
#endif

/// The "DoubleDateHero" asset catalog image resource.
static NSString * const ACImageNameDoubleDateHero AC_SWIFT_PRIVATE = @"DoubleDateHero";

/// The "astrology" asset catalog image resource.
static NSString * const ACImageNameAstrology AC_SWIFT_PRIVATE = @"astrology";

/// The "touchUpAfter" asset catalog image resource.
static NSString * const ACImageNameTouchUpAfter AC_SWIFT_PRIVATE = @"touchUpAfter";

/// The "touchUpBefore" asset catalog image resource.
static NSString * const ACImageNameTouchUpBefore AC_SWIFT_PRIVATE = @"touchUpBefore";

/// The "womanAligator" asset catalog image resource.
static NSString * const ACImageNameWomanAligator AC_SWIFT_PRIVATE = @"womanAligator";

#undef AC_SWIFT_PRIVATE
