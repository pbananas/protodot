#!/usr/bin/env sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

trap ctrl_c INT
function ctrl_c {	exit 0 }

function generate {
	# split layers into individual sprites
	echo "Generating parts..."
	$ASEPRITE_PATH \
		--verbose \
		--batch \
		--all-layers \
		$DIR/components/something/assets/something.aseprite \
		--split-layers \
		--trim \
		--save-as $DIR/components/something/assets/{layer}.png

	# clean up layers from groups that shouldn't have been exported
	# (--ignore-layer doesn't work https://github.com/aseprite/aseprite/issues/2026)
	rm "$DIR/components/something/assets/GroupName.png"

	# generate spritesheet
	echo "Generating spritesheet..."
	$ASEPRITE_PATH \
		--batch \
		--all-layers \
		--split-layers \
		$DIR/components/something/assets/somethingelse.aseprite \
		--sheet $DIR/components/something/assets/somethingelse.png

	echo "DONE"
	echo
}

generate

while true; do
	echo "Watching aseprite files in $DIR/assets..."
	fswatch --one-event -I $DIR/assets/*.aseprite
	generate
done
