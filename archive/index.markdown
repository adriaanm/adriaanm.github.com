---
layout: default
title: Archive
categories: [archive]
---

Archive
=======

<ul class="archive">
{% for post in site.posts %}
<li class="archive"><span>{{ post.date | date_to_string }}</span>
  <a href="{{ post.url }}" class="post-title">{{ post.title |  remove:"'" }}</a>
</li>
{% endfor %}
</ul>