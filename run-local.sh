#!/usr/bin/env bash
# @Manhwatarjima1_bot ni DARHOL noutbukda ishga tushirish (GitHub kutmasdan):
#
#   cd ~/manhwa-bot3 && bash run-local.sh <@Manhwatarjima1_bot TOKENI>
#
# Darvoza (manhwa-gate-3) o'zgarmaydi: skript uning saqlab turgan xabarlarini oladi va
# javob beradi - xuddi GitHub'dagi runner kabi. Oyna yopilsa bot to'xtaydi.
# Doimiy ishlashi uchun: setup.sh (GitHub Actions'da 24/7).
set -e
cd "$(dirname "$0")"

BOT_TOKEN="$1"
GATE=../manhwa-gate
if [ -z "$BOT_TOKEN" ]; then
  echo "Foydalanish: bash run-local.sh <@Manhwatarjima1_bot tokeni>"
  exit 1
fi

export BOT_TOKEN
export OWNER_ID=8706650133
export GATE_URL=https://manhwa-gate-3.compass-crm.workers.dev
export ADMINS_URL=https://manhwa-gate-3.compass-crm.workers.dev/admins
export GATE_KEY=$(python -c "import json;print(json.load(open(r'$GATE/.secrets.3.json'))['GATE_KEY'])")
export GEMINI_API_KEY=$(tr -d ' \r\n' < "$GATE/.gemini.3.key")
export OCR_ENGINE=fast RENDER_V2=1 FONT_STYLES=1 PUBLIC_BOT=1 SHOP_UI=1
export FREE_CHAPTERS=1 DAILY_LIMIT=200 PARALLEL_JOBS=3
export PACKS="100:30000,200:50000,300:80000"
export CHAPTER_BATCH=1 GEMINI_CHUNK=40
export GEMINI_MODELS="gemini-3.5-flash:low,gemini-3.8-flash:low,gemini-3.7-flash:low,gemini-3.6-flash:low,gemini-3-flash-preview:low,gemini-3.5-flash-lite:low,gemini-3.1-flash-lite:low,gemini-3.1-flash-lite-preview:low,gemma-4-31b-it"
export OWNER_USERNAME=sharofovsaid
export BOT_SLOT=1 IDLE_EXIT=999999

echo "Bot uyg'otilmoqda (darvozada saqlangan xabarlar ham olinadi). To'xtatish: Ctrl+C"
python runner.py
