# Git aliases

Exportado de `~/.gitconfig` (`[alias]`). Este archivo es solo referencia — no vive dentro de ningún paquete de stow, no se symlinkea a ningún lado.

```gitconfig
[alias]
	pod = pull origin develop
	pom = pull origin main
	st = status -s
	sw = switch
	co = checkout -b
	logs = log --graph --decorate --all
	b = branch
	br = branch -r
	cm = commit -m
```

## Restaurar en una máquina nueva

```bash
git config --global alias.pod "pull origin develop"
git config --global alias.pom "pull origin main"
git config --global alias.st "status -s"
git config --global alias.sw "switch"
git config --global alias.co "checkout -b"
git config --global alias.logs "log --graph --decorate --all"
git config --global alias.b "branch"
git config --global alias.br "branch -r"
git config --global alias.cm "commit -m"
```

O copia el bloque `[alias]` de arriba directo dentro de `~/.gitconfig`.
