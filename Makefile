TARGET := iphone:clang:latest:15.4
INSTALL_TARGET_PROCESSES = TikTok
THEOS_DEVICE_IP = 192.168.1.119

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = DouX

DouX_LIBRARIES = JGProgressHUD
DouX_FILES = Tweak.x $(wildcard hooks/*.x) DouXDownload.m DouXManager.m DouXMultipleDownload.m SecurityViewController.m VaultMediaItem.m VaultManager.m VaultViewController.m PhotoViewController.m CreatorFilterViewController.m ContentTypeFilterViewController.m FilterViewController.m $(wildcard Settings/*.m)
DouX_FRAMEWORKS = UIKit Foundation CoreGraphics Photos CoreServices SystemConfiguration SafariServices Security QuartzCore Photos
DouX_CFLAGS = -fobjc-arc -Wno-unused-variable -Wno-unused-value -Wno-deprecated-declarations -Wno-nullability-completeness -Wno-unused-function -Wno-incompatible-pointer-types -I./libs/JGProgressHUD

include $(THEOS_MAKE_PATH)/tweak.mk

# --- Add this line at the end ---
include $(THEOS_MAKE_PATH)/aggregate.mk

before-all::
	@$(MAKE) -C libs/JGProgressHUD THEOS_PACKAGE_SCHEME=$(THEOS_PACKAGE_SCHEME)
	@$(MAKE) -C libs/JGProgressHUD stage THEOS_PACKAGE_SCHEME=$(THEOS_PACKAGE_SCHEME)