/**
 * gpuResource.d
 * tower
 * June 03, 2013
 * Brandon Surmanski
 */

module scene.resource.gpuResource;

import c.gl.gl;
import scene.resource.resource;

abstract class GpuResource : Resource
{
    GLuint buffer;
}
