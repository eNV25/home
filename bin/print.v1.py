#!/usr/bin/python3
import argparse

parser = argparse.ArgumentParser()
parser.add_argument(
    "file",
    nargs="?",
    default="/dev/stdin",
)

if __name__ == "__main__":
    with open(parser.parse_args().file) as f:
        print(
            f.read()
            .replace("\a", "\\a")
            .replace("\b", "\\b")
            .replace("\f", "\\f")
            .replace("\n", "\\n")
            .replace("\r", "\\r")
            .replace("\t", "\\t")
            .replace("\v", "\\v")
        )
