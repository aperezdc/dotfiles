#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2015 Adrian Perez <aperez@igalia.com>
#
# Distributed under terms of the MIT license.

from os import path
S = path.expanduser(path.join(path.dirname(path.dirname(path.dirname(__file__))), ".signature"))

def pre_edit_translate(body, ui=None, dbm=None):
    if path.isfile(S):
        signature = None
        try:
            with open(S, "rb") as fd:
                signature = fd.read()
        except:
            pass
        if signature is not None:
            body = body + "\n--\n" + signature.decode("utf-8")

    return body
