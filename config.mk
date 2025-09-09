# n8n-nodes-resiliate-events Build Environment makefile setup file.
#
# This file is used to prime the rest of the makefile tools.
# Use this file to define your global variables, toolchain etc.
# and use the `Makefile` to actually provide targets.
#

# ------------------------------------------------------------------------------
# Bring in an optional configuration file to override the default settings.
#
# We assume that there will be a build user in the CI/CD and will have a 
# n8n-build-config.mk in its home directory.
#

-include ~/n8n-build-config.mk

# ------------------------------------------------------------------------------
# Package information from package.json

PACKAGE_NAME := n8n-nodes-resiliate-events
PACKAGE_VERSION := $(shell node -p "require('./package.json').version" 2>/dev/null || echo "0.1.0")

mkutils.ATVARS+=PACKAGE_NAME PACKAGE_VERSION

# ------------------------------------------------------------------------------
# Build environment settings

MAKEFILE_ROOT       := $(mkutils.makefiledir)

CHANNELS        	?= dev stable next
CHANNELS_BASEDIR 	?= $(MAKEFILE_ROOT)/.build
CHANNEL 			?= dev
BUILD_BASE			?= $(CHANNELS_BASEDIR)/$(CHANNEL)

export BUILD_DIR	?= $(MAKEFILE_ROOT)/dist

# ------------------------------------------------------------------------------
# Node.js and TypeScript tools
NODE			= node
NPM				= npm
TSC				= npx tsc
ESLINT			= npx eslint
PRETTIER		= npx prettier

# Build commands
NPM_INSTALL		= $(NPM) install
NPM_BUILD		= $(NPM) run build
NPM_DEV			= $(NPM) run dev
NPM_LINT		= $(NPM) run lint
NPM_LINT_FIX	= $(NPM) run lint:fix
NPM_FORMAT		= $(NPM) run format

# ------------------------------------------------------------------------------
# Source directories
TS_SRCS = nodes/ResiliateEvents \
    credentials

NODE_MODULES = node_modules

# ------------------------------------------------------------------------------
# Version and revision tracking

DATE_TODAY = $(shell date --iso-8601=d | sed s/-//g)
DATE_FILE = DATE
COUNTER_FILE = COUNTER
LAST_DATE = $(shell test -f $(DATE_FILE) && cat $(DATE_FILE) || echo "0")
COUNTER = $(shell test -f $(COUNTER_FILE) && cat $(COUNTER_FILE) || echo "0")

PACKAGE_CHANNEL = beta
PACKAGE_REVISION := $(COUNTER)
mkutils.ATVARS += PACKAGE_REVISION

# ------------------------------------------------------------------------------
# n8n specific settings
N8N_NODES_API_VERSION = 1
DIST_CREDENTIALS = dist/credentials
DIST_NODES = dist/nodes

# Output files
CREDENTIAL_FILES = $(DIST_CREDENTIALS)/ResiliateEventsApi.credentials.js
NODE_FILES = $(DIST_NODES)/ResiliateEvents/ResiliateEvents.node.js

# ------------------------------------------------------------------------------
# Clean system integration - use the built-in clean system properly
CLEAN_FILES += $(BUILD_DIR) node_modules/.cache *.tar.gz *.log deps.dot deps.png deps.svg
CLEAN_FILES += make-completion.bash MAKEFILE.md
