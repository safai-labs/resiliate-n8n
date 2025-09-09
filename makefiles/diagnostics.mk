# Diagnostic and health check utilities
# Part of the advanced makefile system

### Show package version and build information
version:
	@echo "📦 Package: $(PACKAGE_NAME)"
	@echo "🔖 Version: $(PACKAGE_VERSION)"
	@echo "🚀 Channel: $(PACKAGE_CHANNEL)"
	@echo "🔄 Revision: $(PACKAGE_REVISION)"
HELP_G1+=version

### Show project status and environment info
status: version
	@echo "📁 Build directory: $(BUILD_DIR)"
	@echo "📦 Node modules: $(shell test -d node_modules && echo "✅ installed" || echo "❌ missing")"
	@echo "🏗️  Built files: $(shell test -d dist && echo "✅ present" || echo "❌ missing")"
	@echo "⚙️  TypeScript config: $(shell test -f tsconfig.json && echo "✅ present" || echo "❌ missing")"
HELP_G1+=status

### Comprehensive environment and configuration health check
doctor:
	@echo "🔍 Running system diagnostics..."
	@echo ""
	@echo "📋 Environment Check:"
	@echo "  Shell: $(SHELL) $(shell $(SHELL) --version 2>/dev/null | head -1 || echo "unknown version")"
	@echo "  Make: $(MAKE_VERSION)"
	@echo "  PWD: $(PWD)"
	@echo "  User: $(USER)"
	@echo ""
	@echo "📦 Project Configuration:"
	@echo "  Package: $(PACKAGE_NAME)"
	@echo "  Version: $(PACKAGE_VERSION)"
	@echo "  Build Dir: $(BUILD_DIR)"
	@echo "  Channel: $(PACKAGE_CHANNEL)"
	@echo ""
	@echo "🔧 Tool Availability:"
	@which node >/dev/null 2>&1 && echo "  ✅ Node.js: $$(node --version)" || echo "  ❌ Node.js: Not found"
	@which npm >/dev/null 2>&1 && echo "  ✅ npm: $$(npm --version)" || echo "  ❌ npm: Not found"
	@which git >/dev/null 2>&1 && echo "  ✅ Git: $$(git --version)" || echo "  ❌ Git: Not found"
	@test -f package.json && echo "  ✅ package.json: Found" || echo "  ❌ package.json: Missing"
	@test -f tsconfig.json && echo "  ✅ tsconfig.json: Found" || echo "  ❌ tsconfig.json: Missing"
	@echo ""
	@echo "📁 File System Check:"
	@test -d node_modules && echo "  ✅ node_modules: Present ($$(ls node_modules | wc -l) packages)" || echo "  ⚠️  node_modules: Missing (run 'make install')"
	@test -d $(BUILD_DIR) && echo "  ✅ Build directory: Present" || echo "  ⚠️  Build directory: Missing (run 'make build')"
	@test -w . && echo "  ✅ Directory: Writable" || echo "  ❌ Directory: Not writable"
	@echo ""
	@echo "🔐 Security & Quality:"
	@if which npm >/dev/null 2>&1; then \
		npm audit --audit-level=high --parseable 2>/dev/null | wc -l | \
		awk '{if ($$1 == 0) print "  ✅ npm audit: No high/critical vulnerabilities"; else print "  ⚠️  npm audit: " $$1 " vulnerabilities found (run '\''make audit'\'')"}'; \
	fi
	@echo ""
	@echo "💡 Recommendations:"
	@test -d node_modules || echo "  → Run 'make install' to install dependencies"
	@test -d $(BUILD_DIR) || echo "  → Run 'make build' to compile project"
	@test -f .gitignore || echo "  → Consider adding .gitignore file"
	@grep -q "dist/" .gitignore 2>/dev/null || echo "  → Add 'dist/' to .gitignore"
	@echo "✅ Diagnostics complete"
HELP_G2+=doctor

### Validate Makefile configuration and syntax
validate-config:
	@echo "🔍 Validating configuration..."
	@echo ""
	@echo "📋 Required Variables:"
	@test -n "$(PACKAGE_NAME)" && echo "  ✅ PACKAGE_NAME: $(PACKAGE_NAME)" || echo "  ❌ PACKAGE_NAME: Not set"
	@test -n "$(PACKAGE_VERSION)" && echo "  ✅ PACKAGE_VERSION: $(PACKAGE_VERSION)" || echo "  ❌ PACKAGE_VERSION: Not set"
	@test -n "$(BUILD_DIR)" && echo "  ✅ BUILD_DIR: $(BUILD_DIR)" || echo "  ❌ BUILD_DIR: Not set"
	@echo ""
	@echo "📁 File Structure:"
	@test -f config.mk && echo "  ✅ config.mk: Found" || echo "  ❌ config.mk: Missing"
	@test -f GNUmakefile && echo "  ✅ GNUmakefile: Found" || echo "  ❌ GNUmakefile: Missing"
	@test -d makefiles && echo "  ✅ makefiles/: Found" || echo "  ❌ makefiles/: Missing"
	@echo ""
	@echo "🎯 Target Validation:"
	@make -n build >/dev/null 2>&1 && echo "  ✅ 'make build' syntax: Valid" || echo "  ❌ 'make build' syntax: Invalid"
	@make -n install >/dev/null 2>&1 && echo "  ✅ 'make install' syntax: Valid" || echo "  ❌ 'make install' syntax: Invalid"
	@echo "✅ Configuration validation complete"
HELP_G2+=validate-config

