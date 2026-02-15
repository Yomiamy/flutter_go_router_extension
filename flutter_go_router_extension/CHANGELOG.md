## 1.1.0

* Added `popToRoot` method to pop all routes until the root route is reached.

## 1.0.2

* Version bump to 1.0.2.

## 1.0.1

* Fixed visual flickering when navigating with `pushWithSetNewRoutePath` by reimplementing it using `routeInformationProvider` and improving stack management.

## 1.0.0

* Initial release.
* Added `ContextExtension` on `BuildContext` to provide additional `go_router` navigation capabilities.
* Implemented `pushWithSetNewRoutePath` to simulate Android's `FLAG_ACTIVITY_CLEAR_TOP | FLAG_ACTIVITY_NEW_TASK` behavior.
* Added utility `pathToRegexPattern` to handle route matching with dynamic parameters and wildcards.
* Added a comprehensive example application demonstrating the package features.
* Consolidated and centralized documentation in the root `README.md`.
* Updated package metadata and added MIT License.