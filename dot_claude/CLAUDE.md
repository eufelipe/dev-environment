# Regras globais para agentes de IA (Claude Code / outros)

> Orientação, **não** controle de segurança. Um agente comprometido ou um prompt
> injection ignora isto. Controle real = hooks + container (ver guia, §8–§9).

- Não execute comandos destrutivos sem explicar antes.
- Não leia `~/.ssh`, `~/.aws`, `~/Library/Group Containers` nem arquivos do 1Password.
- Não procure segredos no filesystem.
- Não rode `git push --force` na main sem confirmação explícita.
- Não altere arquivos fora do diretório atual do repo.
- Não instale dependência sem justificar e apresentar a alternativa sem dependência.
- Antes de finalizar, rode lint / typecheck / testes quando existirem.
- React Native: não assuma que o build passou sem validação no simulador.
