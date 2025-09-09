## -- Configuration and variables that control the make process
## -- This is independent of the project that you are building
## -- Project specific settings are in settings.mk file
## -- If you need to add deeper should be defined in put them in
##    there own makefile and pull them in.


## -- Only touch the SHELL variable if you know what you are doing.
## -- P.S.: You don't know what you are doing, leave it the fu*k
##          alone!
SHELL = /bin/bash

## initialize all the internal variables here

mkutils.autoconf.ATVARS :=
mkutils.ATVARS :=

--mkutils-SED-XP := 


-include $(mkutils.makefiledir)/config.mk

