#!/bin/bash

TOUCHPAD=$(xinput list --name-only | grep -i touchpad)

if [ -n "$TOUCHPAD" ]; then
  DEVICE_ID=$(xinput list --id-only "$TOUCHPAD")

  # Look for the line containing "Tapping Enabled" and extract the property name only
  PROP_NAME=$(xinput list-props "$DEVICE_ID" | grep -i "Tapping Enabled (" | awk -F '(' '{print $1}' | xargs)

  if [ -n "$PROP_NAME" ]; then
    xinput set-prop "$DEVICE_ID" "$PROP_NAME" 1
  fi
fi

