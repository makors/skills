# Each category folder is a stow package. Its skills link into every target.
PACKAGES := $(sort $(foreach f,$(wildcard */*/SKILL.md),$(firstword $(subst /, ,$(f)))))
TARGETS  := $(HOME)/.claude/skills $(HOME)/.agents/skills
STOW     := stow --ignore='\.gitkeep'
EACH     = @$(if $(PACKAGES),for t in $(TARGETS); do $(1); done,echo "no skills yet")

.PHONY: install uninstall check
install:
	$(call EACH,mkdir -p $$t && $(STOW) -R -t $$t $(PACKAGES))
uninstall:
	$(call EACH,[ ! -d $$t ] || $(STOW) -D -t $$t $(PACKAGES))
check:
	$(call EACH,[ ! -d $$t ] || $(STOW) -n -v -R -t $$t $(PACKAGES))
