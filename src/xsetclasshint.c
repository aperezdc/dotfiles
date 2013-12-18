/*
 * xsetclasshint.c
 * Copyright (C) 2012 Adrian Perez <aperez@igalia.com>
 * Distributed under terms of the MIT license.
 *
 * Build with:
 *   cc -o xsetclasshint xsetclasshint.c `pkg-config x11 --libs`
 *
 * Install compiled program to:
 *   ~/.local/bin/xsetclasshint
 */

#include <X11/X.h>
#include <X11/Xlib.h>
#include <X11/Xutil.h>
#include <stdlib.h>
#include <limits.h>
#include <stdio.h>
#include <errno.h>

int
main (int argc, char **argv)
{
  XClassHint hint = { NULL, NULL };
  Display *disp = NULL;
  Window w = 0x0;

  if (argc != 4)
    {
      fprintf (stderr,
               "Usage: %s window-id window-name window-class\n",
               argv[0]);
      exit (EXIT_FAILURE);
    }

  if ((w = (Window) strtoul (argv[1], NULL, 0)) == ULONG_MAX &&
      errno == ERANGE)
    {
      fprintf (stderr, "%s: window-id '%s' invalid\n", argv[0], argv[1]);
      exit (EXIT_FAILURE);
    }

  if ((disp = XOpenDisplay (NULL)) == NULL)
    {
      fprintf (stderr, "%s: Could not open X display\n", argv[0]);
      exit (EXIT_FAILURE);
    }

  hint.res_name  = argv[2];
  hint.res_class = argv[3];

  XSetClassHint (disp, w, &hint);
  XCloseDisplay (disp);

  return EXIT_SUCCESS;;
}
