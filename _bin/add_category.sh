#!/bin/bash

# all posts go into /_posts, they decide in which category they are in their YAML

if [[ $# -ne 1 ]] ; then
  cat <<-END
	Needs one argument: section name, eg
	$0 some/nested/section/
	END
  exit 1
fi

section=$1

mkdir -p $section
cat > $section/index.textile <<END
---
layout: index
subcategories: []
categories: [$section]
---
END

echo Remember to update the subcategories in the YAML header of the parent section

# # if sections already set
# sed -i -e "s/subcategories: \[\(.*\)\]/subcategories: [\1, $section]/" $base_dir/index.markdown
# # if sections empty
# sed -i -e "s/subcategories: \[\(\)\]/subcategories: [$section]/" $base_dir/index.markdown
