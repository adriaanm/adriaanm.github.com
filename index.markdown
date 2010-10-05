---
title: Home

section: Home
---

I'm a post-doc in [Martin Odersky's lab](http://lamp.epfl.ch). We bring you the [Scala programming language](http://scala-lang.org). My [http://people.epfl.ch/adriaan.moors](EPFL homepage) has my work contact info. Google will tell you all about [http://www.google.com/profiles/adriaanm](personal-me).

I'm interested in exploiting types to make programming more productive.

Concretely, my colleagues and I are working on (in decreasing order of personal involvement):
1. Improving Scala's type inference and implicit search algorithms
1. Virtualizing Scala to optimise embedded Domain Specific Languages
1. A practical effect system for Scala
1. Type debugging for Scala


Teaching
========
<ul>
{% for p in site.categories.teaching limit:3 %}
<li>
	<a href="{{ p.url }}">{{ p.title }}</a>
</li>
{% endfor %}
</ul>

Research
========
I hope to find time to write down some of the stuff I'm working on. In the meantime, please check [http://www.informatik.uni-trier.de/~ley/db/indices/a-tree/m/Moors:Adriaan.html](DBLP), ask [scholar.google.com/scholar?q=author:adriaan+moors](Google Scholar), or have a look at [http://lamp.epfl.ch/publications/index.html.en](our lab's publication page).

<ul>
{% for p in site.categories.research limit:3 %}
<li>
	<a href="{{ p.url }}">{{ p.title }}</a>
	<span class="date">{{ p.date | date_to_string }}</span> 
</li>
{% endfor %}
</ul>



-------------
PS: Sorry about the spartan layout. Maybe some day I'll have some time to steal someone's CSS and customize my Jekyll deployment.