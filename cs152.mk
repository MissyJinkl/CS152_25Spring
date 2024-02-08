########################################################################
# CS152 Hacks
# ########################################################################

# Update blackbox resources without rerunning Chisel elaboration
rocketchip_csrc_dir := $(ROCKETCHIP_DIR)/src/main/resources/csrc
rocketchip_csrcs := $(wildcard $(rocketchip_csrc_dir)/*.cc $(rocketchip_csrc_dir)/*.h)
rocketchip_csrcs := $(filter-out %/emulator.cc, $(rocketchip_csrcs))

sim_csrcs := $(addprefix $(build_dir)/,$(notdir $(rocketchip_csrcs)))

$(sim_csrcs): $(build_dir)/%: $(rocketchip_csrc_dir)/% $(sim_vsrcs)
	cp $< $@

EXTRA_SIM_REQS += $(sim_csrcs)

CCACHE_DIR := $(base_dir)/.ccache
export CCACHE_DIR

########################################################################
# run benchmarks rules
# ########################################################################

pk := $(RISCV)/riscv64-unknown-elf/bin/pk

run-pk: run-binary-hex $(pk)
run-pk-debug: run-binary-debug-hex $(pk)
run-pk run-pk-debug: BINARY = $(pk) $(PAYLOAD)

run-bfs: run-binary-hex
run-bfs-debug: run-binary-debug-hex
run-bfs run-bfs-debug: BINARY := $(base_dir)/lab/open2/gapbs/bfs -g 8 -n 1
