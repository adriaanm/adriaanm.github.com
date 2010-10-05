---
title: Home

section: Home
---


Teaching
========
<ul>
{% for p in site.categories.teaching limit:3 %}
<li>
	<a href="{{ p.url }}">{{ p.title }}</a>
	<span class="date">{{ p.date | date_to_string }}</span> 
</li>
{% endfor %}
</ul>

Research
========

