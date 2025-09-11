NS3_HOME := $(shell pwd)/ns-3
PATH := $(PATH):$(NS3_HOME)

bootstrap: $(NS3_HOME)/ns3 | $(NS3_HOME)/contrib/defiance $(NS3_HOME)/contrib/ai
	cd $(NS3_HOME)/contrib/defiance && poetry install --without local
	cd $(NS3_HOME)/contrib/defiance && poetry run ns3 configure --disable-werror --enable-test --enable-python --enable-examples --enable-modules=point-to-point,point-to-point-layout,network,applications,mobility,csma,internet,flow-monitor,lte,wifi,energy,ai,defiance,netanim -d debug --out $(NS3_HOME)/build
	ns3 build ai
	cd $(NS3_HOME)/contrib/defiance && poetry install --with local

download $(NS3_HOME)/ns3:
	git submodule update --init

configure: | $(NS3_HOME)/contrib/ai $(NS3_HOME)/contrib/defiance

$(NS3_HOME)/contrib/defiance:
	cd ns3-DEFIANCE && git worktree add $(NS3_HOME)/contrib/defiance main

$(NS3_HOME)/contrib/ai:
	cd ns3-ai && git worktree add $(NS3_HOME)/contrib/ai main

clean:
	rm $(NS3_HOME)/contrib/ai -r || true
	rm $(NS3_HOME)/contrib/defiance -r || true
	cd ns3-DEFIANCE && git worktree prune
	cd ns3-ai && git worktree prune
