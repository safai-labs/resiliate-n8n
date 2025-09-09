# Development tools and utilities
# Part of the advanced makefile system

### Generate shell completion scripts for make targets
generate-completion:
	@echo "🔧 Generating shell completion..."
	@targets=$$(make show-targets 2>/dev/null | grep "^  " | awk '{print $$1}' | tr '\n' ' '); \
	echo "# Bash completion for $(PACKAGE_NAME) makefile" > make-completion.bash; \
	echo "_make_completion() {" >> make-completion.bash; \
	echo "    local cur=\$${COMP_WORDS[COMP_CWORD]}" >> make-completion.bash; \
	echo "    COMPREPLY=(\$$(compgen -W \"$$targets\" -- \$$cur))" >> make-completion.bash; \
	echo "}" >> make-completion.bash; \
	echo "complete -F _make_completion make" >> make-completion.bash; \
	echo "✅ Bash completion saved to make-completion.bash"; \
	echo "💡 Source with: source make-completion.bash"
HELP_G2+=generate-completion

### Generate markdown documentation from makefile targets
generate-docs:
	@echo "📝 Generating documentation..."
	@echo "# $(PACKAGE_NAME) - Available Commands" > MAKEFILE.md
	@echo "" >> MAKEFILE.md
	@echo "Auto-generated documentation from Makefile targets." >> MAKEFILE.md
	@echo "" >> MAKEFILE.md
	@echo "## Build Targets" >> MAKEFILE.md
	@echo "" >> MAKEFILE.md
	@grep -h -E "^### " Makefile makefiles/*.mk 2>/dev/null | while read line; do \
		desc=$$(echo "$$line" | sed 's/^###[ \t]*//g'); \
		target=$$(grep -h -A1 "$$line" Makefile makefiles/*.mk 2>/dev/null | tail -1 | sed 's/:.*//g' | sed 's/^[ \t]*//g'); \
		if [ -n "$$target" ] && [ "$$target" != "$$line" ]; then \
			echo "### \`make $$target\`" >> MAKEFILE.md; \
			echo "" >> MAKEFILE.md; \
			echo "$$desc" >> MAKEFILE.md; \
			echo "" >> MAKEFILE.md; \
		fi; \
	done
	@echo "✅ Documentation saved to MAKEFILE.md"
HELP_G2+=generate-docs

### Intelligent file watching and rebuilding
watch:
	@echo "👀 Starting intelligent file watcher..."
	@echo "📁 Watching: $(PWD)"
	@echo "🎯 Target: build"
	@echo "⏹️  Press Ctrl+C to stop"
	@echo ""
	@if ! which inotifywait >/dev/null 2>&1; then \
		echo "❌ inotify-tools not found. Installing..."; \
		echo "💡 Run: sudo apt-get install inotify-tools"; \
		exit 1; \
	fi; \
	while true; do \
		inotifywait -r -e modify,create,delete \
			--include '.*\.(ts|js|json|md)$$' \
			. 2>/dev/null || break; \
		echo ""; \
		echo "🔄 File changed, rebuilding..."; \
		if make build; then \
			echo "✅ Build successful at $$(date '+%H:%M:%S')"; \
		else \
			echo "❌ Build failed at $$(date '+%H:%M:%S')"; \
		fi; \
		echo "👀 Watching for changes..."; \
	done
HELP_G2+=watch

### Smart environment setup for new developers
bootstrap:
	@echo "🚀 Bootstrap Development Environment"
	@echo "===================================="
	@echo ""
	@echo "Setting up $(PACKAGE_NAME) for development..."
	@echo ""
	@echo "📋 Step 1: Environment Check"
	@make doctor
	@echo ""
	@echo "📦 Step 2: Install Dependencies"
	@make install
	@echo ""
	@echo "🔨 Step 3: Initial Build"
	@make build
	@echo ""
	@echo "🔍 Step 4: Validate Setup"
	@make validate
	@echo ""
	@echo "📚 Step 5: Generate Documentation"
	@make generate-docs
	@echo ""
	@echo "🎉 Bootstrap Complete!"
	@echo ""
	@echo "🚀 Quick Start Commands:"
	@echo "  make dev      - Start development mode"
	@echo "  make watch    - Watch files and rebuild"
	@echo "  make help     - See all available commands"
	@echo "  make doctor   - Run health checks anytime"
HELP_G1+=bootstrap

