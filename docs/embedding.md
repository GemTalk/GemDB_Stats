# Embedding GemDB Stats

The web build of GemDB Stats can run inside another page, such as a VS Code
webview in [GemDB Code](https://github.com/GemTalk/GemDB_Code). The host page
decides which statmon file is shown. In a plain browser, a `?file=` URL does
the same.

The app fetches the file from a URL and streams it, so the host never reads or
copies the file itself. The AI assistant is not part of the web build.

## In a VS Code webview

The extension and the app exchange three messages:

| Message | Direction | Meaning |
| --- | --- | --- |
| `{type: 'ready'}` | app → extension | The app is listening. Send `open` after this, not before. |
| `{type: 'open', url, name?}` | extension → app | Fetch and show the file at `url`, labelled `name` (default: the URL's last path segment). Sending another `open` replaces the file. |
| `{type: 'pickFile'}` | app → extension | The user clicked the file name. Show VS Code's open dialog and answer with `open`. |

`url` is the file's `webview.asWebviewUri(...)`. Its folder must be in the
panel's `localResourceRoots`. Under code-server, the webview fetches the file
from the server, which is where the statmon files are, so nothing else is
needed there. The app also uses `pickFile` instead of the browser's own file
dialog for this reason: a browser dialog would browse the user's machine, not
the server.

`.gz` files need no special handling: the app detects gzip from the bytes.

### Getting the web build

From `app/`:

```sh
flutter build web --release --no-web-resources-cdn
```

`--no-web-resources-cdn` matters: without it, Flutter loads its renderer from
Google's servers, which a webview's Content Security Policy blocks. The
output is `app/build/web/`. Ship that folder in the extension, pinned to a
GemDB Stats commit, as GemDB Code does for Grail.

Two things a webview needs are built in, so `index.html` and
`flutter_bootstrap.js` can be used as they are:

- **The app leaves the page's URL alone.** A webview's page
  (`vscode-webview://…`) and its `<base href>` (the resource origin) are on
  different origins, so the history update Flutter normally makes on startup
  throws a `SecurityError` and the app stops at the loading screen. The app
  has no routes, so it turns that update off.
- **No service worker.** `web/flutter_bootstrap.js` loads the app without
  registering Flutter's (deprecated) service worker; VS Code runs its own in
  the webview.

The build also holds files a JS build never loads (`skwasm*`, `*.symbols`,
`manifest.json`, `icons/`), which the extension may leave out of the `.vsix`.

### Showing it

A sketch of the extension side. It is untested in VS Code: check it in the
spike (step 1 of the proposal), especially the `localResourceRoots` update
for a picked file in a new folder.

```ts
import * as path from 'path';
import { randomBytes } from 'crypto';
import * as vscode from 'vscode';

export async function showStatistics(
  context: vscode.ExtensionContext,
  file: vscode.Uri,
): Promise<void> {
  const build = vscode.Uri.joinPath(context.extensionUri, 'gemdb-stats');
  const roots = (folder: vscode.Uri) => [build, folder];
  const panel = vscode.window.createWebviewPanel(
    'gemdbStats',
    path.basename(file.path),
    vscode.ViewColumn.Active,
    {
      enableScripts: true,
      // Otherwise VS Code discards the page when the tab is hidden.
      retainContextWhenHidden: true,
      localResourceRoots: roots(vscode.Uri.joinPath(file, '..')),
    },
  );
  const webview = panel.webview;

  const open = (uri: vscode.Uri) => {
    webview.options = {
      ...webview.options,
      localResourceRoots: roots(vscode.Uri.joinPath(uri, '..')),
    };
    panel.title = path.basename(uri.path);
    void webview.postMessage({
      type: 'open',
      url: webview.asWebviewUri(uri).toString(),
      name: path.basename(uri.path),
    });
  };

  webview.onDidReceiveMessage(async (message: { type: string }) => {
    if (message.type === 'ready') {
      open(file);
    } else if (message.type === 'pickFile') {
      const picked = await vscode.window.showOpenDialog({
        canSelectMany: false,
        filters: { 'Statmon files': ['out', 'gz'], 'All files': ['*'] },
      });
      if (picked?.[0]) {
        open(picked[0]);
      }
    }
  });

  const index = await vscode.workspace.fs.readFile(
    vscode.Uri.joinPath(build, 'index.html'),
  );
  webview.html = withCsp(webview, build, Buffer.from(index).toString('utf8'));
}

// Points the page at the build folder and locks it down: every script
// carries a nonce, and nothing loads from outside the webview.
function withCsp(webview: vscode.Webview, build: vscode.Uri, html: string): string {
  const nonce = randomBytes(16).toString('base64');
  const src = webview.cspSource;
  const csp = [
    "default-src 'none'",
    // CanvasKit, Flutter's renderer, is WebAssembly.
    `script-src ${src} 'nonce-${nonce}' 'wasm-unsafe-eval'`,
    // Flutter adds styles at run time.
    `style-src ${src} 'unsafe-inline'`,
    `img-src ${src} data: blob:`,
    `font-src ${src} data:`,
    // The statmon file, CanvasKit and fonts are fetched.
    `connect-src ${src}`,
    `manifest-src ${src}`,
  ].join('; ');
  return html
    .replace(/<base href="[^"]*">/, `<base href="${webview.asWebviewUri(build)}/">`)
    .replace('<head>', `<head>\n  <meta http-equiv="Content-Security-Policy" content="${csp}">`)
    .replaceAll('<script', `<script nonce="${nonce}"`);
}
```

This CSP was checked the way a webview serves the page: the rewritten
`index.html` on one origin, the build and the statmon file on another (with
that origin in place of `webview.cspSource`), and a stand-in for the VS Code
API. The app started, said `ready`, and streamed the file sent in `open`, with
no policy violations and no service worker registered.

## In a browser

Add `?file=` with the file's URL, relative to the page or absolute, and
optionally `&name=` to label it:

```
https://gemtalk.github.io/GemDB_Stats/?file=https://example.com/statmon.out.gz
```

The server holding the file must allow the page's origin (CORS). The
progress bar needs the server's `Content-Length`; without it, the app shows
"Loading…" until the file is in.
