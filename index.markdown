---
layout: default
title: Adriaan Moors's homepage

section: Home
---

Adriaan Moors
=============
I'm a post-doc working on the [Scala programming language](http://scala-lang.org) in [Martin Odersky's lab](http://lamp.epfl.ch). My [EPFL homepage](http://people.epfl.ch/adriaan.moors) has my work contact info. Google will tell you all about [personal-me](http://www.google.com/profiles/adriaanm).

I'm interested in exploiting types to make programming more productive.

Concretely, my colleagues and I are working on (in decreasing order of personal involvement):
1. Improving Scala's type inference and implicit search algorithms
1. Virtualizing Scala to optimize embedded Domain Specific Languages
1. A practical effect system for Scala
1. Type debugging for Scala

I spend a fair amount of time hacking scalac, particularly fixing bugs in the type checker. If you have a ticket that's assigned to me (I'm "moors" in [trac](http://lampsvn.epfl.ch/trac/scala/)), but which isn't in trunk yet, maybe it's already fixed in [my fork](http://github.com/adriaanm/scala) of the official Scala repository. The branch you're looking for is ticket/NNNN.

Research
========
I hope to find time to write down some of the stuff I'm working on. In the meantime, please check [DBLP](http://www.informatik.uni-trier.de/~ley/db/indices/a-tree/m/Moors:Adriaan.html), ask [Google Scholar](scholar.google.com/scholar?q=author:adriaan+moors), or have a look at [our lab's publication page](http://lamp.epfl.ch/publications/index.html.en).

<div id="post_links"><ul>
{% for p in site.categories.research limit:3 %}
<li>
	<a href="{{ p.url }}">{{ p.title }}</a>
	<span class="date">{{ p.date | date_to_string }}</span> 
</li>
{% endfor %}
</ul></div id="post_links">

{% comment %}
TODO: add entry for dissertation, parser combinator techreport,...
{% endcomment %}

Teaching
========
<div id="post_links"><ul>
{% for p in site.categories.teaching limit:3 %}
<li>
	<a href="{{ p.url }}">{{ p.title }}</a>
</li>
{% endfor %}
</ul></div id="post_links">


{% comment %}
Professional Activities
=======================
PC member: WGP 2008, ScalaDays 2009, FTfJP 2010 
(sub-)reviewing: JFP (special issues for MSFP 2006, WGP 2009), ICFP 2009, OOPSLA 2009, ECOOP 2010, FOOL 2010

Archive
=======
<div id="post_links"><ul>
{% for p in site.posts %}
<li><span>{{ post.date | date_to_string }}</span>  <a href="{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}
</ul></div id="post_links">
{% endcomment %}

-------------
PS: Sorry about the spartan layout. Maybe some day I'll have time to dress up my dr. [Jekyll](http://github.com/mojombo/jekyll/wiki) with some [octopress](http://github.com/imathis/octopress) or [jekyll-base](http://github.com/raphinou/jekyll-base).