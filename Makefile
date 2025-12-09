

# Builds all the nested Elixir apps with KOS compilers.
# Elixir apps must be stored in the apps/ folder, as apps/<elixir_name> with a mix.exs file in their root
# (eg apps/my_elixir_app/mix.exs)
# This file should not need to be manually modified.

NESTED_APPS:=$(wildcard $(CURDIR)/apps/*/mix.exs)

.PHONY: all $(NESTED_APPS) name

all: $(NESTED_APPS)

$(NESTED_APPS):
	@DIRNAME="$(notdir $(patsubst %/, %, $(dir $@)))"; \
    NESTED_MIX_BUILD="$(MIX_BUILD_PATH)/$${DIRNAME}/_build"; \
    NESTED_MIX_DEPS="$(MIX_BUILD_PATH)/$${DIRNAME}/deps"; \
    NESTED_MIX_ENV="env MIX_BUILD_PATH=$$NESTED_MIX_BUILD MIX_DEPS_PATH=$$NESTED_MIX_DEPS"; \
    \
    (cd $(dir $@) && $$NESTED_MIX_ENV mix deps.get); \
    (cd $(dir $@) && $$NESTED_MIX_ENV $(KOS_TRIPLE)-beam-env mix release --overwrite); \
    (cd $(dir $@) && $$NESTED_MIX_ENV $(KOS_TRIPLE)-beam-env mix kos.package.beam --dir $(MIX_BUILD_PATH) --app-release-dir $$NESTED_MIX_BUILD/rel/$${DIRNAME} --vdso-name $${DIRNAME}_vdso)
