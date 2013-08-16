module game.resource.d;

import std.stdio;

abstract class Resource
{
    //TODO visitor pattern thing? Or, Factory?
    enum Type
    {
        Mesh,
        Image,
        Sound,
        Text,
        Camera,
        Lamp,
        Model, 
    }

    Type type;

    static Resource load(string filenm)
    {
        File file = File(filenm, "r");
        Resource r = Resource.load(file);
        file.close();
        return r;
    }

    static Resource load(File file)
    {
        return null; 
    }
}
