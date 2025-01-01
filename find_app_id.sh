#!/bin/bash

find ~/Library/Developer/CoreSimulator/Devices/F82B1E2B-FED1-4138-B3E2-F3B34E2E1F07/data/Containers/Data/Application/ -type f -exec ls -lt {} + | awk '{print $NF}' | xargs -I {} dirname {} | sort | uniq
