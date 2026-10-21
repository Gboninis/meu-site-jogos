#!/bin/zsh
# Monta a pasta ../meu-site-jogos-vercel com o que vai para a Vercel.
# Ficam de fora: as ROMs (jogos comerciais não podem ser publicados), o certificado
# local e as páginas de teste. Só vão os cores de Super Nintendo.
set -e
ORIGEM="${0:A:h}"
DESTINO="$ORIGEM/../meu-site-jogos-vercel"

# Limpa só o conteúdo do site; .vercel/ e .env.local (o vínculo com o projeto na Vercel) ficam
rm -rf "${DESTINO:?}/site/capas" "${DESTINO:?}/site/emulator" "${DESTINO:?}/site/index.html"
mkdir -p "$DESTINO/site/emulator/cores/reports"
cd "$ORIGEM"

cp -R capas "$DESTINO/site/"
cp emulator/player.html emulator/loader.js emulator/emulator.min.js emulator/emulator.min.css emulator/version.json "$DESTINO/site/emulator/"
cp -R emulator/compression emulator/localization "$DESTINO/site/emulator/"
cp emulator/cores/snes9x-wasm.data emulator/cores/snes9x-legacy-wasm.data "$DESTINO/site/emulator/cores/"
cp emulator/cores/reports/snes9x.json "$DESTINO/site/emulator/cores/reports/"

# Na vitrine publicada os botões não apontam para ROMs: o player pede o arquivo do aparelho
sed -E 's#player\.html\?game=[^"&]*(&core=snes)?"#player.html?core=snes"#' index.html > "$DESTINO/site/index.html"
python3 -I - "$DESTINO/site/index.html" <<'EOF'
import sys, re
p = sys.argv[1]; s = open(p, encoding='utf-8').read()
# leva o nome do jogo para o player mostrar no título da tela de escolha
s = re.sub(r'<p>([^<]+)</p>(\s*(?:<!--.*?-->\s*)?)<a class="btn" href="emulator/player\.html\?core=snes">',
           lambda m: f'<p>{m.group(1)}</p>{m.group(2)}<a class="btn" href="emulator/player.html?core=snes&nome={m.group(1).replace(" ", "%20")}">', s, flags=re.S)
open(p, 'w', encoding='utf-8').write(s)
EOF

echo "Pasta pronta: $DESTINO/site"
du -sh "$DESTINO/site"
echo "Para publicar: cd \"$DESTINO/site\" && npx vercel deploy --prod --yes"
echo "Endereço: https://meu-site-jogos-navy.vercel.app"
