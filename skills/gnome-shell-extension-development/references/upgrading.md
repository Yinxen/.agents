# Upgrading Extensions

## Porting Between GNOME Versions

### Version Detection

```javascript
// Check if method exists (feature detection)
if (method) {
    method();
} else {
    // Fallback
}

// Or try/catch
try {
    method();
} catch (e) {
    // Fallback
}
```

### GNOME Version Detection

```javascript
const Config = imports.misc.config;
const [major, minor] = Config.PACKAGE_VERSION.split('.').map(s => Number(s));

if (major === 3 && minor <= 36) {
    console.log('Shell 3.36 or lower');
} else if (major === 3 && minor === 38) {
    console.log('Shell 3.38');
} else if (major >= 40) {
    console.log('Shell 40+');
}
```

## Key Breaking Changes

### GNOME 45+ (ESModules)
- Extensions use ESModules (`import/export`)
- Import paths changed from `imports.misc.extensionUtils` to `resource://` URIs
- Extension class pattern changed (see anatomy reference)
- See Legacy Documentation for pre-45 patterns

### GNOME 44
- `buildPrefsWidget()` deprecated (use `fillPreferencesWindow`)
- GTK4 preferences fully implemented

### GNOME 42
- `buildPrefsWidget()` introduced
- Session modes support added

### GTK Version Changes
- GTK3 → GTK4 (preferences)
- Many widget constructors changed

## metadata.json Version Format

```json
{
    "shell-version": ["3.36", "3.38", "40", "41", "42"]
}
```

- Pre-40: Use `"3.38"` format
- 40+: Use just major version `"40"`, `"45"`

## Common Patterns

### Feature Detection Pattern
```javascript
// If method/property exists
if (someObject.someMethod) {
    someObject.someMethod();
}

// Try/catch pattern
try {
    new API();
} catch (e) {
    // Use old API
}
```

### Version-specific Code
```javascript
const Config = imports.misc.config;
const [major] = Config.PACKAGE_VERSION.split('.').map(Number);

if (major >= 45) {
    // ESModule code
} else {
    // Legacy code
}
```

## Migration Checklist

1. Update `shell-version` in metadata.json
2. Change import paths to `resource://` URIs (GNOME 45+)
3. Convert to ES module syntax (`export default class`)
4. Update Extension class pattern (constructor + enable/disable)
5. Update preferences to use `fillPreferencesWindow` (GNOME 42+)
6. Update any deprecated API calls
7. Test in target GNOME version
8. Update documentation

## Resources

- [GNOME Shell GitLab](https://gitlab.gnome.org/GNOME/gnome-shell) - Browse source by tag
- [Legacy Documentation](https://gjs.guide/extensions/upgrading/legacy-documentation.html) - Pre-GNOME 45 patterns
- [Upgrading Guides](https://gjs.guide/extensions/#upgrading) - Version-specific guides