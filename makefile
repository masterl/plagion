#   =======================
#  ||    ROOT MAKEFILE    ||
#   =======================
#

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#	Some helpers:
#--------------------------------------------------------------------------
empty =
tab = $(empty)$(shell printf '\t')$(empty)

define execute-command
$(tab)$(1)

endef

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#	Compiler:
#--------------------------------------------------------------------------
CC = gcc

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#	Directories for linking
#--------------------------------------------------------------------------
# ======== GERAL ========
# LIBDIR = -L/usr/lib
# LOCALLIBDIR =  -L/usr/local/lib

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#	Compilation flags
#--------------------------------------------------------------------------

GENERALSTARTFLAGS = -Wall

ALLCOMPFLAGS = $(GENERALSTARTFLAGS) `pkg-config --cflags gtk+-3.0`

ifeq ($(MAKECMDGOALS),test)
	TESTFLAGS =
endif

LINKFLAGS = $(TESTFLAGS) `pkg-config --libs gtk+-3.0`

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#	Sources directories
#--------------------------------------------------------------------------
# ======== main ========
MAINDIR = src

GUIDIR=src/gui

UTILSDIR = utils

ifeq ($(MAKECMDGOALS),test)
	TESTSDIR = tests
	_ALLSRCDIRLIST = $(MAINDIR) $(UTILSDIR) $(TESTSDIR) $(GUIDIR)
else
	_ALLSRCDIRLIST = $(MAINDIR) $(UTILSDIR) $(GUIDIR)
endif

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#	Dependencies and object directories
#--------------------------------------------------------------------------
DEPDIR = deps

DEPDIRLIST = $(addsuffix /$(DEPDIR),$(_ALLSRCDIRLIST))

DEPSUFFIX = _dep

#----====----====----====----====----
OBJDIR = objs

OBJDIRLIST = $(addsuffix /$(OBJDIR),$(_ALLSRCDIRLIST))

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Sources list
#--------------------------------------------------------------------------
# ALLSRCFILES = $(foreach dir,$(_ALLSRCDIRLIST),$(wildcard $(dir)/*.c))

ifeq ($(MAKECMDGOALS),test)
	ALLSRCFILES = $(filter-out $(foreach dir,$(_ALLSRCDIRLIST),$(wildcard $(dir)/*.c)) , $(MAINDIR)/main.c)
	MAINFILES = $(filter-out $(MAINDIR)/main.c , $(wildcard $(MAINDIR)/*.c) )
	TESTSFILES = $(wildcard $(TESTSDIR)/*.c)
endif

ifeq ($(MAKECMDGOALS),exec)
	ALLSRCFILES = $(foreach dir,$(_ALLSRCDIRLIST),$(wildcard $(dir)/*.c))
	MAINFILES = $(wildcard $(MAINDIR)/*.c)
endif

UTILSFILES = $(wildcard $(UTILSDIR)/*.c)
GUIFILES = $(wildcard $(GUIDIR)/*.c)
HELPERSFILES = $(wildcard $(HELPERSDIR)/*.c)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Dependencies Lists
#--------------------------------------------------------------------------
#   Dependencias dos .o
MAINDEPS := $(addprefix $(MAINDIR)/$(DEPDIR)/,$(patsubst %.c,%.d,$(notdir $(MAINFILES))))
UTILSDEPS := $(addprefix $(UTILSDIR)/$(DEPDIR)/,$(patsubst %.c,%.d,$(notdir $(UTILSFILES))))
TESTSDEPS := $(addprefix $(TESTSDIR)/$(DEPDIR)/,$(patsubst %.c,%.d,$(notdir $(TESTSFILES))))
GUIDEPS := $(addprefix $(GUIDIR)/$(DEPDIR)/,$(patsubst %.c,%.d,$(notdir $(GUIFILES))))

#   Dependencias dos .d
MAINDEPDEPS := $(subst .d,$(DEPSUFFIX).d,$(MAINDEPS))
UTILSDEPDEPS := $(subst .d,$(DEPSUFFIX).d,$(UTILSDEPS))
GUIDEPDEPS := $(subst .d,$(DEPSUFFIX).d,$(GUIDEPS))
TESTSDEPDEPS := $(subst .d,$(DEPSUFFIX).d,$(TESTSDEPS))

ALLDEPDEPS :=	$(MAINDEPDEPS) $(UTILSDEPDEPS) $(TESTSDEPDEPS) $(GUIDEPDEPS)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Object Lists
#--------------------------------------------------------------------------
MAINOBJS := $(addprefix $(MAINDIR)/$(OBJDIR)/,$(patsubst %.c,%.o,$(notdir $(MAINFILES))))
UTILSOBJS := $(addprefix $(UTILSDIR)/$(OBJDIR)/,$(patsubst %.c,%.o,$(notdir $(UTILSFILES))))
TESTSOBJS := $(addprefix $(TESTSDIR)/$(OBJDIR)/,$(patsubst %.c,%.o,$(notdir $(TESTSFILES))))
GUIOBJS := $(addprefix $(GUIDIR)/$(OBJDIR)/,$(patsubst %.c,%.o,$(notdir $(GUIFILES))))

ALLOBJS :=	$(MAINOBJS) $(UTILSOBJS) $(TESTSOBJS) $(GUIOBJS)

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# Executable
#--------------------------------------------------------------------------
EXEC := plagion
TESTEXEC := test

BINDIR := bin

export CC
export ALLCOMPFLAGS
export LOCALLIBDIR
export DEPDIR
export OBJDIR
export DEPSUFFIX
export ALLDEPDEPS
export ALLOBJS

all:
	@echo -e '\n\n==================== ERROR ===================='
	@echo -e '   --------------------------------------------'
	@echo "   |        There's no default rule!           |"
	@echo -e '   --------------------------------------------'
	@echo -e '   Choose an option:\n'
	@echo -e '\texec\t    [compiles main executable]'
	@echo -e '\tclean\t\t    [erases all files]'
	@echo -e '===============================================\n\n'

exec: rmexec allobjs FORCE | $(BINDIR)
	$(CC) $(ALLOBJS) $(ALLCOMPFLAGS) -o $(BINDIR)/$(EXEC) $(LINKFLAGS)
	@echo -e '=----------------------------------------------------='
	@echo -e '=           $(EXEC) generated/updated       ='
	@echo -e '=           Executable: $(BINDIR)/$(EXEC)  \t     ='
	@echo -e '=----------------------------------------------------=\n\n'

test: compiletest
	@echo -e 'Executing tests...\n'
	@set -e;./$(BINDIR)/$(TESTEXEC) --log_level=message --build_info=yes --show_progress=true

compiletest: rmtest allobjs FORCE | $(BINDIR)
	$(CC) $(ALLOBJS) $(ALLCOMPFLAGS) -o $(BINDIR)/$(TESTEXEC) $(LINKFLAGS)
	@echo -e '=----------------------------------------------------='
	@echo -e '=           TESTS generated/updated                  ='
	@echo -e '=           Executable: $(BINDIR)/$(TESTEXEC)  \t\t     ='
	@echo -e '=----------------------------------------------------=\n\n'

allobjs: objdirs alldeps
	@set -e; $(MAKE) --no-print-directory -f makeobjs allobjs

#aobjsdebian: objdirs adeps
#	@set -e; $(MAKE) --no-print-directory -f makeobjs allobjs PGINCDIR=$(PGDEBIANINCDIR) PGLIBDIR=$(PGDEBIANLIBDIR)

#aobjscentos: objdirs adeps
#	@set -e; $(MAKE) --no-print-directory -f makeobjs allobjs PGINCDIR=$(PGCENTOSINCDIR) PGLIBDIR=$(PGCENTOSLIBDIR)

alldeps: depdirs
	@set -e; $(MAKE) --no-print-directory -f makedeps alldeps

depdirs: | $(DEPDIRLIST)
	@echo -e '------------------------------------------------------'
	@echo -e '\tDependencies directories created/checked!\n'

objdirs: | $(OBJDIRLIST)
	@echo -e '------------------------------------------------------'
	@echo -e '\tObjects directories created/checked!\n'

$(DEPDIRLIST) $(OBJDIRLIST) $(BINDIR):
	mkdir $@

clean: rmdeps rmobjs rmexec FORCE
	rm -rf $(BINDIR)
	@echo -e '------------------------------------------------------'
	@echo -e '\tAll files removed!\n\n'

rmexec:
	rm -f $(BINDIR)/$(EXEC)
	@echo -e '------------------------------------------------------'
	@echo -e '\tExecutables removed!'

rmtest:
	rm -f $(BINDIR)/$(TESTEXEC)
	@echo -e '------------------------------------------------------'
	@echo -e '\tTest executable removed!'

rmdeps: FORCE
	$(foreach dir, $(DEPDIRLIST) tests/$(DEPDIR), $(call execute-command, rm -rf $(dir) ) )

rmobjs: FORCE
	$(foreach dir, $(OBJDIRLIST) tests/$(OBJDIR), $(call execute-command, rm -rf $(dir) ) )

FORCE:

#  ===========================
#  ||    MAKEFILE >END<      ||
#  ===========================
