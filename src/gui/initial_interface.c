/*
The MIT License (MIT)
Copyright (c) 2017 Leonardo Lourenço & Lorhan Sohaky
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#include <initial_interface.h>

void initial_interface( GtkApplication *app, gpointer user_data )
{
    GtkWidget *window, *grid, *button, *label, *file;

    window = gtk_application_window_new( app );
    gtk_window_set_title( GTK_WINDOW( window ), "Plagion" );
    gtk_window_set_default_size( GTK_WINDOW( window ), 300, 200 );
    gtk_window_set_resizable( GTK_WINDOW( window ), FALSE );
    gtk_container_set_border_width( GTK_CONTAINER( window ), 10 );

    grid = gtk_grid_new();
    gtk_grid_set_column_homogeneous( GTK_GRID( grid ), TRUE );
    gtk_container_add( GTK_CONTAINER( window ), grid );

    label = gtk_label_new( "Arquivo a ser verificado: " );
    gtk_grid_attach( GTK_GRID( grid ), label, 0, 0, 1, 1 );

    file = gtk_file_chooser_button_new( "Selecione o arquivo que deve ser verificado",
                                        GTK_FILE_CHOOSER_ACTION_OPEN );
    gtk_grid_attach( GTK_GRID( grid ), file, 1, 0, 1, 1 );

    button = gtk_button_new_with_label(
        "Verificar" ); // TODO change background color:#5cb85c border:#4cae4c
    gtk_widget_set_valign(
        button,
        GTK_ALIGN_END ); // TODO on hover background color:#449d44 border:#398439
    gtk_grid_attach( GTK_GRID( grid ), button, 0, 1, 2, 1 );

    gtk_widget_show_all( window );
}
