# Changelog
## 1.3.0
- Added ability to globally set defaults for qTip options
- Overriding options using attributes now merges deeply instead of replaces

## 1.2.3
- Fixes to qTip defaults & overriding (thanks to @idoa01)

## 1.2.2
- Updated dependencies to support Angular 1.4.7+

## 1.2.1
- Updated `closeQtip`

## 1.2.0
- Add qtip2 dependency for bower
- Added `qtip-show-effect`, `qtip-hide-effect` and `qtip-persistent` (see readme for information)
- Added scope methods: `getQtipElement`, `getQtipId`, and updated arguments for `closeQtip`

## 1.1.2
- Fixed a `qtip-options` bug (thanks to [@marcmascort](https://github.com/marcmascort))

## 1.1.1
- Updated `qtip-at` and `qtip-my` default values

## 1.1.0
- `qtip-style` has been fixed and renamed to `qtip-modal-style`
- `qtip-tip-style` has been added
- `qtip-hide` and `qtip-show` have been added, and will override `qtip-event` and `qtip-event-out` when present
- `scope.closeQtip` will now only close the relevant qTip, and a custom ID is providable to override which is closed
- `qtip-target` has been added
- `qtip-options` has been added: will merge into the options set up through the declerative state, overriding any conflicting keys.
