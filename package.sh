#!/bin/sh

which realpath >/dev/null || exit 2
which zip >/dev/null || exit 3

d="$(date +%F)"
cd "$(realpath "${0%/*}")"/..
zip -9 -ru Hiui-"$d".zip Hiui -x "Hiui/units/*" -x "Hiui/disabled/*" -x "Hiui/Textures/256x256 scratchboard.pdn" -x "Hiui/Textures/focus*" -x "Hiui/Textures/topbar*" -x "Hiui/hiui.code-workspace" -x "Hiui/.git/*" -x "Hiui/.vscode/*" -x "Hiui/.gitignore" -x "Hiui/README.md" -x "Hiui/package.sh"
