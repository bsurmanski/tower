/**
 * lua.lib.all.d
 * tower
 * April 29, 2013
 * Brandon Surmanski
 */

module lua.lib.all;
import lua.api;
import lua.lib.libentity;
import lua.lib.libactor;
import lua.lib.libitem;
import lua.lib.libmodel;
import lua.lib.libkey;
import lua.lib.libvector;

static immutable(Api)[] luaApis = [
    libentity,
    libactor,
    libitem,
    libmodel,
    libkey,
    libvector,
];


