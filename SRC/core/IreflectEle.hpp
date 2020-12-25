#pragma once
#include <string_view>

class IReflectEle
{
public:
    virtual std::string_view getName() = 0;
};
