# BRIEFING DE ORQUESTRAÇÃO — Redesign Visual Vintalie

> Artefato de entrada para o perfil ORQUESTRADOR.
> Gerado pelo Gerador de Prompts de Orquestração (perfil default).
> O orquestrador é o único dono do plano, da delegação e do estado do projeto.

---

## DEMANDA ORIGINAL

O usuário (Mario) pediu para **refazer o estilo do site** da marca **Vintalie**
(repositório `vintalie`, domínio `vintalie.com.br`, hospedado em GitHub Pages) para
que ele reflita a identidade visual da marca, descrita no JSON de brand guidelines
(paleta roxo→magenta, fonte URW Gothic, fundo branco, gradiente 135°, sem sombras).

O usuário indicou que o site usa o **Jekyll** (https://jekyllrb.com/docs/) como
biblioteca principal e apontou a pasta **/home/mario/vintalie** como fonte dos
arquivos de marca: logo quadrada, logo horizontal completa e background de capa do
Facebook. Observação do usuário: **as logos devem ficar em elemento com fundo branco**,
pois são majoritariamente uma cor em degradê sem borda (transparência no V).

---

## OBJETIVO DO PROJETO

Reconstruir/reestilizar a landing page do site Vintalie aplicando integralmente o
guia de marca, entregando uma página estática (HTML + CSS + assets) pronta para
publicação no GitHub Pages, visualmente coerente com a identidade: **tema claro,
fundo branco, tipografia URW Gothic, acentos em gradiente roxo→magenta e logos
sempre sobre fundo branco**, sem sombras e com divisores de linha fina preta.

---

## ENTREGÁVEIS PREVISTOS

### Trilha A — Desenvolvimento
1. **[DESENVOLVIMENTO] Estrutura do site restaurada/recriada** na branch `main`:
   - `index.html` (landing page Vintalie) recriado a partir da versão de referência
     (commit `1d19569`, recuperável com `git show 1d19569:index.html`).
   - `assets/style.css` reescrito do zero aplicando o guia de marca.
   - `assets/` com as logos da marca copiadas de `/home/mario/vintalie`.
   - `assets/fonts/` com as fontes URW Gothic auto-hospedadas (Book + Demi).
2. **[DESENVOLVIMENTO] Aplicação do guia de marca** (cores, tipografia, gradiente,
   layout, efeitos) conforme seções "Critérios de aceitação" abaixo.
3. **[DESENVOLVIMENTO] Composição do `full_lockup_01`** (logo + slogan com divisória
   vertical preta de 1px) no rodapé — este lockup NÃO existe como arquivo pronto; deve
   ser montado em HTML/CSS (logo horizontal à esquerda, divisória 1px preta, slogan
   "Ideias que movem marcas." à direita).
4. **[DESENVOLVIMENTO] Responsividade** (desktop/tablet/mobile) mantendo a
   legibilidade e o gradiente nos textos.

### Trilha B — Marketing (conteúdo/mensagem da página)
5. **[MARKETING] Revisão do conteúdo textual** da landing (hero "Ideias que movem
   marcas.", seção de soluções/serviços, tom de voz, CTA) alinhado ao posicionamento
   da marca — sem inventar números/logos de clientes fictícios além dos já presentes.
6. **[MARKETING] Copy do rodapé/lockup** contendo o slogan oficial
   "Ideias que movem marcas." e as informações de contato reais já existentes.

---

## CRITÉRIOS DE ACEITAÇÃO

**Paleta e gradiente**
- Fundo geral da página: branco `#FFFFFF`.
- Texto principal: `#333333`.
- Divisores/linhas: `#000000` (1px).
- Gradiente primário: `linear-gradient(135deg, #6A0DAD 0%, #C0007A 100%)`
  *(ver observação de reconciliação na seção Restrições)*.
- Cores de marca documentadas: `purple_dark #4B0082`, `purple_bright #800080`,
  `magenta_pink #C0007A`.

**Tipografia**
- Fonte URW Gothic em todo o site (logo, slogan, títulos, corpo).
- Logo/mark: URW Gothic **Demi/Bold**, capitalizado, tracking negativo (apertado),
  tamanho grande.
- Slogan: URW Gothic **Book/Light**, sentence case, `line-height: 1.2`, alinhado à
  esquerda, destaque em `magenta_pink`.
- URW Gothic deve ser **auto-hospedada** (copiar `URWGothic-Book.otf` e
  `URWGothic-Demi.otf` de `/usr/share/fonts/urw-base35/` para `assets/fonts/` e
  declarar `@font-face`). Fallback: `Jost`, `Questrial`, `sans-serif`.

**Layout e componentes**
- Header: logo horizontal (`Asset-4`) sobre fundo branco.
- Hero: headline "Ideias que movem marcas." com gradiente no destaque.
- Seções (soluções/serviços, depoimentos, formulário de leads, rodapé) reestilizadas
  no tema claro.
- Rodapé: `full_lockup_01` (logo + divisória 1px preta + slogan).
- **Nenhuma sombra** (`box-shadow`/`text-shadow`); usar bordas finas pretas.
- **Todas as logos sobre elemento de fundo branco** (transparência do V preservada —
  não colocar logo sobre gradiente escuro).

**Qualidade técnica**
- HTML semântico, CSS organizado, código comentado (explicar uso de cada bloco).
- Página abre corretamente no servidor local e no GitHub Pages.
- Responsivo (mobile-first ou breakpoints claros).

---

## RESTRIÇÕES E OBSERVAÇÕES

1. **Escopo de arquivos:** alterar apenas `index.html`, `assets/style.css` e a pasta
   `assets/` (incl. `assets/fonts/`). **Não** alterar o conteúdo de `README.md`,
   `CNAME` (domínio `vintalie.com.br`) nem `.github/`.
2. **Jekyll x estático — PONTO A CONFIRMAR:** o repositório atual NÃO possui estrutura
   Jekyll (`_config.yml`, `_layouts`, `_includes`); é HTML/CSS estático servido pelo
   GitHub Pages (que usa Jekyll como engine por padrão). Premissa adotada neste
   briefing: **manter estático (HTML/CSS) e apenas reestilizar**, sem converter para
   um site Jekyll completo. Se o usuário desejar uma estrutura Jekyll de fato
   (layouts/includes), o orquestrador deve confirmar antes de executar.
3. **Discrepância de gradiente — RECONCILIAR:** o JSON de marca define o gradiente
   como `#6A0DAD → #C0007A`, mas os arquivos SVG reais da logo usam `#6A009C → #D4145A`.
   Recomendação: derivar o gradiente CSS dos **SVGs reais** (`#6A009C → #D4145A`)
   para que texto e logo fiquem visualmente idênticos; manter a paleta do JSON como
   referência documental. O orquestrador deve registrar a decisão no `escopo.md`.
4. **Conteúdo base:** a última versão do site está no commit `1d19569`. Recuperar o
   conteúdo (hero, 6 cards de solução, 3 depoimentos, formulário, rodapé) e
   reestilizar — não partir de página em branco.
5. **Sem.Clientes fictícios:** não inventar logotipos, métricas ou nomes de clientes
   além dos já presentes no conteúdo de referência.
6. **Fonte URW Gothic:** disponível localmente em `/usr/share/fonts/urw-base35/`
   (`URWGothic-Book.otf`, `URWGothic-Demi.otf`, + variantes oblíquas). Auto-hospedar.
7. **Logo quadrada:** usar `logo vertical.svg` (1254×1254) ou `logo.png`/`Untitled-2.png`
   (1024×1024) quando for necessário o lockup vertical/quadrado.
8. **Background de capa do Facebook:** `background fb.png` (1920×1080). É um asset de
   marca; **não** é obrigatório usá-lo no site (a marca pede fundo branco). Se usado,
   deve ser como elemento de destaque com o logo/gradiente por cima — confirmar
   com o usuário antes de incorporar.
9. **Prazo:** a definir (não informado pelo usuário).
10. **domínio/publicação:** publicar apenas com status `APROVADO` do validador.

---

## MAPEAMENTO DE ASSETS (de /home/mario/vintalie)

| Arquivo | Uso | Variação de marca |
|---|---|---|
| `Asset-1.svg` | Ícone "V" (chevron) — favicon/marca d'água | `icon_01` |
| `Asset-2.svg` | Perna esquerda translúcida do V (overlay) | `icon_01` (transparência) |
| `Asset-3.svg` | Wordmark "intalie" em URW Gothic | parte de `logo_horizontal_01` |
| `Asset-4.svg` / `Asset-4.png` | **Logo horizontal completa** (V + intalie) | `logo_horizontal_01` |
| `logo vertical.svg` / `logo.png` / `Untitled-2.png` | **Logo quadrada** | lockup vertical |
| `background fb.png` | Capa do Facebook (1920×1080) | asset de marca (opcional) |
| `*.vectorcraft` | Arquivos-fonte de design (proprietários) — NÃO usar na web | — |

**Fontes:** `/usr/share/fonts/urw-base35/URWGothic-Book.otf`,
`/usr/share/fonts/urw-base35/URWGothic-Demi.otf`.

---

## PROMPT DE MISSÃO PARA O ORQUESTRADOR

```
Você é o ORQUESTRADOR do projeto "Redesign Visual Vintalie". Siga seu SOUL.md:
assuma o papel de dono do plano, da delegação e do estado do projeto; produza o
ESCOPO DO PROJETO (escopo.md), divida em trilhas (A) Desenvolvimento e (B) Marketing,
delege ao EXECUTOR, encaminhe ao VALIDADOR e publique somente com status APROVADO.

CONTEXTO:
- Repositório: /home/mario/Documentos/vintalie (branch main), domínio vintalie.com.br,
  hospedado em GitHub Pages.
- O site foi removido da main; a última versão boa está no commit 1d19569
  (recuperar com: git show 1d19569:index.html e git show 1d19569:assets/style.css).
- Assets de marca em /home/mario/vintalie.
- Fonte URW Gothic instalada em /usr/share/fonts/urw-base35/.

OBJETIVO: reestilizar a landing page do site Vintalie aplicando integralmente o
guia de marca a seguir. Tema claro, fundo branco, sem sombras.

GUIA DE MARCA (aplicar tudo):
- Cores: fundo branco #FFFFFF; texto #333333; divisores #000000 (1px);
  gradiente primário linear 135deg #6A0DAD -> #C0007A
  (reconciliar com os SVGs reais que usam #6A009C -> #D4145A; registrar a decisão
  no escopo.md). Paleta: #4B0082, #800080, #C0007A.
- Fonte: URW Gothic auto-hospedada (@font-face com URWGothic-Book.otf e
  URWGothic-Demi.otf copiados para assets/fonts/). Logo: Demi/Bold, capitalizado,
  tracking negativo, grande. Slogan: Book/Light, sentence case, line-height 1.2,
  alinhado à esquerda, destaque em magenta_pink.
- Logo: usar a horizontal completa (Asset-4) no header; ícone V (Asset-1) onde couber;
  montar o full_lockup_01 no rodapé (logo + divisória vertical 1px preta + slogan
  "Ideias que movem marcas.") em HTML/CSS, pois esse lockup não existe como arquivo.
- REGRA CRÍTICA: todas as logos ficam sobre elemento de FUNDO BRANCO (o V tem
  transparência e é majoritariamente gradiente sem borda).
- Sem box-shadow/text-shadow. Usar bordas finas pretas como divisores.

TRILHA A (Desenvolvimento):
- Recriar index.html + assets/style.css do zero (não partir de página em branco;
  reaproveitar o conteúdo do commit 1d19569: hero, 6 soluções, 3 depoimentos,
  formulário de leads, rodapé) e reestilizar no tema claro da marca.
- Copiar logos de /home/mario/vintalie para assets/ (usar SVGs quando possível).
- Auto-hospedar URW Gothic em assets/fonts/.
- Responsivo (desktop/tablet/mobile). Código comentado explicando cada bloco.
- NÃO alterar README.md, CNAME nem .github/.

TRILHA B (Marketing):
- Revisar tom de voz e copy da landing alinhados ao posicionamento da marca;
  manter slogan oficial "Ideias que movem marcas."; não inventar clientes/métricas.

RESTRIÇÕES:
- Escopo de arquivos: apenas index.html, assets/style.css e assets/.
- Premissa: manter estático (HTML/CSS), sem converter para estrutura Jekyll completa —
  confirmar com o usuário antes de qualquer mudança de arquitetura.
- background fb.png é asset de marca; só usar no site após confirmar com o usuário.
- Publicar apenas com APROVADO do validador.

ENTREGÁVEIS ESPERADOS:
- escopo.md (escopo do projeto, trilhas A e B, critérios de aceitação, decisão de
  gradiente reconciliado, premissa estático x Jekyll confirmada).
- delegacao.md (delegação ao executor, o que validar, o que publicar).
- Site reestilizado conforme critérios de aceitação, validado e publicado (APROVADO).
```

---

## FORMATO DE RETORNO ESPERADO

O orquestrador deve devolver:
1. **escopo.md** — ESCOPO DO PROJETO (objetivo, trilhas A/B, critérios de aceitação,
   premissas e pontos a confirmar: Jekyll x estático, reconciliação do gradiente,
   uso do background fb).
2. **delegacao.md** — plano de delegação (executor → validador → publicador),
   com tarefas por trilha, critérios de validação e condição de publicação (APPROVADO).

Ambos seguindo o SOUL.md do orquestrador.

---

## COMO ENCAMINHAR AO ORQUESTRADOR

Após colar o PROMPT DE MISSÃO acima, o orquestrador assume o plano. Para acioná-lo:

    hermes -p orquestrador chat -q "<cole aqui o PROMPT DE MISSÃO do briefing>"

Ou encaminhe manualmente o conteúdo deste briefing ao perfil orquestrador.