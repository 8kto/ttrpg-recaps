# Отчёты по ролевым играм

- [Call of Cthulhu](./Call-of-Cthulhu)
- [Плач Огненной Принцессы](./LotFP)
- [Swords & Wizardry](./Swords-and-Wizardry)

---

Как форматировать Markdown и добавить содержание

```sh
yarn format:fix

# или вручную
for f in $(find . -name "*.md"); do npx markdown-toc -i $f ; npx prettier --write $f ;done
```
