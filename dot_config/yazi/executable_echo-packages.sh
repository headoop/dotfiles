#!/bin/bash

sed -En 's/^use =\ "(.*)"/\1/p' package.toml
