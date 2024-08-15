#!/usr/bin/env sh

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." >/dev/null 2>&1 && pwd )"

trap ctrl_c INT
function ctrl_c {
	exit 0
}

function generate {
	echo "Generating Dad Parts..."
	/Applications/Aseprite.app/Contents/MacOS/aseprite \
		--verbose \
		--batch \
		--all-layers \
		$DIR/assets/dad_parts.aseprite \
		--split-layers \
		--trim \
		--save-as $DIR/assets/dad_parts/{layer}.png

	# clean up layers that shouldn't have been exported
	# (--ignore-layer doesn't work https://github.com/aseprite/aseprite/issues/2026)
	rm "$DIR/assets/dad_parts/Heads.png"
	rm "$DIR/assets/dad_parts/Necks.png"
	rm "$DIR/assets/dad_parts/Torsos.png"
	rm "$DIR/assets/dad_parts/Crotches.png"
	rm "$DIR/assets/dad_parts/Arms L.png"
	rm "$DIR/assets/dad_parts/Arms R.png"
	rm "$DIR/assets/dad_parts/Legs L.png"
	rm "$DIR/assets/dad_parts/Legs R.png"
	rm "$DIR/assets/dad_parts/Faces.png"
	rm "$DIR/assets/dad_parts/Hair Above.png"
	rm "$DIR/assets/dad_parts/Hair Below.png"

	echo "Generating goop spritesheet..."
	/Applications/Aseprite.app/Contents/MacOS/aseprite \
		--batch \
		--all-layers \
		--split-layers \
		$DIR/assets/goops.aseprite \
		--sheet $DIR/assets/goops.png

	echo "DONE"
	echo
}

generate

while true; do
	echo "Watching aseprite files in $DIR/assets..."
	fswatch --one-event -I $DIR/assets/*.aseprite
	generate
done
