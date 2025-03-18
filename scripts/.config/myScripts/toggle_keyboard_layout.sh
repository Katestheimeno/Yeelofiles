
#!/bin/env bash
# Function to check for an external keyboard
check_keyboard() {
	# List USB devices and check for keywords like "keyboard"
	external_keyboard=$(lsusb | grep -i "keyboard")

	if [[ -n "$external_keyboard" ]]; then
		return 0 # External keyboard found
	else
		return 1 # No external keyboard found
	fi
}

# Main logic
if check_keyboard; then
	setxkbmap us
else
	setxkbmap -option ctrl:swapcaps
	setxkbmap fr
fi
