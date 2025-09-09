# Analytics and performance utilities
# Part of the advanced makefile system

### Performance profiling for build targets
profile:
	@target="$${target:-build}"; \
	echo "⏱️  Profiling target: $$target"; \
	echo ""; \
	start_time=$$(date +%s.%N); \
	if make "$$target" V=1; then \
		end_time=$$(date +%s.%N); \
		duration=$$(echo "$$end_time - $$start_time" | bc -l 2>/dev/null || echo "unknown"); \
		echo ""; \
		echo "✅ Target '$$target' completed successfully"; \
		if [ "$$duration" != "unknown" ]; then \
			printf "⏱️  Duration: %.2f seconds\n" "$$duration"; \
		fi; \
	else \
		echo "❌ Target '$$target' failed"; \
	fi
	@echo ""
	@echo "💡 Usage: make profile target=build (default: build)"
HELP_G2+=profile

### Show build metrics and project statistics
metrics:
	@echo "📊 Project Metrics"
	@echo "=================="
	@echo ""
	@echo "📦 Package Information:"
	@echo "  Name: $(PACKAGE_NAME)"
	@echo "  Version: $(PACKAGE_VERSION)"
	@echo "  Channel: $(PACKAGE_CHANNEL)"
	@echo ""
	@echo "📁 File Statistics:"
	@find . -name "*.ts" -not -path "./node_modules/*" | wc -l | awk '{print "  TypeScript files: " $$1}'
	@find . -name "*.js" -not -path "./node_modules/*" -not -path "./dist/*" | wc -l | awk '{print "  JavaScript files: " $$1}'
	@find . -name "*.json" -not -path "./node_modules/*" | wc -l | awk '{print "  JSON files: " $$1}'
	@echo ""
	@echo "📏 Code Statistics:"
	@if which wc >/dev/null 2>&1; then \
		find . -name "*.ts" -o -name "*.js" | grep -v node_modules | grep -v dist | \
		xargs wc -l 2>/dev/null | tail -1 | awk '{print "  Total lines of code: " $$1}'; \
	fi
	@echo ""
	@echo "🔗 Dependencies:"
	@if [ -f package.json ]; then \
		echo "  Production: $$(jq '.dependencies | length' package.json 2>/dev/null || echo 'unknown')"; \
		echo "  Development: $$(jq '.devDependencies | length' package.json 2>/dev/null || echo 'unknown')"; \
	fi
	@echo ""
	@echo "💾 Disk Usage:"
	@du -sh . 2>/dev/null | awk '{print "  Project size: " $$1}'
	@if [ -d node_modules ]; then \
		du -sh node_modules 2>/dev/null | awk '{print "  node_modules: " $$1}'; \
	fi
	@if [ -d dist ]; then \
		du -sh dist 2>/dev/null | awk '{print "  dist: " $$1}'; \
	fi
HELP_G2+=metrics

### Show makefile target dependencies as ASCII tree
show-targets:
	@echo "🎯 Available Targets:"
	@echo ""
	@grep -E "^[a-zA-Z_-]+:" Makefile makefiles/*.mk 2>/dev/null | \
	grep -v "^#" | sed 's/:.*//g' | sed 's/.*\///g' | sort -u | \
	while read target; do \
		desc=$$(grep -h -B1 "^$$target:" Makefile makefiles/*.mk 2>/dev/null | grep "^###" | tail -1 | sed 's/^###[ \t]*//g' || echo "No description"); \
		printf "  %-20s - %s\n" "$$target" "$$desc"; \
	done
HELP_G2+=show-targets

