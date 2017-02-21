#include "gui/app.h"
#include <stdio.h>

int main( int argc, char const *argv[] )
{
    if( argc == 1 ) { // GUI
        init_application();
    } else { // COMMAND LINE
    }

    return 0;
}
