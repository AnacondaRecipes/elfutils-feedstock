#!/bin/bash
set -e

eu-addr2line --help
eu-ar --help
eu-elfclassify --help
eu-elfcmp --help
eu-elfcompress --help
eu-elflint --help
eu-findtextrel --help
eu-nm --help
eu-objdump --help
eu-ranlib --help
eu-readelf --help
eu-size --help
eu-srcfiles --help
eu-stack --help
eu-strings --help
eu-strip --help
eu-unstrip --help

# Every shipped library must be discoverable through its pkg-config file.
for lib in libelf libdw libdebuginfod; do
    pkg-config --exists ${lib}
done

eval "${CC} ${CFLAGS} ${LDFLAGS} -o ./test_libdwarf $RECIPE_DIR/test_libdwarf.c $(pkg-config --cflags libdw) $(pkg-config --libs libdw)"
./test_libdwarf
