# Polar Aurora — Waterfox theme

A static WebExtension theme. It colours the browser chrome: tabs, toolbar,
address bar, menus, sidebar, and the new tab page. It does not colour web
page content.

## Build

    cd polar-aurora && zip -r ../polar-aurora.xpi manifest.json

## Install

Waterfox does not require signed extensions.

1. Open `about:config` and confirm `xpinstall.signatures.required` is `false`.
2. Open `about:addons`.
3. Click the gear icon, then click **Install Add-on From File**.
4. Select `polar-aurora.xpi`.
5. Open the **Themes** tab and enable **Polar Aurora**.

## Test without an install

Open `about:debugging#/runtime/this-firefox`, click **Load Temporary Add-on**,
and select `polar-aurora/manifest.json`. Waterfox removes the theme when you
close it.
