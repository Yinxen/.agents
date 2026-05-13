# Search Provider

## Overview

Extensions can register search providers to expose content to GNOME Shell's search.

## Implementation

```javascript
import St from 'gi://St';
import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

class ExampleSearchProvider {
    constructor(extension) {
        this._extension = extension;
    }

    // Required properties
    get appInfo() { return null; }  // Apps return Gio.AppInfo; extensions return null
    get canLaunchSearch() { return false; }
    get id() { return this._extension.uuid; }

    // Activate a result
    activateResult(result, terms) {
        console.debug(`activateResult(${result}, [${terms}])`);
    }

    // Launch the provider (only if canLaunchSearch is true)
    launchSearch(terms) {
        console.debug(`launchSearch([${terms}])`);
    }

    // Create custom result actor (return null for default)
    createResultObject(meta) {
        return null;
    }

    // Get metadata for results
    async getResultMetas(results, cancellable) {
        const { scaleFactor } = St.ThemeContext.get_for_stage(global.stage);

        return results.map(id => ({
            id,
            name: 'Result Name',
            description: 'Result description',
            clipboardText: 'Optional clipboard content',
            createIcon: size => new St.Icon({
                icon_name: 'dialog-information',
                width: size * scaleFactor,
                height: size * scaleFactor,
            }),
        }));
    }

    // Get initial results from search terms
    async getInitialResultSet(terms, cancellable) {
        return ['result-1', 'result-2', 'result-3'];
    }

    // Refine results with expanded terms
    async getSubsearchResultSet(results, terms, cancellable) {
        return results;  // Or filter/refine
    }

    // Limit results
    filterResults(results, maxResults) {
        return results.slice(0, maxResults);
    }
}
```

## Registration

```javascript
export default class MyExtension extends Extension {
    enable() {
        this._provider = new ExampleSearchProvider(this);
        Main.overview.searchController.addProvider(this._provider);
    }

    disable() {
        Main.overview.searchController.removeProvider(this._provider);
        this._provider = null;
    }
}
```

## Complete Example

```javascript
import St from 'gi://St';
import { Extension } from 'resource:///org/gnome/shell/extensions/extension.js';
import * as Main from 'resource:///org/gnome/shell/ui/main.js';

const SearchProvider = GObject.registerClass(
class ExampleSearchProvider {
    constructor(extension) {
        this._extension = extension;
    }

    get appInfo() { return null; }
    get canLaunchSearch() { return false; }
    get id() { return this._extension.uuid; }

    activateResult(result, terms) {
        Main.notify('Result Activated', `Result: ${result}`);
    }

    launchSearch(terms) {
        console.debug(`Launching search for ${terms}`);
    }

    createResultObject(meta) { return null; }

    async getResultMetas(results, cancellable) {
        const scaleFactor = St.ThemeContext.get_for_stage(global.stage).scaleFactor;
        return results.map(id => ({
            id,
            name: `Search Result ${id}`,
            description: 'A search result item',
            createIcon: size => new St.Icon({
                icon_name: 'system-search-symbolic',
                width: size * scaleFactor,
                height: size * scaleFactor,
            }),
        }));
    }

    async getInitialResultSet(terms, cancellable) {
        // Filter based on terms
        const allResults = ['doc1', 'doc2', 'doc3', 'note1', 'note2'];
        return allResults.filter(r =>
            terms.some(term => r.toLowerCase().includes(term.toLowerCase()))
        );
    }

    async getSubsearchResultSet(results, terms, cancellable) {
        return results;  // Reuse same filtering
    }

    filterResults(results, maxResults) {
        return results.slice(0, maxResults);
    }
});

export default class SearchExtension extends Extension {
    enable() {
        this._provider = new SearchProvider(this);
        Main.overview.searchController.addProvider(this._provider);
    }

    disable() {
        Main.overview.searchController.removeProvider(this._provider);
        this._provider = null;
    }
}
```

## Notes

- Search providers run in GNOME Shell process
- Results are string identifiers passed to getResultMetas
- createIcon should respect scaleFactor for HiDPI
- cancellable allows cancellation of async operations