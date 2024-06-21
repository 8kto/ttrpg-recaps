# Swords & Wizardry (Complete/Revised)

Используемые правила и хомрулы

- При создании нового персонажа: [FAQ и используемые правила](./faq.md)
- [Сражение и Боевые опции](./combat.md)
- [Сражение, специфические ситуации (Краткое AI-изложение)](./snw-combat-specific.md)

## Как форматировать Markdown и добавить содержание

```sh
for f in $(find . -name "*.md"); do npx markdown-toc -i $f ; npx prettier --write $f ;done
```

