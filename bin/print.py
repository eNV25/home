#!/usr/bin/python3
import argparse

parser = argparse.ArgumentParser()
parser.add_argument(
    "file",
    nargs="?",  # argument is optional
    default="/dev/stdin",
)

if __name__ == "__main__":
    with open(parser.parse_args().file) as f:
        for line in f.readlines():
            print(
                (
                    "{}".format(line)
                    .replace("\a", "\\a\a")
                    .replace("\b", "\\b\b")
                    .replace("\f", "\\f\f")
                    .replace("\n", "\\n\n")
                    .replace("\r", "\\r\r")
                    .replace("\t", "\\t\t")
                    .replace("\v", "\\v\v")
                    .replace("\N{NO-BREAK SPACE}", "␣")
                ),
                end="",
            )
