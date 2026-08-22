#!/bin/bash

echo "🔄 Atualizando pasta blog com categorias e paginação..."

# 1. Adicionar plugin ao Gemfile
if ! grep -q "jekyll-paginate-v2" Gemfile; then
  echo "Adicionando jekyll-paginate-v2 ao Gemfile..."
  echo "gem 'jekyll-paginate-v2'" >> Gemfile
fi

# 2. Configurar _config.yml (paginação)
if ! grep -q "^pagination:" _config.yml; then
  echo "" >> _config.yml
  echo "# Configurações de paginação" >> _config.yml
  echo "pagination:" >> _config.yml
  echo "  enabled: true" >> _config.yml
  echo "  per_page: 5" >> _config.yml
  echo "  permalink: '/page/:num/'" >> _config.yml
  echo "  title_suffix: ' - página :num'" >> _config.yml
  echo "  limit: 0" >> _config.yml
  echo "  sort_field: 'date'" >> _config.yml
  echo "  sort_reverse: true" >> _config.yml
  echo "✅ _config.yml atualizado com paginação."
else
  echo "ℹ️ Paginação já configurada no _config.yml"
fi

# 3. Criar layouts
mkdir -p _layouts

# Layout para a página principal do blog (com paginação e menu de categorias)
cat > _layouts/blog.html << 'EOF'
---
layout: default
---

<div class="blog-archive">
  <h1 class="section-title">Blog <span>Vintalie</span></h1>
  <p class="section-sub">Artigos sobre marketing, tecnologia, dados e estratégia.</p>

  <!-- Menu de categorias -->
  <div class="category-menu" style="display:flex; flex-wrap:wrap; gap:0.8rem; justify-content:center; margin-bottom:2rem;">
    <a href="{{ '/blog/' | relative_url }}" class="btn-glass" style="background:rgba(169,139,255,0.15);">Todos</a>
    {% assign categories = site.posts | map: "categories" | uniq | sort %}
    {% for cat in categories %}
      {% if cat != "" %}
        {% assign slug = cat | slugify %}
        <a href="{{ '/blog/categoria/' | append: slug | relative_url }}" class="btn-glass">{{ cat | capitalize }}</a>
      {% endif %}
    {% endfor %}
  </div>

  <div class="cards-grid">
    {% for post in paginator.posts %}
      <article class="glass-card">
        <h3><a href="{{ post.url | relative_url }}" style="color:inherit;text-decoration:none;">{{ post.title }}</a></h3>
        <p>{{ post.excerpt | strip_html | truncatewords: 20 }}</p>
        <div style="display:flex; justify-content:space-between; align-items:center; margin-top:0.8rem;">
          <small>{{ post.date | date: "%d/%m/%Y" }}</small>
          <span style="color:#A98BFF; font-size:0.85rem;">
            {% for category in post.categories %}
              <a href="{{ '/blog/categoria/' | append: category | slugify | relative_url }}" style="color:#A98BFF;">#{{ category }}</a>{% unless forloop.last %}, {% endunless %}
            {% endfor %}
          </span>
        </div>
      </article>
    {% endfor %}
  </div>

  <!-- Paginação -->
  {% if paginator.total_pages > 1 %}
  <div class="pagination" style="display:flex; justify-content:center; gap:0.5rem; margin-top:2rem; flex-wrap:wrap;">
    {% if paginator.previous_page %}
      <a href="{{ paginator.previous_page_path }}" class="btn-glass">&laquo; Anterior</a>
    {% endif %}
    {% for page in (1..paginator.total_pages) %}
      {% if page == paginator.page %}
        <span class="btn-glass" style="background:rgba(169,139,255,0.2); border-color:#A98BFF;">{{ page }}</span>
      {% else %}
        <a href="{{ paginator.paginate_path | replace: ':num', page }}" class="btn-glass">{{ page }}</a>
      {% endif %}
    {% endfor %}
    {% if paginator.next_page %}
      <a href="{{ paginator.next_page_path }}" class="btn-glass">Próximo &raquo;</a>
    {% endif %}
  </div>
  {% endif %}
</div>
EOF

# Layout para páginas de categoria (com paginação filtrada)
cat > _layouts/category.html << 'EOF'
---
layout: default
---

<div class="category-archive">
  <h1 class="section-title">Categoria: <span>{{ page.category | capitalize }}</span></h1>
  <p class="section-sub">Artigos sobre {{ page.category_description | default: page.category }}</p>

  <div class="cards-grid">
    {% for post in paginator.posts %}
      <article class="glass-card">
        <h3><a href="{{ post.url | relative_url }}" style="color:inherit;text-decoration:none;">{{ post.title }}</a></h3>
        <p>{{ post.excerpt | strip_html | truncatewords: 20 }}</p>
        <small>{{ post.date | date: "%d/%m/%Y" }}</small>
      </article>
    {% endfor %}
  </div>

  <!-- Paginação -->
  {% if paginator.total_pages > 1 %}
  <div class="pagination" style="display:flex; justify-content:center; gap:0.5rem; margin-top:2rem; flex-wrap:wrap;">
    {% if paginator.previous_page %}
      <a href="{{ paginator.previous_page_path }}" class="btn-glass">&laquo; Anterior</a>
    {% endif %}
    {% for page in (1..paginator.total_pages) %}
      {% if page == paginator.page %}
        <span class="btn-glass" style="background:rgba(169,139,255,0.2); border-color:#A98BFF;">{{ page }}</span>
      {% else %}
        <a href="{{ paginator.paginate_path | replace: ':num', page }}" class="btn-glass">{{ page }}</a>
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

# 4. Criar blog/index.html (página principal com paginação)
mkdir -p blog
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

# 5. Criar páginas de categoria dentro de blog/categoria/
mkdir -p blog/categoria

# Extrair categorias dos posts existentes
echo "Extraindo categorias dos posts..."
if [ -d "_posts" ]; then
  categories=$(grep -rh "^categories:" _posts/ 2>/dev/null | sed 's/categories: \[\(.*\)\]/\1/' | tr ',' '\n' | sed 's/^[ \t]*//;s/[ \t]*$//' | sort -u)
else
  categories=""
fi

if [ -z "$categories" ]; then
  echo "Nenhuma categoria encontrada. Criando categorias de exemplo..."
  categories="marketing estrategia dados tecnologia"
fi

for cat in $categories; do
  slug=$(echo $cat | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
  catfile="blog/categoria/${slug}.md"
  if [ ! -f "$catfile" ]; then
    echo "Criando página para categoria: $cat"
    cat > "$catfile" << EOF
---
layout: category
title: $cat
category: $cat
category_description: "Artigos sobre $cat"
pagination:
  category: $cat
  enabled: true
  per_page: 5
  permalink: '/page/:num/'
  title_suffix: ' - página :num'
---
EOF
  else
    echo "Página para categoria $cat já existe."
  fi
done

echo ""
echo "✅ Blog atualizado com categorias e paginação!"
echo ""
echo "📂 Estrutura:"
echo "   /blog/                – Página principal (paginação)"
echo "   /blog/categoria/      – Páginas de categoria"
echo ""
echo "👉 Execute os comandos:"
echo "   bundle install"
echo "   bundle exec jekyll serve"

