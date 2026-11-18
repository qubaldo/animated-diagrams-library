# animated-diagrams-library

Animated diagram components and icons for design documents. Everything is plain
HTML and CSS with no JavaScript and no external requests, so a diagram can be
pasted into a Confluence page through the HTML macro.

## Use a diagram

```sh
./build.sh
open dist/catalog.html        # every icon and component
open dist/version-flow.html   # example diagram
open dist/network-topology.html   # branching, wireless links, legend
```

Paste the whole contents of a `dist/*.html` file into the HTML macro. Each file
already contains the styles and only the icons that diagram uses, so nothing
else is needed on the page.

## Write a diagram

Create `diagrams/my-diagram.html` and run `./build.sh`:

```html
<div class="dd" role="img" aria-label="The app asks the access point for its version.">
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
| `dd-col` | One top-to-bottom flow. Nodes and links work the same inside it. |
| `dd-node` | Box with an icon, `<b>` title and `<small>` subtitle. Pulses on its step. |
| `dd-still` | On a node: no pulse. |
| `dd-highlight` | On a node: permanently lit in its accent colour. |
| `dd-degraded` | On a node: amber border and icon. |
| `dd-down` | On a node: red dashed border, dimmed. |
| `dd-link` | Connector. `<i>label</i>` inside gives a travelling pill, `<i></i>` a dot, nothing a static line. |
| `dd-back` | On a link: the pill travels right to left. |
| `dd-both` | On a link with two `<i>`: traffic in both directions at once. |
| `dd-reqres` | On a link with two `<i>`: the first travels forward, the second comes back one step later. Uses two steps. |
| `dd-dashed` | On a link: dashed line. |
| `dd-wireless` | On a link: dotted line in the accent colour whose dots flow continuously, for a wireless connection. `dd-back` reverses the flow, `dd-still` stops it. |
| `dd-branch` | One node feeding several. Holds one `dd-row` per branch, each starting with a link. |
| `dd-merge` | Several feeding one. Holds one `dd-row` per branch, each ending with a link. Combine with `dd-branch` to fan out and back in. |
| `dd-group` | Dashed boundary around nodes. `data-label="..."` names it. |
| `dd-badge` | Small version or status pill. |
| `dd-title`, `dd-note` | Heading and caption. |
| `dd-legend` | Row of keys under a diagram. |
| `dd-key` | Legend entry with a colour swatch; add an accent class to colour it. |
| `dd-key-wired`, `dd-key-wireless` | Legend entries for the two link styles. |
| `dd-amber`, `dd-green`, `dd-violet`, `dd-red` | Accent colour for a node, link or group. Default is cyan. |

## Timing

`style="--d:1.5s"` on a node or link sets when it fires in the loop. Step n
fires at n x 1.5s. `--t` on `.dd` sets the loop length (default 6s). A loop
holds four steps. Add `dd-steps-6` or `dd-steps-8` to the `.dd` root for a
longer sequence; the step stays 1.5s and the loop becomes 9s or 12s.

## Accessibility, print and PDF

Give every diagram root a description: `<div class="dd" role="img"
aria-label="What the diagram shows">`. The build fails without one.

With reduced motion, in print and in PDF export the animation stops and each
pill sits in the middle of its link, so labels stay readable.

## Icons

`<svg class="dd-ico"><use href="#dd-i-NAME"/></svg>`

`helm` `k8s` `app` `ap` `server` `db` `cloud` `user` `registry` `git`
`switch` `controller` `firmware` `ci` `ci-running` `ci-failed` `ci-completed`
`laptop` `desktop` `phone` `tablet` `sensor`
`router` `firewall` `lb` `gateway` `antenna`
`pod` `container` `namespace` `config` `secret` `queue` `volume`
`package` `tag` `rollback` `lock` `key` `certificate`
`repo` `shield` `file` `api` `transfer` `send` `wifi`

The icons are generic line drawings, not vendor logos.

## Contributing

`AGENTS.md` has the rules for adding icons, components and diagrams. It is
written for LLM agents and works as a contributor guide for people too.
