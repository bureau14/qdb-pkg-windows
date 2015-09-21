set(InnoSetup_FOUND FALSE)

if(WIN32)
    set(ProgramFiles_x86 "ProgramFiles(x86)")
    find_program(InnoSetup_EXECUTABLE
        NAMES iscc
        PATHS
            "$ENV{${ProgramFiles_x86}}/Inno Setup 5" "$ENV{ProgramFiles}/Inno Setup 5"
        ENV PATH
        PATH_SUFFIXES bin)
endif(WIN32)

if(InnoSetup_EXECUTABLE)
    set(InnoSetup_FOUND TRUE)
endif(InnoSetup_EXECUTABLE)
