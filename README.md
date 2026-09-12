# Radyalz Bar Control

A graphical control layer for the [Omarchy](https://omarchy.org) bar. It replaces
the stock `omarchy.bar` with a drop-in clone that adds **animated autohide**, a
**motion / easing editor**, **placement**, **island appearance**, **bar sizing**,
**custom colours**, plus a compact bar popover and a full settings window — all
without leaving the desktop.

![version](https://img.shields.io/badge/version-0.4.6-8a63d2)
![license](https://img.shields.io/badge/license-MIT-4c9a6b)
![platform](https://img.shields.io/badge/platform-Omarchy%20%2F%20Quickshell-3b7dd8)
[![latest release](https://img.shields.io/github/v/release/radyalz/omarchy-bar-control?label=github%20release)](https://github.com/radyalz/omarchy-bar-control/releases)
[![issues](https://img.shields.io/github/issues/radyalz/omarchy-bar-control)](https://github.com/radyalz/omarchy-bar-control/issues)

> **Status:** early, moving fast. It works on my machine (Arch + Omarchy +
> Quickshell 0.3.1) and is usable day to day, but expect rough edges. See
> [About the author](#about-the-author) and
> [Known limitations](#known-limitations).

---

## Demo

<!-- Drop short screen recordings here. Suggested clips: -->
<!-- assets/autohide.gif     - bar sliding away and revealing from the edge -->
<!-- assets/motion-curve.gif - dragging the cubic-bezier handles + live preview -->
<!-- assets/colors.gif       - Follow theme vs Custom + the colour picker -->

| Autohide + reveal | Motion curve editor | Custom colours |
| --- | --- | --- |
| ![autohide](assets/autohide.gif) | ![motion](assets/motion-curve.gif) | ![colors](assets/colors.gif) |

*(GIFs live in `assets/`; if you're reading this before they're added, the images
above will be broken links.)*

---

## What it does

- **Animated autohide** — the bar slides and/or fades out of view and comes back
  when the pointer touches a thin trigger strip along the screen edge. Trigger
  thickness is adjustable, and the strip briefly lights up in the theme accent
  while you tune it.
- **Motion editor** — Smooth / Snappy / Soft presets, separate show/hide slide
  and fade durations (50 ms steps), an easing family, or a full custom cubic
  Bézier curve you can drag on a graph or type as control points, with a live
  preview.
- **Placement** — dock to any screen edge; left/right turn it into a vertical
  bar. A slide-distance control sets how far it travels off screen when hiding.
- **Island appearance** — override the edge margin, padding, gap, inset, corner
  radius and opacity of the per-widget "islands", or leave it following the
  theme.
- **Bar size** — override bar thickness and an icon scale (best effort, since
  some Omarchy widgets size their own icons).
- **Glass islands** — a light sheen and edge highlight over each island.
  Looks best paired with a transparent bar and compositor blur (Hyprland's own
  blur, or the omablur plugin) behind it.
- **Colours** — follow the active Omarchy theme, or switch to Custom and edit
  the bar background, island background, foreground/text and accent with an HSV
  picker (hue, saturation/value, opacity, hex). Custom starts seeded from the
  current theme colours.
- **Two surfaces** — a compact bar popover for quick toggles, and a full
  settings window with collapsible sections, per-section reset, and a
  diagnostics page.
- **Update check** — the diagnostics page can compare the installed version
  against the latest GitHub release.

Settings are shared live between the bar, the popover and the settings window.

---

## Requirements

- Omarchy with its Quickshell-based shell (`omarchy-shell`, Quickshell 0.3.1).
- The stock `omarchy.bar` plugin present at
  `/usr/share/omarchy/shell/plugins/bar` (used to seed the runtime on a clean
  install).
- `python` and `bash` (used by the install/uninstall scripts).

---

## Install

```sh
./install.sh
```

The installer stops the shell, seeds the plugin runtime from the current stock
bar, overlays this project's files, points `shell.json` at the new bar, and
restarts the shell. It asks one question: where the optional bar settings button
should go (left / center / right / app-launcher only). A desktop entry named
**Radyalz Bar Control** is always installed as a fallback.

Non-interactive:

```sh
./install.sh --launcher left     # or center | right | app
```

### Update

Download the latest release and run `./install.sh` again — it replaces the
plugin files in place and keeps your settings.

### Uninstall

```sh
./uninstall.sh
```

Restores `omarchy.bar`, removes the plugin (including its popover bar widget) and
the desktop entry. Your settings file is kept.

---

## Settings

Opened from the bar popover's **Open advanced editor**, the bar settings button,
the **Radyalz Bar Control** app entry, or:

```sh
radyalz-bar-control-settings
```

| Page | Contents |
| --- | --- |
| **Autohide & motion** | autohide master switch, feel/type/easing presets, reveal trigger, show timing, hide timing, motion curve |
| **Placement & appearance** | screen edge, slide distance, surface (transparent), island geometry, bar size, colours |
| **Diagnostics** | plugin health checks, GitHub update check, a copyable diagnostic report |
| **About & support** | version, links, support notes |

### Where settings live

```
~/.config/omarchy/radyalz-bar-control.json
```

Kept **outside** the plugin directory so an Omarchy or plugin update can replace
the plugin without touching your choices. Uninstall leaves this file in place.

---

## How it's built

One plugin, id `radyalz.bar-control`, with kinds `bar` / `service` / `panel` /
`bar-widget`:

| File / dir | Role |
| --- | --- |
| `Bar.qml` | the replacement bar + autohide runtime |
| `Service.qml` | owns reading/writing the settings file |
| `SettingsPanel.qml`, `components/`, `pages/` | the settings window |
| `launcher/` | the compact bar popover (a `bar-widget`) |
| `Version.js` | single source of truth for the displayed version |

Because Omarchy 4 exposes `shell.bar` as read-only, per-surface state, the three
surfaces stay in sync through that one JSON file, watched for changes and written
with a read-modify-write merge.

---

## Known limitations

- **Icon scale is best effort.** Omarchy's icon widgets read sizing straight
  from the `Style` singleton; the plugin nudges that globally and re-applies
  on the next settings change, so a bare theme switch clears it until you
  touch a setting again. Shell-wide text scaling is deliberately not done from
  here — mutating the shell's base font size crashed Quickshell 0.3.1 during
  plugin load, so icon scale now also covers the bar's own icon-label text.
- **Glass islands is a visual sheen, not real blur.** Actual blur-behind comes
  from the compositor (Hyprland's own blur, or the omablur plugin); this
  plugin has no way to reach into that from a Quickshell overlay.
- Custom colours cover the bar surface, islands, foreground and accent; a few
  accent uses elsewhere in the shell won't follow.
- The update check reads the GitHub releases API (unauthenticated, IP
  rate-limited) and opens the release page — it does not auto-install.
- Built and tested on a single machine. Multi-monitor and non-default themes get
  much less coverage.

---

## About the author

I'm new to Linux. Everything here was built from scratch while learning Omarchy,
Quickshell and QML, so it is **not** guaranteed to be idiomatic or bug-free. If
you hit something broken or confusing, please
[open an issue](https://github.com/radyalz/omarchy-bar-control/issues) with your
Omarchy / Quickshell versions and, ideally, the text from the **Diagnostics**
page — it helps a lot with testing.

---

## License

MIT. See [`LICENSE`](LICENSE).
