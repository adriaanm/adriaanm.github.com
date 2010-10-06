---
layout: default
title: Archive
---

Archive
=======

<div id="post_links">
<ul>
{% for post in site.posts %}
<li><span>{{ post.date | date_to_string }}</span><a href="{{ post.url }}">{{ post.title }}</a></li>
{% endfor %}
</ul>
</div>