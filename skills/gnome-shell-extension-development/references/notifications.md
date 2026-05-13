# Notifications

## Simple Notifications

```javascript
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

// Simple notification
Main.notify('Title', 'Body');

// Error notification (also logs as warning)
Main.notifyError('Failed', errorMessage);
```

## MessageTray.Notification

Full notification object with actions, urgency, etc.

```javascript
import * as MessageTray from 'resource:///org/gnome/shell/ui/messageTray.js';

const notification = new MessageTray.Notification({
    source: customSource,
    title: _('Notification Title'),
    body: _('Notification body text'),
    gicon: new Gio.ThemedIcon({ name: 'dialog-warning' }),
    iconName: 'dialog-warning',  // Alternative to gicon
    urgency: MessageTray.Urgency.NORMAL,
});
```

### Urgency Levels
```javascript
MessageTray.Urgency.LOW      // Tray only, no popup
MessageTray.Urgency.NORMAL  // Tray + popup (unless policy forbids)
MessageTray.Urgency.HIGH    // Tray + popup + expanded
MessageTray.Urgency.CRITICAL // Always shown, must acknowledge
```

### Notification Actions
```javascript
// Default activate action
notification.connect('activated', (_notification) => {
    console.debug('Notification clicked');
});

// Add action buttons (max 3)
notification.addAction(_('Label'), () => {
    console.debug('Action clicked');
});

// Clear all actions
notification.clearActions();
```

### Notification Destroy Reasons
```javascript
notification.connect('destroy', (_notification, reason) => {
    switch (reason) {
        case MessageTray.NotificationDestroyedReason.EXPIRED:
            // Dismissed by timeout
            break;
        case MessageTray.NotificationDestroyedReason.DISMISSED:
            // User closed it
            break;
        case MessageTray.NotificationDestroyedReason.SOURCE_CLOSED:
            // Source closed
            break;
        case MessageTray.NotificationDestroyedReason.REPLACED:
            // Replaced by new notification
            break;
    }
});
```

## MessageTray.Source

Notification source (like an app).

```javascript
// Use system source
const systemSource = MessageTray.getSystemSource();
const notification = new MessageTray.Notification({
    source: systemSource,
    title: 'System Notification',
    body: 'From system source',
});
systemSource.addNotification(notification);

// Create custom source
let customSource = null;

function getCustomSource() {
    if (!customSource) {
        customSource = new MessageTray.Source({
            title: _('Extension Name'),
            iconName: 'dialog-information',
            policy: new NotificationPolicy(),
        });

        customSource.connect('destroy', () => {
            customSource = null;
        });

        Main.messageTray.add(customSource);
    }
    return customSource;
}
```

## Custom Notification Policy

```javascript
const NotificationPolicy = GObject.registerClass(
class MyPolicy extends MessageTray.NotificationPolicy {
    get enable() { return true; }
    get enableSound() { return true; }
    get showBanners() { return true; }
    get forceExpanded() { return false; }
    get showInLockScreen() { return false; }
    get detailsInLockScreen() { return false; }
    store() { /* Called when source added */ }
});
```

## Imports
```javascript
import * as Main from 'resource:///org/gnome/shell/ui/main.js';
import * as MessageTray from 'resource:///org/gnome/shell/ui/messageTray.js';
```