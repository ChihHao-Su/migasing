#pragma once
#include <any>
#include <vector>
#include <string_view>
#include "core_export.h"


class CORE_EXPORT Module{
public:
    using TgetModuleStructFunc = Module& (*)();
    virtual void onInit() = 0;
    virtual void onDeload() = 0;
    virtual std::string_view getName() = 0;
    virtual std::any invokeDyn(std::vector<std::any> paraList) = 0;

};