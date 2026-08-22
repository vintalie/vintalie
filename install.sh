#!/bin/bash

echo "🚀 Atualizando projeto Jekyll com blog e categorias..."

# ===== 1. CRIAR DIRETÓRIOS =====
mkdir -p blog categories _layouts _includes _data

# ===== 2. CRIAR PÁGINAS =====

# --- blog/index.html ---
cat > blog/index.html <<'EOF'
---
layout: default
title: Blog – Vintalie
permalink: /blog/
---

<section class="blog-archive">
  <h1 class="section-title">Blog <span>Vintalie</span></h1>
  <p class="section-sub">Artigos sobre marketing, tecnologia, dados e estratégia.</p>

  <div class="cards-grid">
    {% for post in site.posts %}
      <article class="glass-card">
        <h3><a href="{{ post.url | relative_url }}" style="color:inherit;text-decoration:none;">{{ post.title }}</a></h3>
        <p>{{ post.excerpt | strip_html | truncatewords: 20 }}</p>
        <div style="display:flex; justify-content:space-between; align-items:center; margin-top:0.8rem;">
          <small>{{ post.date | date: "%d/%m/%Y" }}</small>
          <span style="color:#A98BFF; font-size:0.85rem;">
            {% for category in post.categories %}
              <a href="{{ '/categories/' | append: category | slugify | relative_url }}" style="color:#A98BFF;">#{{ category }}</a>{% unless forloop.last %}, {% endunless %}
            {% endfor %}
          </span>
        </div>
      </article>
    {% endfor %}
  </div>
</section>
EOF

# --- categories/index.html ---
cat > categories/index.html <<'EOF'
---
layout: default
title: Categorias – Vintalie
permalink: /categories/
---

<section class="categories-list">
  <h1 class="section-title">Categorias <span>do blog</span></h1>
  <p class="section-sub">Navegue pelos artigos por assunto.</p>

  <div class="cards-grid">
    {% assign categories = site.posts | map: "categories" | uniq | sort %}
    {% for category in categories %}
      {% if category != "" %}
        {% assign slug = category | slugify %}
        {% assign posts_count = site.posts | where: "categories", category | size %}
        <div class="glass-card">
          <i class="fas fa-folder-open" style="font-size:2rem;"></i>
          <h3><a href="{{ '/categories/' | append: slug | relative_url }}" style="color:inherit;text-decoration:none;">{{ category | capitalize }}</a></h3>
          <p>{{ posts_count }} post{% if posts_count > 1 %}s{% endif %}</p>
        </div>
      {% endif %}
    {% endfor %}
  </div>
</section>
EOF

# --- _layouts/category.html ---
cat > _layouts/category.html <<'EOF'
---
layout: default
---

<section class="category-archive">
  <h1 class="section-title">Categoria: <span>{{ page.category | capitalize }}</span></h1>
  <p class="section-sub">{{ page.category_description | default: "Artigos sobre " | append: page.category }}</p>

  <div class="cards-grid">
    {% assign posts = site.posts | where: "categories", page.category %}
    {% for post in posts %}
      <article class="glass-card">
        <h3><a href="{{ post.url | relative_url }}" style="color:inherit;text-decoration:none;">{{ post.title }}</a></h3>
        <p>{{ post.excerpt | strip_html | truncatewords: 20 }}</p>
        <small>{{ post.date | date: "%d/%m/%Y" }}</small>
      </article>
    {% endfor %}
  </div>

  <p style="text-align:center; margin-top:2rem;">
    <a href="{{ '/categories/' | relative_url }}" class="btn-primary" style="display:inline-block;">← Ver todas as categorias</a>
  </p>
</section>
EOF

# --- _data/categories.yml (descrições opcionais) ---
cat > _data/categories.yml <<'EOF'
marketing: "Estratégias e campanhas de marketing digital"
estrategia: "Planejamento e posicionamento de mercado"
dados: "Análise de dados e business intelligence"
tecnologia: "Ferramentas, automação e desenvolvimento"
EOF

# ===== 3. CRIAR PÁGINAS DE CATEGORIA DE EXEMPLO =====
mkdir -p categories
cat > categories/marketing.md <<'EOF'
---
layout: category
title: Marketing
permalink: /categories/marketing/
category: marketing
category_description: "Tudo sobre marketing digital, campanhas, SEO e redes sociais."
---
EOF

cat > categories/estrategia.md <<'EOF'
---
layout: category
title: Estratégia
permalink: /categories/estrategia/
category: estrategia
category_description: "Planejamento estratégico, posicionamento e análise de mercado."
---
EOF

cat > categories/dados.md <<'EOF'
---
layout: category
title: Dados
permalink: /categories/dados/
category: dados
category_description: "Inteligência de dados, analytics e dashboards."
---
EOF

cat > categories/tecnologia.md <<'EOF'
---
layout: category
title: Tecnologia
permalink: /categories/tecnologia/
category: tecnologia
category_description: "Automação, desenvolvimento, ferramentas digitais."
---
EOF

# ===== 4. ATUALIZAR ARQUIVOS EXISTENTES (substituir por versões com links) =====

# --- _includes/header.html (com link para Blog) ---
cat > _includes/header.html <<'EOF'
<header class="glass-header">
  <div class="menu-group">
    <a href="#servicos" class="menu-item">Serviços</a>
    <a href="/blog/" class="menu-item">Blog</a>
    <a href="/categories/" class="menu-item">Categorias</a>
  </div>
  <div class="logo">V<span>intalie</span></div>
  <div class="menu-group">
    <a href="#sobre" class="menu-item">Sobre</a>
    <a href="#contato" class="menu-item">Contato</a>
    <button class="btn-glass" onclick="document.getElementById('lead-form').scrollIntoView({behavior:'smooth'})">
      <i class="fas fa-rocket" style="margin-right:6px;"></i>Fale Conosco
    </button>
  </div>
</header>
EOF

# --- _includes/footer.html (com links para Blog e Categorias) ---
cat > _includes/footer.html <<'EOF'
<footer class="footer-glass">
  <div class="footer-grid">
    <div class="footer-col brand-col">
      <div class="footer-logo">V<span>intalie</span></div>
      <p class="footer-tagline">Ideias que movem marcas.</p>
      <p class="footer-desc">
        Transformamos desafios de comunicação em soluções criativas,
        estratégicas e orientadas a dados.
      </p>
      <div class="footer-social">
        <a href="#"><i class="fab fa-instagram"></i></a>
        <a href="#"><i class="fab fa-linkedin-in"></i></a>
        <a href="#"><i class="fab fa-youtube"></i></a>
        <a href="#"><i class="fab fa-x-twitter"></i></a>
      </div>
    </div>
    <div class="footer-col">
      <h4>Navegação</h4>
      <ul class="footer-links">
        <li><a href="#servicos">Serviços</a></li>
        <li><a href="/blog/">Blog</a></li>
        <li><a href="/categories/">Categorias</a></li>
        <li><a href="#sobre">Sobre Nós</a></li>
        <li><a href="#contato">Contato</a></li>
        <li><a href="#lead-form">Trabalhe Conosco</a></li>
      </ul>
    </div>
    <div class="footer-col">
      <h4>Nossas Soluções</h4>
      <ul class="footer-links">
        <li><a href="#">Estratégia Digital</a></li>
        <li><a href="#">Branding & Identidade</a></li>
        <li><a href="#">Marketing de Performance</a></li>
        <li><a href="#">Tecnologia & Automação</a></li>
        <li><a href="#">Inteligência de Dados</a></li>
      </ul>
    </div>
    <div class="footer-col">
      <h4>Fale com a gente</h4>
      <ul class="footer-contact">
        <li><i class="fas fa-envelope"></i><a href="mailto:contato@vintalie.com">contato@vintalie.com</a></li>
        <li><i class="fas fa-phone-alt"></i><a href="tel:+5511999999999">+55 (11) 99999-9999</a></li>
        <li><i class="fas fa-map-marker-alt"></i><span>São Paulo, SP — Brasil</span></li>
      </ul>
      <a href="#lead-form" class="footer-cta">
        <i class="fas fa-paper-plane"></i> Vamos evoluir sua marca?
      </a>
    </div>
  </div>
  <div class="footer-bottom">
    <p>&copy; 2026 Vintalie — Soluções Digitais. Todos os direitos reservados.</p>
    <div class="footer-legal">
      <a href="#">Política de Privacidade</a>
      <span>|</span>
      <a href="#">Termos de Uso</a>
    </div>
  </div>
</footer>
EOF

# --- index.html (com link "Ver todos os posts" após a seção de blog) ---
# Vamos substituir o index.html inteiro com a versão que inclui a seção de blog e o link.
cat > index.html <<'EOF'
---
layout: default
title: Início
---

{% include hero.html %}
{% include servicos.html %}
{% include testimonials.html %}

<!-- Últimos posts do blog -->
<section id="blog" style="margin-top:4rem;">
  <h2 class="section-title">Últimas <span>do blog</span></h2>
  <div class="cards-grid">
    {% for post in site.posts limit:3 %}
      <article class="glass-card">
        <h3><a href="{{ post.url | relative_url }}" style="color:inherit;text-decoration:none;">{{ post.title }}</a></h3>
        <p>{{ post.excerpt | strip_html | truncatewords: 20 }}</p>
        <small>{{ post.date | date: "%d/%m/%Y" }}</small>
      </article>
    {% endfor %}
  </div>
  <p style="text-align:center; margin-top:1.5rem;">
    <a href="{{ '/blog/' | relative_url }}" class="btn-primary" style="display:inline-block;">Ver todos os posts →</a>
  </p>
</section>

{% include lead-form.html %}
EOF

# ===== 5. ATUALIZAR _config.yml (se necessário) =====
# Adiciona defaults para categorias se não existirem
if ! grep -q 'layout: category' _config.yml; then
  cat >> _config.yml <<'EOC'

# Defaults para páginas de categoria
defaults:
  - scope:
      path: "categories/*.md"
    values:
      layout: "category"
EOC
  echo "✅ _config.yml atualizado com defaults para categorias."
fi

echo ""
echo "✅ Atualização concluída com sucesso!"
echo ""
echo "📂 Novas páginas:"
echo "   /blog/            – Lista todos os posts"
echo "   /categories/      – Lista todas as categorias"
echo "   /categories/marketing/ – Posts da categoria marketing"
echo ""
echo "🔗 Links adicionados no header e footer."
echo ""
echo "👉 Execute: bundle exec jekyll serve"
