module keys;

import c.gl.glfw;

private struct KeyBinding
{
    uint action;
    uint key;
}

struct Keys
{
    enum
    {
        GAME_PAUSE = 0,
        GAME_SELECT,
        GAME_CANCEL,
        GAME_UP,
        GAME_DOWN,
        GAME_LEFT,
        GAME_RIGHT,

        ACTOR_IDLE,
        ACTOR_MOVE_UP,
        ACTOR_MOVE_DOWN,
        ACTOR_MOVE_LEFT,
        ACTOR_MOVE_RIGHT,
        ACTOR_JUMP,
        ACTOR_MAIN_ATTACK,
        ACTOR_SECONDARY_ATTACK,
        ATOR_DRINK_POTION,
        ACTOR_NEXT_ITEM,
        ACTOR_PREV_ITEM,

        LAST_ACTION,
    }

    KeyBinding[] bindings = [
        {GAME_PAUSE, GLFW_KEY_ESC},
        {GAME_SELECT, GLFW_KEY_ENTER},

        {GAME_CANCEL, GLFW_KEY_ESC},
        {GAME_UP, GLFW_KEY_UP},
        {GAME_DOWN, GLFW_KEY_DOWN},
        {GAME_LEFT, GLFW_KEY_LEFT},
        {GAME_RIGHT, GLFW_KEY_RIGHT},

        {ACTOR_IDLE, 0},
        {ACTOR_MOVE_UP, 'W'},
        {ACTOR_MOVE_DOWN, 'S'},
        {ACTOR_MOVE_LEFT, 'A'},
        {ACTOR_MOVE_RIGHT, 'D'},
        {ACTOR_JUMP, 0},
        {ACTOR_MAIN_ATTACK, 'J'},
        {ACTOR_SECONDARY_ATTACK, 'G'},
        {ATOR_DRINK_POTION, 0},
        {ACTOR_NEXT_ITEM, 0},
        {ACTOR_PREV_ITEM, 0},
    ];

    bool isPressed(int action)
    {
        return false; 
    }

    uint getKeyBinding(uint action)
    {
        return bindings[action].key;
    }

    void setKeyBinding(uint action, uint key)
    {
        bindings[action].key = key;
    }

    bool isActive(int action)
    {
        return action <= GAME_RIGHT && glfwGetKey(getKeyBinding(action)); 
    }
}
