#!/bin/bash

memory_usage=$(free | awk '/Mem/{printf("%.1fG/%.1fG"), $3/1024/1024,$2/1024/1024}')
echo "MEM:$memory_usage"

exit 0
