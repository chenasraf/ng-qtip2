Changelog
=========

1.1.1
=====
* Updated `qtipAt` and `qtipMy` default values

1.1.0
=====
* `qtipStyle` has been fixed and renamed to `qtipModalStyle`
* `qtipTipStyle` has been added
* `qtipHide` and `qtipShow` have been added, and will override `qtipEvent` and `qtipEventOut` when present
* `scope.closeQtip` will now only close the relevant qTip, and a custom ID is providable to override which is closed
* `qtipTarget` has been added
* `qtipOptions` has been added: will merge into the options set up through the declerative state, overriding any conflicting keys.
