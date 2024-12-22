---

title: The xPack CMake releases
permalink: /dev-tools/cmake/releases/

search: exclude
github_editme: false

comments: false
toc: false

date: 2020-09-29 14:05:00 +0300

redirect_to: https://xpack-dev-tools.github.io/cmake-xpack/docs/releases/

---

___
{% for post in site.posts %}{% if post.categories contains "releases" %}{% if post.categories contains "cmake" %}
* [{{ post.title }}]({{ site.baseurl }}{{ post.url }}) [(download)]({{ post.download_url }}){% endif %}{% endif %}{% endfor %}
