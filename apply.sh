#!/usr/bin/env bash
# Yangi kodni botga qo'yish (har o'zgarishdan keyin):
#
#   cd ~/manhwa-bot3 && GH_TOKEN=<ghp_...> bash apply.sh
#
# 1) kodni GitHub'ga yuboradi  2) ishlab turgan runner'ni to'xtatadi - darvoza (ALWAYS_ON)
# bir daqiqa ichida YANGI kod bilan ishga tushiradi. Xabarlar yo'qolmaydi (darvozada saqlanadi).
set -e
cd "$(dirname "$0")"

REPO=saidJon512/manhwa-bot3
if [ -z "$GH_TOKEN" ]; then
  echo "Foydalanish: GH_TOKEN=<ghp_...> bash apply.sh"
  exit 1
fi
export GH_TOKEN

git add -A
git commit -qm "${1:-Bot kodini yangilash}" || echo "Yangi commit yo'q"
git push "https://x-access-token:$GH_TOKEN@github.com/$REPO.git" main

run=$(gh run list -R "$REPO" -L 1 --json databaseId,status -q '.[] | select(.status=="in_progress") | .databaseId')
if [ -n "$run" ]; then
  echo "Ishlab turgan runner to'xtatilmoqda ($run) - darvoza yangisini yoqadi..."
  gh run cancel "$run" -R "$REPO" || true
else
  echo "Hozir ishlayotgan runner yo'q - darvoza o'zi yoqadi."
fi
echo "Tayyor. 1-2 daqiqada bot yangi kod bilan javob beradi."
