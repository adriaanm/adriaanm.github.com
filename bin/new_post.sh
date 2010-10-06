#!/bin/bash


if [[ $# -ne 1 ]] ; then
  cat <<-END
	Needs one argument: new post title, eg
	$0  big_news 
	END
  exit 1
fi

title=$1

date=$(date +%Y-%m-%d)
file=_posts/$date-$title.textile
cat > $file <<END
---
layout: default
---
END

exec ${EDITOR:-vim} $file 
