#!/usr/bin/env bash
# @Manhwatarjima1_bot ni O'Z GitHub akkauntiga (saidJon512) ko'chirish - BIR MARTA ishlatiladi:
#
#   cd ~/manhwa-bot3 && GH_TOKEN=<saidJon512 ghp_ tokeni> bash setup.sh <@Manhwatarjima1_bot TOKENI>
#
# Bot tokenini @BotFather -> /mybots -> @Manhwatarjima1_bot -> API Token dan oling
# (eski repoda u GitHub siri ichida - o'qib bo'lmaydi).
# Nima qiladi: 1) ochiq GitHub repo yaratadi va kodni yuboradi  2) sirlarni qo'yadi
#              3) darvozaga (Cloudflare manhwa-gate-3) GH_TOKEN ni qo'yib, joylaydi.
# Hech qanday token faylda saqlanmaydi - faqat shu ishga tushirishda ishlatiladi.
set -e
cd "$(dirname "$0")"

BOT_TOKEN="$1"
REPO=saidJon512/manhwa-bot3
GATE=../manhwa-gate

if [ -z "$BOT_TOKEN" ] || [ -z "$GH_TOKEN" ]; then
  echo "Foydalanish: GH_TOKEN=<ghp_...> bash setup.sh <@Manhwatarjima1_bot tokeni>"
  exit 1
fi
export GH_TOKEN

# 1) Repo (ochiq - Actions bepul va cheksiz) va kod
gh repo create "$REPO" --public \
   --description "@Manhwatarjima1_bot - manhwa tarjima boti (GitHub Actions)" || true
git branch -M main
git push "https://x-access-token:$GH_TOKEN@github.com/$REPO.git" main
git branch --set-upstream-to=origin/main main 2>/dev/null || true

# 2) Sirlar (qiymatlar mahalliy fayllardan - darvoza papkasida)
GATE_KEY=$(python -c "import json;print(json.load(open(r'$GATE/.secrets.3.json'))['GATE_KEY'])")
GEMINI=$(tr -d ' \r\n' < "$GATE/.gemini.3.key")
TG_ID=$(sed -n 's/^api_id=//p' "$GATE/.tg-api.txt" | tr -d ' \r\n')
TG_HASH=$(sed -n 's/^api_hash=//p' "$GATE/.tg-api.txt" | tr -d ' \r\n')

gh secret set BOT_TOKEN      -R "$REPO" -b "$BOT_TOKEN"
gh secret set OWNER_ID       -R "$REPO" -b "8706650133"
gh secret set GATE_KEY       -R "$REPO" -b "$GATE_KEY"
gh secret set GEMINI_API_KEY -R "$REPO" -b "$GEMINI"
gh secret set TG_API_ID      -R "$REPO" -b "$TG_ID"
gh secret set TG_API_HASH    -R "$REPO" -b "$TG_HASH"

# 3) Darvoza endi GitHub'ni o'zi uyg'otadi (MAIN orqali emas): GH_TOKEN siri + yangi sozlama
cd "$GATE"
printf '%s' "$GH_TOKEN" | npx wrangler secret put GH_TOKEN --config wrangler.3.toml
npx wrangler deploy --config wrangler.3.toml

echo
echo "TAYYOR. Tekshirish: Telegramda @Manhwatarjima1_bot ga /start yozing"
echo "(darvoza yangi repodagi 'bot' ishini uyg'otadi - ~1 daqiqa)."
echo "Eski joy (saidsharofov10-cmd/gardenhwa-bot1, bot-3.yml) endi kerak emas:"
echo "u yerda ishlayotgan runner 5 soat ichida o'zi to'xtaydi."
