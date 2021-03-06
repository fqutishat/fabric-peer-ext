
#
# Copyright SecureKey Technologies Inc. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
#

#
# Supported Targets:
#
# unit-test:         runs unit tests
# lint:              runs linters
# checks:            runs code checks
#

CONTAINER_IDS = $(shell docker ps -a -q)
DEV_IMAGES = $(shell docker images dev-* -q)
export GO111MODULE=on

depend: version
	@scripts/dependencies.sh

checks: version depend lint

lint:
	@scripts/check_lint.sh

all: checks fabric-unit-test

unit-test: export FABRIC_COMMAND=unit-test
unit-test: checks
	@scripts/build_fabric.sh

version:
	@scripts/check_version.sh

clean-images:
	@echo "Stopping all containers, pruning containers and images, deleting dev images"
ifneq ($(strip $(CONTAINER_IDS)),)
	@docker stop $(CONTAINER_IDS)
endif
	@docker system prune -f
ifneq ($(strip $(DEV_IMAGES)),)
	@docker rmi $(DEV_IMAGES) -f
endif
	@docker rmi $(docker images securekey/* -aq)

.PHONY: all version clean-images fabric-unit-test