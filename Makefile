#
# Tencent is pleased to support the open source community by making Libco available.
# 
# Copyright (C) 2014 THL A29 Limited, a Tencent company. All rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License"); 
# you may not use this file except in compliance with the License. 
# You may obtain a copy of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, 
# software distributed under the License is distributed on an "AS IS" BASIS, 
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. 
# See the License for the specific language governing permissions and 
# limitations under the License.
#


COMM_MAKE = 1
COMM_ECHO = 1
version=0.5
v=debug
include aco.mk

########## options ##########
CFLAGS += -g -fno-strict-aliasing -O2 -Wall -export-dynamic \
	-Wall -pipe  -D_GNU_SOURCE -D_REENTRANT -fPIC -Wno-deprecated -m64

UNAME := $(shell uname -s)

ifeq ($(UNAME), FreeBSD)
LINKS += -g -L./lib -lacolib -lpthread
else
LINKS += -g -L./lib -lacolib -lpthread -ldl
endif

ACOLIB_OBJS=aco.o acosw.S
#co_swapcontext.o

PROGS = acolib

all:$(PROGS)

acolib:libacolib.a libacolib.so

libacolib.a: $(ACOLIB_OBJS)
	$(ARSTATICLIB) 
libacolib.so: $(ACOLIB_OBJS)
	$(BUILDSHARELIB) 


dist: clean libaco-$(version).src.tar.gz

libaco-$(version).src.tar.gz:
	@find . -type f | grep -v CVS | grep -v .svn | sed s:^./:libaco-$(version)/: > MANIFEST
	@(cd ..; ln -s libaco_pub libaco-$(version))
	(cd ..; tar cvf - `cat libaco_pub/MANIFEST` | gzip > libaco_pub/libaco-$(version).src.tar.gz)
	@(cd ..; rm libaco-$(version))

clean:
	$(CLEAN) *.o $(PROGS)
	rm -fr MANIFEST lib solib libaco-$(version).src.tar.gz libaco-$(version)

