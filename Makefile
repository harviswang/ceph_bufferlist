DEBUG_FLAGS?=-O0 -g3 -gdwarf-4

CFLAGS+=$(DEBUG_FLAGS) \
	-Isrc/ \
	-Ibuild/include

c_objects=src/common/escape.o \
          src/common/safe_io.o \
          src/common/armor.o \
          src/arch/intel.o \
          src/common/crc32c_intel_fast.o \
          src/common/crc32c_intel_baseline.o \
          src/common/sctp_crc32.o

CXXFLAGS+=$(DEBUG_FLAGS) \
	  -std=c++11 \
          -DCEPH_LIBDIR=\"/usr/local/lib64\" \
          -DCEPH_PKGLIBDIR=\"/usr/local/lib64/ceph\"

CXXFLAGS+=-Isrc/ \
          -Ibuild/src/include \
          -I/CEPH/build/boost/include \
	  -Isrc/include \
	  -Ibuild/include 

LDFLAGS+= -L/CEPH/build/boost/lib \
          -lpthread \
          -lm \
          -lgtest \
          -lgtest_main \
          -lboost_system \
          -lboost_iostreams \
          -lboost_thread \
          -ldl \
          -lnspr4 \
          -lnss3


cxx_objects=src/test/bufferlist.o

dependency_cxx_objects=src/common/buffer.o \
                       src/common/mempool.o \
                       src/common/assert.o \
                       src/common/dout.o \
                       src/common/BackTrace.o \
                       src/common/version.o \
                       src/log/Log.o \
                       src/common/PrebufferedStreambuf.o \
                       src/common/Thread.o \
                       src/common/io_priority.o \
                       src/common/signal.o \
                       src/common/environment.o \
                       src/common/code_environment.o \
                       src/common/page.o \
                       src/log/Log.o \
                       src/common/Graylog.o \
                       src/common/Formatter.o \
                       src/common/HTMLFormatter.o \
                       src/common/LogEntry.o \
                       src/common/Clock.o \
                       src/common/crc32c.o \
                       src/common/strtol.o \
                       src/common/errno.o \
                       src/common/simple_spin.o \
                       src/arch/probe.o \
                       src/common/crc32c_intel_fast_zero_asm.o \
                       src/common/crc32c_intel_fast_asm.o \
                       src/common/ceph_strings.o \
                       src/msg/msg_types.o
 
.S.o:
	yasm -f elf64 $< -o $@

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

.cc.o:
	$(CXX) $(CXXFLAGS) -c $< -o $@


all: $(c_objects) $(cxx_objects) $(dependency_cxx_objects)
	$(CXX) $(LDFLAGS) $^

clean: $(c_objects) $(cxx_objects) $(dependency_cxx_objects)
	rm $^ a.out

.PHONY: clean all
