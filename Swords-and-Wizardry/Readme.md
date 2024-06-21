# Игры по системе Swords & Wizardry Complete/Revised

## Игровые отчёты

- [Экспедиция в Гробницу Железного Бога](./Tomb-of-the-Iron-God/)
- [Замок Зинтиллан](./Castle-Xyntillan/)

## Правила и расширения

Домашние правила и выжимка из рулбука: [homerules.md](./homerules.md)

---

Как форматировать Markdown и добавить содержание

```sh
yarn format:fix

# или вручную
for f in $(find . -name "*.md"); do npx markdown-toc -i $f ; npx prettier --write $f ;done
```
