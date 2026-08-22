#!/bin/bash

echo "🔧 Corrigindo blog com categorias e paginação..."

# 1. Garantir que o plugin está no Gemfile
if ! grep -q "jekyll-paginate-v2" Gemfile; then
  echo "Adicionando jekyll-paginate-v2 ao Gemfile..."
  echo "gem 'jekyll-paginate-v2'" >> Gemfile
fi

# 2. Atualizar _config.yml com os plugins e paginação
if ! grep -q "^plugins:" _config.yml; then
  echo "Adicionando seção plugins..."
  echo "plugins:" >> _config.yml
  echo "  - jekyll-paginate-v2" >> _config.yml
else
  # Se já existe, adicionar apenas se não estiver presente
  if ! grep -q "jekyll-paginate-v2" _config.yml; then
    sed -i '/^plugins:/a \ \ - jekyll-paginate-v2' _config.yml
  fi
fi

# Configurar paginação (se não existir)
if ! grep -q "^pagination:" _config.yml; then
  cat << 'EOC' >> _config.yml

# Configurações de paginação
pagination:
  enabled: true
  per_page: 5
  permalink: '/page/:num/'
  title_suffix: ' - página :num'
  limit: 0
  sort_field: 'date'
  sort_reverse: true
EOC
  echo "✅ Configuração de paginação adicionada."
else
  echo "ℹ️ Paginação já configurada."
fi

# 3. Recriar layout blog.html (página principal)
mkdir -p _layouts
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

  <!-- Se paginator estiver disponível, usa ele, senão usa todos os posts -->
  {% if paginator %}
    {% assign posts = paginator.posts %}
  {% else %}
    {% assign posts = site.posts %}
  {% endif %}

  <div class="cards-grid">
    {% for post in posts %}
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

  <!-- Paginação (se habilitada) -->
  {% if paginator and paginator.total_pages > 1 %}
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

# 4. Recriar layout category.html (páginas de categoria)
cat > _layouts/category.html << 'EOF'
---
layout: default
---

<div class="category-archive">
  <h1 class="section-title">Categoria: <span>{{ page.category | capitalize }}</span></h1>
  <p class="section-sub">{{ page.category_description | default: page.category }}</p>

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
      <p style="text-align:center; grid-column:1/-1;">Nenhum post encontrado nesta categoria.</p>
    {% endfor %}
  </div>

  <!-- Paginação -->
  {% if paginator and paginator.total_pages > 1 %}
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

# 5. Recriar blog/index.html com paginação ativa
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

# 6. Criar páginas de categoria (baseadas nas categorias existentes)
mkdir -p blog/categoria

# Extrair categorias dos posts
categories=$(grep -rh "^categories:" _posts/ 2>/dev/null | sed -E 's/categories: *\[([^]]*)\]/\1/' | tr ',' '\n' | sed 's/^[ \t]*//;s/[ \t]*$//' | sort -u)

if [ -z "$categories" ]; then
  echo "⚠️ Nenhuma categoria encontrada nos posts. Criando exemplos..."
  categories="marketing estrategia dados tecnologia"
fi

# Remover arquivos antigos para evitar duplicidade
rm -f blog/categoria/*.md

for cat in $categories; do
  if [ -n "$cat" ]; then
    slug=$(echo $cat | tr '[:upper:]' '[:lower:]' | sed 's/ /-/g')
    catfile="blog/categoria/${slug}.md"
    echo "Criando página para categoria: $cat -> $catfile"
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
  fi
done

echo ""
echo "✅ Blog corrigido com categorias e paginação!"
echo ""
echo "📌 Agora execute:"
echo "   bundle install"
echo "   bundle exec jekyll serve"
echo ""
echo "🔗 Acesse: http://localhost:4000/blog/"
