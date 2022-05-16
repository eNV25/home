#!/bin/bash

<(
	jq '
		.colors["terminal.foreground"],
		.colors["terminal.ansiBlack"],
		.colors["terminal.ansiRed"],
		.colors["terminal.ansiGreen"],
		.colors["terminal.ansiYellow"],
		.colors["terminal.ansiBlue"],
		.colors["terminal.ansiMagenta"],
		.colors["terminal.ansiCyan"],
		.colors["terminal.ansiWhite"],
		.colors["terminal.ansiBrightBlack"],
		.colors["terminal.ansiBrightRed"],
		.colors["terminal.ansiBrightGreen"],
		.colors["terminal.ansiBrightYellow"],
		.colors["terminal.ansiBrightBlue"],
		.colors["terminal.ansiBrightMagenta"],
		.colors["terminal.ansiBrightCyan"],
		.colors["terminal.ansiBrightWhite"]
	' "$1"
)
