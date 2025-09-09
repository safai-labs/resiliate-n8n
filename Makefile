### Install Node.js dependencies
install:
	$(NPM_INSTALL)
HELP_G1+=install

### Build the TypeScript source to JavaScript
build: install
	$(NPM_BUILD)
HELP_G1+=build

### Start development mode with watch
dev: install
	$(NPM_DEV)
HELP_G1+=dev

### Clean all generated files including node_modules
distclean: clean
	rm -rf node_modules
HELP_G1+=distclean

### Run ESLint on source files
lint: install
	$(NPM_LINT)
HELP_G2+=lint

### Run ESLint with auto-fix
lint-fix: install
	$(NPM_LINT_FIX)
HELP_G2+=lint-fix

### Format code with Prettier
format: install
	$(NPM_FORMAT)
HELP_G2+=format

### Run all code quality checks
check: lint
	@echo "✅ Code quality checks passed"
HELP_G2+=check

### Run tests (placeholder - no tests defined yet)
test: build
	@echo "⚠️  No tests defined yet"
HELP_G2+=test

### Validate the build and code quality
validate: build lint
	@echo "✅ Validation complete"
HELP_G2+=validate

### Create package for distribution
package: build
	$(NPM) pack
HELP_G2+=package

### Deploy to n8n (using deployment script)
deploy: build
	@if [ -f deploy_to_n8n.sh ]; then \
		./deploy_to_n8n.sh; \
	else \
		echo "❌ No deployment script found"; \
	fi
HELP_G2+=deploy

### Update dependencies
update:
	$(NPM) update
HELP_G2+=update

### Run npm security audit
audit:
	$(NPM) audit
HELP_G2+=audit

### Fix npm security issues
fix-audit:
	$(NPM) audit fix
HELP_G2+=fix-audit

### Full development setup for new contributors
setup: install build
	@echo "🎉 Development environment setup complete!"
	@echo "💡 Try: make dev (for watch mode) or make help (for all commands)"
HELP_G1+=setup

