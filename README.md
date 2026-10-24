# skills

Stuff I've taught my agents.

- `apps/` – driving real apps
- `design/` – design inspo and tricks for better output
- `infra/` – sysadmin work on real servers

Each skill is a folder with a `SKILL.md`.

## Install

Needs [GNU Stow](https://www.gnu.org/software/stow/) (`brew install stow`).

```sh
make install    # link every skill into ~/.claude/skills and ~/.agents/skills
make check      # dry run
make uninstall  # remove the links
```

Links point back into this repo, so edits show up right away. Run `make install` again after you add or remove a skill.
