#ifndef __SIDEBAR_H__
#define __SIDEBAR_H__

#include <glib.h>
#include <gtk/gtk.h>

//
// GTK OOP BOILERPLATE
//
typedef struct _WinTCExplorerSidebarClass
{
    GObjectClass __parent__;
} WinTCExplorerSidebarClass;

typedef struct _WinTCExplorerSidebar
{
    GObject __parent__;

    GtkWidget* owner_explorer_wnd;
    GtkWidget* root_widget;
} WinTCExplorerSidebar;

#define WINTC_TYPE_EXPLORER_SIDEBAR (wintc_explorer_sidebar_get_type())
#define WINTC_EXPLORER_SIDEBAR(obj) (G_TYPE_CHECK_INSTANCE_CAST((obj), WINTC_TYPE_EXPLORER_SIDEBAR, WinTCExplorerSidebar))
#define WINTC_EXPLORER_SIDEBAR_CLASS(klass) (G_TYPE_CHECK_CLASS_CAST((klass), WINTC_TYPE_EXPLORER_SIDEBAR, WinTCExplorerSidebarClass))
#define IS_WINTC_EXPLORER_SIDEBAR(obj) (G_TYPE_CHECK_INSTANCE_TYPE((obj), WINTC_TYPE_EXPLORER_SIDEBAR))
#define IS_WINTC_EXPLORER_SIDEBAR_CLASS(klass) (G_TYPE_CHECK_CLASS_TYPE((klass), WINTC_TYPE_EXPLORER_SIDEBAR))
#define WINTC_EXPLORER_SIDEBAR_GET_CLASS(obj) (G_TYPE_INSTANCE_GET_CLASS((obj), WINTC_TYPE_EXPLORER_SIDEBAR, WinTCExplorerSidebar))

GType wintc_explorer_sidebar_get_type(void) G_GNUC_CONST;

//
// PUBLIC FUNCTIONS
//
GtkWidget* wintc_explorer_sidebar_get_root_widget(
    WinTCExplorerSidebar* sidebar
);

#endif
