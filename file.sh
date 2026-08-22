#!/bin/bash

echo "🔧 Corrigindo listagem de categorias no blog..."

# 1. Adicionar plugin ao Gemfile
if ! grep -q "jekyll-paginate-v2" Gemfile; then
  echo "Adicionando plugin ao Gemfile..."
  echo "gem 'jekyll-paginate-v2'" >> Gemfile
fi

# 2. Configurar _config.yml
if ! grep -q "^plugins:" _config.yml; then
  echo "plugins:" >> _config.yml
  echo "  - jekyll-paginate-v2" >> _config.yml
else
  if ! grep -q "jekyll-paginate-v2" _config.yml; then
    sed -i '/^plugins:/a \ \ - jekyll-paginate-v2' _config.yml
  fi
fi

if ! grep -q "^pagination:" _config.yml; then
  cat << 'EOC' >> _config.yml

pagination:
  enabled: true
  per_page: 5
  permalink: '/page/:num/'
  title_suffix: ' - página :num'
  limit: 0
  sort_field: 'date'
  sort_reverse: true
EOC
fi

# 3. Recriar layout category.html com fallback
cat > _layouts/category.html << 'EOF'
---
layout: default
---

<div class="category-archive">
  <h1 class="section-title">Categoria: <span>{{ page.category | capitalize }}</span></h1>
  <p class="section-sub">{{ page.category_description | default: page.category }}</p>

  <!-- Se paginator existir, usa ele; senão, filtra manualmente -->
  {% if paginator %}
    {% assign posts = paginator.posts %}
  {% else %}
    {% assign posts = site.posts | where: "categories", page.category %}
  {% endif %}

  <div class="cards-grid">
    {% for post in posts %}
      <article class="glass-card">
        <h3><a href="{{ post.url | relative_url }}" style="color:inherit;text-decoration:none;">{{ post.title }}</a></h3>
        <p>{{ post.excerpt | strip_html | truncatewords: 20 }}</p>
        <small>{{ post.date | date: "%d/%m/%Y" }}</small>
      </article>
    {% else %}
      <p style="text-align:center; grid-column:1/-1;">Nenhum post encontrado na categoria "{{ page.category }}".</p>
    {% endfor %}
  </div>

  {% if paginator and paginator.total_pages > 1 %}
  <div class="pagination" style="display:flex; justify-content:center; gap:0.5rem; margin-top:2rem; flex-wrap:wrap;">
    {% if paginator.previous_page %}
      <a href="{{ paginator.previous_page_path }}" class="btn-glass">&laquo; Anterior</a>
    {% endif %}
    {% for page_num in (1..paginator.total_pages) %}
      {% if page_num == paginator.page %}
        <span class="btn-glass" style="background:rgba(169,139,255,0.2); border-color:#A98BFF;">{{ page_num }}</span>
      {% else %}
        <a href="{{ paginator.paginate_path | replace: ':num', page_num }}" class="btn-glass">{{ page_num }}</a>
      {% endif %}
    {% endfor %}
    {% if paginator.next_page %}
      <a href="{{ paginator.next_page_path }}" class="btn-glass">Próximo &raquo;</a>
    {% endif %}
  </div>
  {% endif %}

  <p style="text-align:center; margin-top:2rem;">
    <a href="{{ '/blog/' | relative_url }}" class="btn-primary" style="display:inline-block;">← Voltar para o blog</a>
  </p>
</div>
EOF

# 4. Recriar pasta de categorias
rm -rf blog/categoria
mkdir -p blog/categoria

# 5. Extrair categorias dos posts
categories=$(grep -rh "^categories:" _posts/ 2>/dev/null | sed -E 's/categories: *\[([^]]*)\]/\1/' | tr ',' '\n' | sed 's/^[ \t]*//;s/[ \t]*$//' | sort -u)

if [ -z "$categories" ]; then
  echo "Nenhuma categoria encontrada. Criando exemplos..."
  categories="marketing estrategia dados tecnologia"
fi

echo "Categorias encontradas: $categories"

# 6. Criar páginas de categoria
for cat in $categories; do
  if [ -n "$cat" ]; then
    slug=$(echo "$cat" | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
    catfile="blog/categoria/${slug}.md"
    echo "Criando: $catfile"
    cat > "$catfile" << EOF
---
layout: category
title: $cat
category: $cat
category_description: "Artigos sobre $cat"
pagination:
  enabled: true
  category: $cat
  per_page: 5
  permalink: '/page/:num/'
  title_suffix: ' - página :num'
---
EOF
  fi
done

# 7. Recriar blog/index.html (página principal com paginação)
cat > blog/index.html << 'EOF'
---
layout: blog
pagination:
  enabled: true
  per_page: 5
  permalink: '/page/:num/'
  title_suffix: ' - página :num'
---
EOF

echo ""
echo "✅ Correção concluída!"
echo ""
echo "📂 Estrutura criada:"
echo "   /blog/                   – Página principal com paginação"
echo "   /blog/categoria/nome/    – Páginas de categoria com fallback"
echo ""
echo "👉 Execute: bundle install && bundle exec jekyll serve"
