# ----------------------------------------------------------------------------
#   An auxiliary function to show messages:
# ----------------------------------------------------------------------------
MACRO(SHOW_CONFIG_LINE MSG_TEXT VALUE_BOOL)
	IF(${VALUE_BOOL})
		SET(VAL_TEXT "Yes")
	ELSE(${VALUE_BOOL})
		SET(VAL_TEXT " No")
	ENDIF(${VALUE_BOOL})
	MESSAGE(STATUS " ${MSG_TEXT} : ${VAL_TEXT} ${ARGV2}")
ENDMACRO(SHOW_CONFIG_LINE)

MACRO(SHOW_CONFIG_LINE_SYSTEM MSG_TEXT VALUE_BOOL)
	IF(${VALUE_BOOL})
		IF(${VALUE_BOOL}_SYSTEM)
			SET(VAL_TEXT "Yes (System)")
		ELSE(${VALUE_BOOL}_SYSTEM)
			SET(VAL_TEXT "Yes (Built-in)")
		ENDIF(${VALUE_BOOL}_SYSTEM)
	ELSE(${VALUE_BOOL})
		SET(VAL_TEXT " No")
	ENDIF(${VALUE_BOOL})
	MESSAGE(STATUS " ${MSG_TEXT} : ${VAL_TEXT} ${ARGV2}")
ENDMACRO(SHOW_CONFIG_LINE_SYSTEM)

# ----------------------------------------------------------------------------
#   Summary:
# ----------------------------------------------------------------------------
MESSAGE(STATUS "")
IF(CMAKE_COMPILER_IS_GNUCXX)
	SET(MRPT_GCC_VERSION_STR "(GCC version: ${CMAKE_MRPT_GCC_VERSION})")
ENDIF(CMAKE_COMPILER_IS_GNUCXX)

MESSAGE(STATUS "List of MRPT libs/modules to be built (and dependencies):")
MESSAGE(STATUS "-----------------------------------------------------------------")
FOREACH(_LIB ${ALL_MRPT_LIBS})
	get_property(_LIB_DEP GLOBAL PROPERTY "${_LIB}_LIB_DEPS")
	get_property(_LIB_HDRONLY GLOBAL PROPERTY "${_LIB}_LIB_IS_HEADERS_ONLY")
	get_property(_LIB_METALIB GLOBAL PROPERTY "${_LIB}_LIB_IS_METALIB")
	# Say whether each lib is a normal or header-only lib:
	set(_LIB_TYPE "")
	IF (_LIB_METALIB)
		SET(_LIB_TYPE "  (meta-lib)")
	ELSEIF(_LIB_HDRONLY)
		SET(_LIB_TYPE "  (header-only)")
	ENDIF(_LIB_METALIB)

	MESSAGE(STATUS "  ${_LIB} : ${_LIB_DEP} ${_LIB_TYPE}")
ENDFOREACH(_LIB)
MESSAGE(STATUS "")

MESSAGE(STATUS "+===========================================================================+")
MESSAGE(STATUS "|         Resulting configuration for ${CMAKE_MRPT_COMPLETE_NAME}                            |")
MESSAGE(STATUS "+===========================================================================+")
MESSAGE(STATUS " _________________________ PLATFORM _____________________________")
MESSAGE(STATUS " Host                        : "             ${CMAKE_HOST_SYSTEM_NAME} ${CMAKE_HOST_SYSTEM_VERSION} ${CMAKE_HOST_SYSTEM_PROCESSOR})
if(CMAKE_CROSSCOMPILING)
MESSAGE(STATUS " Target                      : "         ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_VERSION} ${CMAKE_SYSTEM_PROCESSOR})
endif(CMAKE_CROSSCOMPILING)
SHOW_CONFIG_LINE("Is the system big endian?  " CMAKE_MRPT_IS_BIG_ENDIAN)
MESSAGE(STATUS " Word size (32/64 bit)       : ${CMAKE_MRPT_WORD_SIZE}")
MESSAGE(STATUS " CMake version               : " ${CMAKE_VERSION})
MESSAGE(STATUS " CMake generator             : "  ${CMAKE_GENERATOR})
MESSAGE(STATUS " CMake build tool            : " ${CMAKE_BUILD_TOOL})
MESSAGE(STATUS " Compiler                    : " ${CMAKE_CXX_COMPILER_ID})
if(MSVC)
	MESSAGE(STATUS " MSVC                        : " ${MSVC_VERSION})
endif(MSVC)
if(CMAKE_GENERATOR MATCHES Xcode)
	MESSAGE(STATUS " Xcode                       : " ${XCODE_VERSION})
endif(CMAKE_GENERATOR MATCHES Xcode)
if(NOT CMAKE_GENERATOR MATCHES "Xcode|Visual Studio")
	MESSAGE(STATUS " Configuration               : "  ${CMAKE_BUILD_TYPE})
endif(NOT CMAKE_GENERATOR MATCHES "Xcode|Visual Studio")

IF("${CMAKE_BUILD_TYPE}" STREQUAL "Release")
   MESSAGE( STATUS "C++ flags (Release):     ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE}")
ELSEIF("${CMAKE_BUILD_TYPE}" STREQUAL "Debug")
   MESSAGE( STATUS "C++ flags (Debug):       ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_DEBUG}")
ENDIF()


MESSAGE(STATUS "")
MESSAGE(STATUS " __________________________ OPTIONS _____________________________")
SHOW_CONFIG_LINE("Build MRPT as a shared library?  " CMAKE_MRPT_BUILD_SHARED_LIB_ONOFF)

IF(MRPT_AUTODETECT_SSE)
	set(STR_SSE_DETECT_MODE "Automatic")
ELSE(MRPT_AUTODETECT_SSE)
	set(STR_SSE_DETECT_MODE "Manually set")
ENDIF(MRPT_AUTODETECT_SSE)
MESSAGE(STATUS " Use SIMD optimizations?           : SSE2=" ${CMAKE_MRPT_HAS_SSE2} " SSE3=" ${CMAKE_MRPT_HAS_SSE3} " SSE4.1=" ${CMAKE_MRPT_HAS_SSE4_1} " SSE4.2=" ${CMAKE_MRPT_HAS_SSE4_2} " SSE4a=" ${CMAKE_MRPT_HAS_SSE4_A} " [" ${STR_SSE_DETECT_MODE} "]")

IF($ENV{VERBOSE})
	SHOW_CONFIG_LINE("Additional checks even in Release  " CMAKE_MRPT_ALWAYS_CHECKS_DEBUG)
	SHOW_CONFIG_LINE("Additional matrix checks           " CMAKE_MRPT_ALWAYS_CHECKS_DEBUG_MATRICES)
ENDIF($ENV{VERBOSE})
MESSAGE(STATUS " Install prefix                    : ${CMAKE_INSTALL_PREFIX}")
MESSAGE(STATUS " C++ config header                 : ${MRPT_CONFIG_FILE_INCLUDE_DIR}")
MESSAGE(STATUS "")

IF($ENV{VERBOSE})
	MESSAGE(STATUS " _________________________ COMPILER OPTIONS _____________________")
	message(STATUS "Compiler:                  ${CMAKE_CXX_COMPILER} ${MRPT_GCC_VERSION_STR} ")
	message(STATUS "  C++ flags (Release):       ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_RELEASE}")
	message(STATUS "  C++ flags (Debug):         ${CMAKE_CXX_FLAGS} ${CMAKE_CXX_FLAGS_DEBUG}")
	message(STATUS "  Executable link flags (Release):    ${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_EXE_LINKER_FLAGS_RELEASE}")
	message(STATUS "  Executable link flags (Debug):      ${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_EXE_LINKER_FLAGS_DEBUG}")
	message(STATUS "  Lib link flags (Release):    ${CMAKE_SHARED_LINKER_FLAGS} ${CMAKE_SHARED_LINKER_FLAGS_RELEASE}")
	message(STATUS "  Lib link flags (Debug):      ${CMAKE_SHARED_LINKER_FLAGS} ${CMAKE_SHARED_LINKER_FLAGS_DEBUG}")
	MESSAGE(STATUS "")
ENDIF($ENV{VERBOSE})

MESSAGE(STATUS " ______________________ OPTIONAL LIBRARIES ______________________")
SHOW_CONFIG_LINE_SYSTEM("Assimp (3D models)                  " CMAKE_MRPT_HAS_ASSIMP "[Version: ${ASSIMP_VERSION}]")
SHOW_CONFIG_LINE_SYSTEM("eigen3                              " CMAKE_MRPT_HAS_EIGEN "[Version: ${MRPT_EIGEN_VERSION}]")
SHOW_CONFIG_LINE_SYSTEM("ffmpeg libs (Video streaming)       " CMAKE_MRPT_HAS_FFMPEG "[avcodec ${LIBAVCODEC_VERSION}, avutil ${LIBAVUTIL_VERSION}, avformat ${LIBAVFORMAT_VERSION}]")
SHOW_CONFIG_LINE_SYSTEM("gtest (Google unit testing library) " CMAKE_MRPT_HAS_GTEST )
SHOW_CONFIG_LINE("Intel threading lib (TBB)           " CMAKE_MRPT_HAS_TBB)
SHOW_CONFIG_LINE_SYSTEM("lib3ds (3DStudio scenes)            " CMAKE_MRPT_HAS_LIB3DS)
SHOW_CONFIG_LINE_SYSTEM("libclang (for ConvertUTF)           " CMAKE_MRPT_HAS_CLANG)
SHOW_CONFIG_LINE_SYSTEM("libjpeg (jpeg)                      " CMAKE_MRPT_HAS_JPEG)
SHOW_CONFIG_LINE_SYSTEM("liblas (ASPRS LAS LiDAR format)     " CMAKE_MRPT_HAS_LIBLAS)
SHOW_CONFIG_LINE("mexplus                             " CMAKE_MRPT_HAS_MATLAB)
SHOW_CONFIG_LINE_SYSTEM("OpenCV (Image manipulation)         " CMAKE_MRPT_HAS_OPENCV "[Version: ${MRPT_OPENCV_VERSION}, Has non-free: ${CMAKE_MRPT_HAS_OPENCV_NONFREE}]")
SHOW_CONFIG_LINE_SYSTEM("OpenGL                              " CMAKE_MRPT_HAS_OPENGL_GLUT)
SHOW_CONFIG_LINE_SYSTEM("GLUT                                " CMAKE_MRPT_HAS_GLUT)
SHOW_CONFIG_LINE_SYSTEM("PCAP (Wireshark logs for Velodyne)  " CMAKE_MRPT_HAS_LIBPCAP)
SHOW_CONFIG_LINE_SYSTEM("PCL (Pointscloud library)           " CMAKE_MRPT_HAS_PCL  "[Version: ${PCL_VERSION}]")
SHOW_CONFIG_LINE("SuiteSparse                         " CMAKE_MRPT_HAS_SUITESPARSE)
SHOW_CONFIG_LINE_SYSTEM("wxWidgets                           " CMAKE_MRPT_HAS_WXWIDGETS)
SHOW_CONFIG_LINE_SYSTEM("zlib (compression)                  " CMAKE_MRPT_HAS_ZLIB)
SHOW_CONFIG_LINE_SYSTEM("yamlcpp (YAML file format)          " CMAKE_MRPT_HAS_YAMLCPP "[Version: ${LIBYAMLCPP_VERSION}]")
MESSAGE(STATUS  "")

MESSAGE(STATUS " _______________________ WRAPPERS/BINDINGS ______________________")
SHOW_CONFIG_LINE_SYSTEM("Matlab / mex files " CMAKE_MRPT_HAS_MATLAB "[Version: ${MATLAB_VERSION}]")
MESSAGE(STATUS "")

MESSAGE(STATUS " _____________________ HARDWARE & SENSORS _______________________")
SHOW_CONFIG_LINE_SYSTEM("libdc1394-2 (FireWire capture)      " CMAKE_MRPT_HAS_LIBDC1394_2)
SHOW_CONFIG_LINE("DUO3D Camera libs                   " CMAKE_MRPT_HAS_DUO3D)
IF(UNIX)
SHOW_CONFIG_LINE_SYSTEM("libftdi (USB)                       " CMAKE_MRPT_HAS_FTDI "[Version: ${LIBFTDI_VERSION_STRING}]")
ENDIF(UNIX)
message(STATUS " National Instruments...")
SHOW_CONFIG_LINE("...NIDAQmx?                         " CMAKE_MRPT_HAS_NIDAQMX)
SHOW_CONFIG_LINE("...NIDAQmx Base?                    " CMAKE_MRPT_HAS_NIDAQMXBASE)
SHOW_CONFIG_LINE_SYSTEM("NITE2 library                       " CMAKE_MRPT_HAS_NITE2)
SHOW_CONFIG_LINE_SYSTEM("OpenKinect libfreenect              " CMAKE_MRPT_HAS_FREENECT)
SHOW_CONFIG_LINE_SYSTEM("OpenNI2                             " CMAKE_MRPT_HAS_OPENNI2)
SHOW_CONFIG_LINE("PGR Digiclops/Triclops (Windows)    " CMAKE_MRPT_HAS_BUMBLEBEE)
SHOW_CONFIG_LINE("PGR FlyCapture2                     " CMAKE_MRPT_HAS_FLYCAPTURE2)
SHOW_CONFIG_LINE("PGR Triclops                        " CMAKE_MRPT_HAS_TRICLOPS)
SHOW_CONFIG_LINE_SYSTEM("Phidgets                            " CMAKE_MRPT_HAS_PHIDGET)
SHOW_CONFIG_LINE("RoboPeak LIDAR                      " CMAKE_MRPT_HAS_ROBOPEAK_LIDAR)
SHOW_CONFIG_LINE_SYSTEM("SwissRanger 3/4000 3D camera        " CMAKE_MRPT_HAS_SWISSRANGE )
SHOW_CONFIG_LINE_SYSTEM("Videre SVS stereo camera            " CMAKE_MRPT_HAS_SVS)
IF(UNIX)
SHOW_CONFIG_LINE_SYSTEM("libudev (requisite for XSensMT4)    " CMAKE_MRPT_HAS_LIBUDEV)
ENDIF(UNIX)
SHOW_CONFIG_LINE_SYSTEM("xSENS MT 3rd generation             " CMAKE_MRPT_HAS_xSENS_MT3)
SHOW_CONFIG_LINE_SYSTEM("xSENS MT 4th generation             " CMAKE_MRPT_HAS_xSENS_MT4)
SHOW_CONFIG_LINE_SYSTEM("Intersense sensors                  " CMAKE_MRPT_HAS_INTERSENSE)
MESSAGE(STATUS  "")

MESSAGE(STATUS " _________________________ BINDINGS _____________________________")
SHOW_CONFIG_LINE("Build MRPT python bindings? (pymrpt)" CMAKE_MRPT_HAS_PYTHON_BINDINGS)
SHOW_CONFIG_LINE("- dep: Boost found?                 " Boost_FOUND)
SHOW_CONFIG_LINE("- dep: PythonLibs found?            " PYTHONLIBS_FOUND)

# Final warnings:
IF (NOT CMAKE_MRPT_HAS_OPENCV AND NOT DISABLE_OPENCV)
	MESSAGE(STATUS "")
	MESSAGE(STATUS "***********************************************************************")
	MESSAGE(STATUS "* WARNING: It's STRONGLY recommended to build MRPT with OpenCV support.")
	MESSAGE(STATUS "*  To do so, set OpenCV_DIR to its CMake build dir. If you want to go ")
	MESSAGE(STATUS "*  on without OpenCV, proceed to build instead. ")
	MESSAGE(STATUS "***********************************************************************")
	MESSAGE(STATUS "")
ENDIF(NOT CMAKE_MRPT_HAS_OPENCV AND NOT DISABLE_OPENCV)

