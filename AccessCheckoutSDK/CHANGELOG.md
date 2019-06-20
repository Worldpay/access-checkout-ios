# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),


## [1.0.0] - 2019-05-30
### Added
- First Release of Access Checkout SDK for iOS

## [1.1.0] - 2019-06-06
### Added
- Default card logo images.
- `AccessClient` and `Discovery` protocols.
- New `isEnabled` property to the `CardView` protocol.

### Changed
- CardValidator.validate(pan) now sets the `imageURL` property in the `CardConfiguration.CardBrand` instance returned.
