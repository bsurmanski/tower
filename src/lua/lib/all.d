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

static Api[] luaApis = [
    libentity,
    libactor,
    libitem,
];


