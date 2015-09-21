if(CMAKE_BUILD_TYPE STREQUAL "Release")
    find_package(InnoSetup)

    if(InnoSetup_FOUND AND SignTool_FOUND)
        set(WINDOWS_SETUP_DEPENDENCIES
            leveldbutil
            qdb_api
            qdb_bench
            qdb_dbtool
            qdb_generate_config
            qdb_http_service
            qdb_httpd
            qdb_service
            qdbd
            qdbsh
        )

        set(WINDOWS_SETUP_NAME "qdb-${QDB_VERSION}-windows-${QDB_CPU_ARCH}-server-setup")
        set(WINDOWS_SETUP_OUTPUT "${QDB_OUTPUT_DIRECTORY}/${WINDOWS_SETUP_NAME}.exe")
        set(WINDOWS_SETUP_SCRIPT ${CMAKE_CURRENT_SOURCE_DIR}/qdb-server.iss)
        set(WINDOWS_SETUP_README "${CMAKE_CURRENT_BINARY_DIR}/README.txt")

        set(ISCC_FLAGS
            "/sStandard=\"${SignTool_EXECUTABLE} sign \$p\""
            "/dQdbVersion=${QDB_VERSION}"
            "/dQdbOutputDir=${QDB_OUTPUT_DIRECTORY}"
            "/dQdbSourceDir=${CMAKE_SOURCE_DIR}"
            "/dQdbSetupBaseName=${WINDOWS_SETUP_NAME}"
            "/dQdbReadme=${WINDOWS_SETUP_README}"
        )

        if(QDB_CPU_ARCH_IS_64BIT)
            list(APPEND ISCC_FLAGS "/dQdbIs64bit=1")
        else()
            list(APPEND ISCC_FLAGS "/dQdbIs64bit=0")
        endif()

        string(REPLACE ";" " " ISCC_FLAGS_STR "${ISCC_FLAGS}")

        configure_file(${README_TXT_FILE} ${WINDOWS_SETUP_README} NEWLINE_STYLE WIN32)

        add_custom_command(
            OUTPUT ${WINDOWS_SETUP_OUTPUT}
            COMMAND ${InnoSetup_EXECUTABLE} ${ISCC_FLAGS_STR} ${WINDOWS_SETUP_SCRIPT}
            DEPENDS ${WINDOWS_SETUP_SCRIPT} ${WINDOWS_SETUP_DEPENDENCIES}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            COMMENT "Building Windows setup")

        add_custom_target(qdb_windows_setup ALL DEPENDS ${WINDOWS_SETUP_OUTPUT})
    endif()
endif()
