/* -*- Mode: C -*-*/
/*======================================================================
  FILE: ical.i

  (C) COPYRIGHT 1999 Eric Busboom
  http://www.softwarestudio.org

  The contents of this file are subject to the Mozilla Public License
  Version 1.0 (the "License"); you may not use this file except in
  compliance with the License. You may obtain a copy of the License at
  http://www.mozilla.org/MPL/

  Software distributed under the License is distributed on an "AS IS"
  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
  the License for the specific language governing rights and
  limitations under the License.

  The original author is Eric Busboom

  Contributions from:
  Graham Davison (g.m.davison@computer.org)

  ======================================================================*/

%module LibicalWrap


%{
#include "libical/ical.h"
#include "libicalss/icalss.h"

#include <sys/types.h> /* for size_t */
#include <time.h>

%}

%pythoncode %{
import Error

%}

%feature("autodoc", "1");

typedef int time_t;

// Remove depreciated functions
%ignore icalproperty_string_to_enum(const char* str);
%ignore icaltimezone_get_utc_offset(icaltimezone    *zone,
                                    struct icaltimetype *tt,
                                    int     *is_daylight);
%ignore icaltimezone_get_utc_offset_of_utc_time (icaltimezone   *zone,
                     struct icaltimetype    *tt,
                     int        *is_daylight);
%ignore icaltime_start_doy_of_week(const struct icaltimetype t);
%ignore icalcomponent_get_span(icalcomponent* comp);
%ignore icalproperty_remove_parameter(icalproperty* prop, icalparameter_kind kind);

#ifndef _DLOPEN_TEST
%ignore icalset_register_class(icalset *set);
#endif


//#include "fcntl.h" /* For Open flags */
%include "libical/ical.h"
%include "libicalss/icalss.h"

%inline %{
/* declare some internal functions which are not in the header file. */
void icalproperty_set_parent(icalproperty* property,
                 icalcomponent* component);
icalcomponent* icalproperty_get_parent(const icalproperty* property);

void icalvalue_set_parent(icalvalue* value,
                 icalproperty* property);
icalproperty* icalvalue_get_parent(icalvalue* value);

void icalparameter_set_parent(icalparameter* param,
                 icalproperty* property);
icalproperty* icalparameter_get_parent(icalparameter* value);

%}


%pythoncode %{

# Helper functions for overriding default swig property methods
def _swig_set_properties(cls, properties={}):
    for propname, props in properties.items():
        if len(props) > 0:
            cls.__swig_getmethods__[propname] = props[0]
        if len(props) > 1:
            cls.__swig_setmethods__[propname] = props[1]
        # Currently not used by swig
        if len(props) > 2:
            cls.__swig_delmethods__[propname] = props[2]

        if _newclass:
            setattr(cls, propname, _swig_property(*props))

def _swig_remove_private_properties(cls, properties=tuple()):
    # By default remove all properties
    if not properties:
        props = cls.__swig_getmethods__.copy()
        props.update(cls.__swig_setmethods__)
        #props.update(cls.__swig_delmethods__)
        properties = props.keys()

    for propname in properties:
        if cls.__swig_getmethods__.has_key(propname):
            del cls.__swig_getmethods__[propname]
        if cls.__swig_setmethods__.has_key(propname):
            del cls.__swig_setmethods__[propname]
        # Currently not used by swig
        #if cls.__swig_delmethods__.has_key(propname):
        #    del cls.__swig_delmethods__[propname]

        if _newclass and hasattr(cls, propname):
            delattr(cls, propname)

import new
def _swig_add_instance_methods(klass, meth_dict={}):
    for methname, func in meth_dict.items():
        meth = new.instancemethod(func, None, klass)
        if not methname: methname = func.__name__
        func.__name__ = methname
        setattr(klass, methname, meth)
%}


%include "LibicalWrap_icaltimezone.i"
%include "LibicalWrap_icaltime.i"
