# animated-diagrams-library

Animated diagram components and icons for design documents. Everything is plain
HTML and CSS with no JavaScript and no external requests, so a diagram can be
pasted into a Confluence page through the HTML macro.

## Use a diagram

```sh
./build.sh
open dist/catalog.html        # every icon and component
open dist/version-flow.html   # example diagram
```

Paste the whole contents of a `dist/*.html` file into the HTML macro. Each file
already contains the library, so nothing else is needed on the page.

## Write a diagram

Create `diagrams/my-diagram.html` and run `./build.sh`:

```html
<div class="dd">
  <div class="dd-row">
    <div class="dd-node">
      <svg class="dd-ico"><use href="#dd-i-app"/></svg>
      <b>App</b><small>asks for versions</small>
    </div>
    <div class="dd-link"><i>v1.5.0</i></div>
    <div class="dd-node dd-amber" style="--d:1.5s">
      <svg class="dd-ico"><use href="#dd-i-ap"/></svg>
      <b>Access point</b>
    </div>
  </div>
</div>
```

## Components

| Class | What it is |
|---|---|
| `dd` | Diagram card. Add `dd-light` for a light card. |
| `dd-row` | One left-to-right flow. |
| `dd-node` | Box with an icon, `<b>` title and `<small>` subtitle. Pulses on its step. |
| `dd-still` | On a node: no pulse. |
| `dd-link` | Connector. `<i>label</i>` inside gives a travelling pill, `<i></i>` a dot, nothing a static line. |
| `dd-back` | On a link: the pill travels right to left. |
| `dd-dashed` | On a link: dashed line. |
| `dd-group` | Dashed boundary around nodes. `data-label="..."` names it. |
| `dd-badge` | Small version or status pill. |
| `dd-title`, `dd-note` | Heading and caption. |
| `dd-amber`, `dd-green`, `dd-violet`, `dd-red` | Accent colour for a node, link or group. Default is cyan. |

## Timing

`style="--d:1.5s"` on a node or link sets when it fires in the loop. Step n
fires at n x 1.5s. `--t` on `.dd` sets the loop length (default 6s). A loop
holds four steps.

## Icons

`<svg class="dd-ico"><use href="#dd-i-NAME"/></svg>`

`helm` `k8s` `app` `ap` `server` `db` `cloud` `user` `registry` `git`
`switch` `controller` `firmware` `ci` `ci-running` `ci-failed`

The icons are generic line drawings, not vendor logos.

## Contributing

`AGENTS.md` has the rules for adding icons, components and diagrams. It is
written for LLM agents and works as a contributor guide for people too.
