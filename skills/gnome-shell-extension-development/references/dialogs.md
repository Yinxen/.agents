# Dialogs

## Dialog.Dialog

Base dialog layout widget.

```javascript
import * as Dialog from 'resource:///org/gnome/shell/ui/dialog.js';
import St from 'gi://St';

const parentActor = new St.Widget();
const dialogLayout = new Dialog.Dialog(parentActor, 'my-dialog-style-class');

dialogLayout.contentLayout.add_child(iconOrLabel);

dialogLayout.addButton({
    label: 'Close',
    action: () => dialogLayout.destroy(),
    key: Clutter.KEY_Escape,
    isDefault: true,
});

dialogLayout.clearButtons();
```

### Properties
- `contentLayout` - St.BoxLayout for content area
- `buttonLayout` - St.BoxLayout for buttons

### Dialog.MessageDialogContent

Simple title + description widget.

```javascript
const messageContent = new Dialog.MessageDialogContent({
    title: 'Title',
    description: 'Description text',
});
dialogLayout.contentLayout.add_child(messageContent);
```

### Dialog.ListSection + ListSectionItem

Dialog with list of items (like network selection).

```javascript
const listLayout = new Dialog.ListSection({ title: 'List Title' });
dialogLayout.contentLayout.add_child(listLayout);

const item = new Dialog.ListSectionItem({
    icon_actor: new St.Icon({ icon_name: 'info-symbolic' }),
    title: 'Item Title',
    description: 'Item description',
});
listLayout.list.add_child(item);
```

## ModalDialog.ModalDialog

Modal dialog with fade animations.

```javascript
import * as ModalDialog from 'resource:///org/gnome/shell/ui/modalDialog.js';

const modal = new ModalDialog.ModalDialog({
    shellReactive: false,      // Whether shell is sensitive when open
    actionMode: Shell.ActionMode.SYSTEM_MODAL,
    shouldFadeIn: true,
    shouldFadeOut: true,
    destroyOnClose: true,
    styleClass: 'my-dialog',
});

modal.open(timestamp, onPrimary);
modal.close(timestamp);

// Set initial key focus
modal.setInitialKeyFocus(actor);

// Buttons
modal.addButton({ label, action, key, isDefault });
modal.setButtons([buttonInfoArray]);
modal.clearButtons();
```

### States
```javascript
ModalDialog.State.OPENED
ModalDialog.State.CLOSED
ModalDialog.State.OPENING
ModalDialog.State.CLOSING
ModalDialog.State.FADED_OUT
```

### Signals
- `closed` - Dialog closed
- `opened` - Dialog opened

### Example: Reminder Dialog
```javascript
let reminderId = null;
const dialog = new ModalDialog.ModalDialog({ destroyOnClose: false });

dialog.connect('closed', () => {
    reminderId = GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 60, () => {
        dialog.open(global.get_current_time());
        reminderId = null;
        return GLib.SOURCE_REMOVE;
    });
});

dialog.connect('destroy', () => {
    if (reminderId) {
        GLib.Source.remove(reminderId);
        reminderId = null;
    }
});

dialog.setButtons([{
    label: 'Close',
    action: () => dialog.destroy(),
}, {
    label: 'Later',
    isDefault: true,
    action: () => dialog.close(global.get_current_time()),
}]);

dialog.open(global.get_current_time());
```

## Shell.ActionMode

Controls when actions are enabled.

```javascript
import Shell from 'gi://Shell';

Shell.ActionMode.NONE         // Block all actions
Shell.ActionMode.NORMAL       // Allow in window mode
Shell.ActionMode.OVERVIEW     // Allow in overview
Shell.ActionMode.LOCK_SCREEN  // Allow when locked
Shell.ActionMode.UNLOCK_SCREEN // Allow in unlock dialog
Shell.ActionMode.LOGIN_SCREEN // Allow at login
Shell.ActionMode.SYSTEM_MODAL // System modal dialogs
Shell.ActionMode.LOOKING_GLASS // In Looking Glass
Shell.ActionMode.POPUP        // When menu open
Shell.ActionMode.ALL          // Always allow
```

## Key Constants

```javascript
import Clutter from 'gi://Clutter';

Clutter.KEY_Escape
Clutter.KEY_Return
Clutter.KEY_Enter
Clutter.KEY_space
Clutter.KEY_Tab
Clutter.KEY_A
// ... etc
```