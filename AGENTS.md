# Instructions for LLM agents

This repo is a small library of animated diagram components and icons. The
output is HTML that a person pastes into a Confluence page through the HTML
macro, to illustrate design documents.

## Hard constraints

These come from where the output runs. Do not relax them.

- **Self-contained.** No external requests of any kind: no CDN scripts, web
  fonts, remote images or `@import`. Confluence may block them.
- **No JavaScript in the library.** Animation is CSS only. Some Confluence
  setups strip `<script>`.
- **Everything is namespaced.** Classes, keyframes and symbol ids start with
  `dd-`. Every selector is `.dd` or starts with `.dd-`, so nothing leaks into
  the Confluence page. Never style bare tags (`p`, `b`, `svg`) at top level.
- **No `<html>`, `<head>` or `<body>`.** Files are fragments.
- **Both cards must work.** Every component has to look right on `.dd` (dark)
  and `.dd.dd-light`. Use the custom properties (`--bg`, `--panel`, `--line`,
  `--fg`, `--mut`, `--c`), never hard-coded colours.
- **Respect `prefers-reduced-motion`.** New animations must be covered by the
  existing media query and leave a readable static state.
- **Static state must be readable.** The reduced-motion and print media query
  is also what PDF export shows. Anything that is invisible until animated
  needs a parked position there.
- **No build dependencies.** `build.sh` is POSIX shell. Do not add npm, a
  bundler or a framework.

## Layout

| Path | What it is |
|---|---|
| `library.html` | The only source of styles and icons: one `<style>` and one SVG sprite. |
| `diagrams/*.html` | One diagram per file, markup only. No `<style>`, no sprite. |
| `diagrams/catalog.html` | Shows every icon and every component. Keep it complete. |
| `build.sh` | Checks icons and descriptions, then writes `dist/<name>.html` = styles + the icons that diagram uses + the diagram. |
| `dist/` | Generated and git-ignored. These are the files people paste. |

## Adding an icon

1. Add a `<symbol id="dd-i-NAME" viewBox="0 0 24 24">` to the sprite in
   `library.html`. `NAME` is lowercase letters, digits and hyphens.
2. Follow the icon style:
   - Stroke only. Do not set `fill`, `stroke`, `stroke-width` or colours on the
     shapes; `.dd-ico` supplies them (1.6 width, round caps and joins).
   - One exception: a single shape may be filled to show status, with
     `style="fill:var(--ok);stroke:var(--ok)"`. Use `--ok` (green, passed or
     healthy), `--warn` (amber, running or pending) or `--bad` (red, failed).
     See `ci`, `ci-running` and `ci-failed`. A variant may fill every shape when
     the whole thing has that status (`ci-completed`). Always go through these variables;
     each has a dark-card and a light-card value. Name status variants
     `NAME-STATUS`.
   - Stay inside a 2-unit margin: coordinates between 2 and 22.
   - Draw small dots as zero-length strokes: `M7 7.5h.01`.
   - Aim for 2 to 4 shapes. The icon renders at 32px and must read at a glance.
   - Generic pictograms only. Do not reproduce vendor or project logos.
   - Make it distinguishable from its neighbours (see `k8s` vs `registry`).
3. Add a tile for it to the icon grid in `diagrams/catalog.html`.
4. Add the name to the icon list in `README.md`.
5. Run `./build.sh`, open `dist/catalog.html` in a browser and look at the new
   icon next to the others on both cards. An icon is not done until someone
   has looked at it rendered; path data that seems right often is not.

Likely useful next: clock, alert, globe, mail, terminal, chart.

## Adding a component

1. Add its CSS to `library.html`, following the constraints above. Prefer a
   modifier class on an existing component over a new component.
2. Take the accent from `--c` so the colour modifiers (`dd-amber` and so on)
   apply to it automatically.
3. Show it in the light-card section of `diagrams/catalog.html`.
4. Document the class in the README table.

## Adding a diagram

1. Create `diagrams/NAME.html` with a single `<div class="dd" role="img"
   aria-label="...">` root. The label is one or two sentences saying what the
   diagram shows, for screen readers. Start
   from `diagrams/version-flow.html`, or `diagrams/network-topology.html` for
   branching.
2. Reference icons with `<svg class="dd-ico"><use href="#dd-i-NAME"/></svg>`.
3. Sequence the animation with `style="--d:..."` on nodes and links. Step n
   fires at n x 1.5s when `--t` is the default 6s.
4. Run `./build.sh` and open `dist/NAME.html`.

## Timing model and its limit

`dd-flow` (the moving dots on `dd-wireless` links) runs continuously and is not
part of the step sequence. Everything below is about the sequenced animations.

The sequenced animations (`dd-go`, `dd-back`, `dd-down`, `dd-up`, `dd-pulse`)
are active for one step, then idle for the rest of the loop. A step is 1.5s.
The default loop is 4 steps (`--t:6s`); `dd-steps-6` and `dd-steps-8` on the
`.dd` root give 6 or 8. They work by pointing the `--go`, `--bk`, `--dn`,
`--up` and `--pu` variables at numbered keyframes, so always reference
keyframes through those variables, never by name. A `dd-reqres` link uses two
steps. If a chain needs more than 8 steps, add another numbered keyframe set
and `dd-steps-N` rule the same way; do not shorten delays to squeeze it in.

## Before you finish

- `./build.sh` exits 0. It fails on an icon that is used but not defined, an
  icon missing from the catalog, or a diagram root without a description.
- You opened the affected `dist/` files in a browser, or you say plainly that
  you did not.
- README tables and lists match what is in `library.html`.
