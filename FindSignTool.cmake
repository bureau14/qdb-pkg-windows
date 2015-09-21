# Once done, will define
# SignTool_FOUND - system has SignTool
# SignTool_EXECUTABLE - full path to signtool

set(SignTool_FOUND FALSE)

if(WIN32)
    set(ProgramFiles_x86 "ProgramFiles(x86)")
    find_program(SignTool_EXECUTABLE
        NAMES signtool
        PATHS
            "$ENV{${ProgramFiles_x86}}/Microsoft SDKs/Windows/v7.0A" "$ENV{ProgramFiles}/Microsoft SDKs/Windows/v7.0A"
            "$ENV{${ProgramFiles_x86}}/Microsoft SDKs/Windows/v7.1A" "$ENV{ProgramFiles}/Microsoft SDKs/Windows/v7.1A"
            "$ENV{${ProgramFiles_x86}}/Microsoft SDKs/Windows/v6.0A" "$ENV{ProgramFiles}/Microsoft SDKs/Windows/v6.0A"
        ENV PATH
        PATH_SUFFIXES bin)
endif()

if(SignTool_EXECUTABLE)
    set(SignTool_FOUND TRUE)
endif()

function(SIGN_EXECUTABLE TARGETNAME)
    set(CERTIFICATE_SHA1 "111683AA5D55235EE6D5C9A3CF79575184519F9C")
    set(CONTENT_URL "https://www.quasardb.net/")
    if(CMAKE_BUILD_TYPE STREQUAL Release)
        if(NOT TARGETNAME)
            message(SEND_ERROR "Error: SIGN_EXECUTABLE called without any files")
            return()
        endif()

        if(NOT SignTool_FOUND)
            message(STATUS "Signing tool not found, binaries will not be digitaly signed")
        else()
            add_custom_command(TARGET ${TARGETNAME} POST_BUILD
                COMMAND ${RUN_RELEASE_ONLY} $<CONFIGURATION> ${SignTool_EXECUTABLE} sign /sha1 ${CERTIFICATE_SHA1} /du ${CONTENT_URL} $<TARGET_FILE:${TARGETNAME}>
                COMMENT "Signing executable ${TARGETNAME}")
        endif()
    endif()
endfunction()
