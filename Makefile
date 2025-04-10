BAKE_HOME := $(shell pwd)/bake
NS3_HOME := $(shell pwd)/source/ns-3.40
PATH := $(PATH):$(BAKE_HOME):$(NS3_HOME)
PYTHONPATH := $(PYTHONPATH):$(BAKE_HOME)

bootstrap: $(NS3_HOME)/ns3 | $(NS3_HOME)/contrib/defiance $(NS3_HOME)/contrib/ai
	ns3 configure --disable-werror --enable-test --enable-python --enable-examples --enable-modules=point-to-point,point-to-point-layout,network,applications,mobility,csma,internet,flow-monitor,lte,wifi,energy,ai,defiance,netanim -d debug --out $(NS3_HOME)/build
	ns3 build ai
	cd $(NS3_HOME)/contrib/defiance && poetry install && pip install -e ../ai/python_utils && pip install -e ../ai/model/gym-interface/py

download $(NS3_HOME)/ns3 $(NS3_HOME)/contrib/defiance $(NS3_HOME)/contrib/ai: bake/bake.py bakefile.xml
	bake.py fix-config
	bake.py configure
	bake.py download -vvv

configure bakefile.xml: bake/bake.py
	rm -rf build source bakeconf.xml bakefile.xml bakeSetEnv.sh
	bake.py configure -e ns-3.40 -e ns3-defiance -e ns3-ai

submodule bake/bake.py:
	git submodule update --init

clean:
	rm -rf build source bakeconf.xml bakefile.xml bakeSetEnv.sh
