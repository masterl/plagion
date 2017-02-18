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

#include <gtk/gtk.h>

enum { SITE_NAME, SIMILARITY, SITE_URL, N_COLUMNS };

void result_interface( GtkWidget *widget, gpointer app )
{
    GtkWidget *window;
    GtkListStore *model;
    GtkWidget *view;
    GtkTreeViewColumn *column;

    window = gtk_window_new( GTK_WINDOW_TOPLEVEL );
    gtk_window_set_title( GTK_WINDOW( window ), "Plagion" );
    gtk_window_set_default_size( GTK_WINDOW( window ), 500, 500 );
    gtk_window_set_resizable( GTK_WINDOW( window ), TRUE );
    gtk_container_set_border_width( GTK_CONTAINER( window ), 10 );

    model = gtk_list_store_new( N_COLUMNS,
                                G_TYPE_STRING, /* FILE_NAME */
                                G_TYPE_UINT,   /* SIMILARITY */
                                G_TYPE_STRING  /* SITE_URL */
                                );
    gtk_list_store_insert_with_values( model,
                                       NULL,
                                       -1,
                                       SITE_NAME,
                                       "Wikipedia",
                                       SIMILARITY,
                                       100,
                                       SITE_URL,
                                       "https://wikipedia.com",
                                       -1 );

    view = gtk_tree_view_new_with_model( GTK_TREE_MODEL( model ) );
    g_object_unref( model );

    column = gtk_tree_view_column_new_with_attributes(
        "SITE", gtk_cell_renderer_text_new(), "text", SITE_NAME, NULL );
    gtk_tree_view_append_column( GTK_TREE_VIEW( view ), column );
    gtk_tree_view_column_set_resizable( GTK_TREE_VIEW_COLUMN( column ), TRUE );
    gtk_tree_view_column_set_min_width( GTK_TREE_VIEW_COLUMN( column ), 100 );
    gtk_tree_view_column_set_expand( column, TRUE );

    column = gtk_tree_view_column_new_with_attributes(
        "URL", gtk_cell_renderer_spin_new(), "text", SITE_URL, NULL );
    gtk_tree_view_append_column( GTK_TREE_VIEW( view ), column );
    gtk_tree_view_column_set_resizable( GTK_TREE_VIEW_COLUMN( column ), TRUE );
    gtk_tree_view_column_set_min_width( GTK_TREE_VIEW_COLUMN( column ), 100 );
    gtk_tree_view_column_set_expand( column, TRUE );

    column = gtk_tree_view_column_new_with_attributes(
        "SIMILARIDADE %", gtk_cell_renderer_text_new(), "text", SIMILARITY, NULL );
    gtk_tree_view_append_column( GTK_TREE_VIEW( view ), column );
    gtk_tree_view_column_set_resizable( GTK_TREE_VIEW_COLUMN( column ), TRUE );
    gtk_tree_view_column_set_min_width( GTK_TREE_VIEW_COLUMN( column ), 100 );
    gtk_tree_view_column_set_expand( column, TRUE );

    gtk_container_add( GTK_CONTAINER( window ), view );

    gtk_widget_show_all( window );
}
