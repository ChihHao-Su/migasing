#pragma once
#include <vector>
#include <string_view>
#include <any>
#include "core_export.h"
#include "core/Module.hpp"

class CORE_EXPORT System
{
public:
    void loadModule(std::string_view modPath);
    void removeModule(std::string_view modName);
    void regModule(Module& mod);
    std::any invokeDyn(std::vector<std::any> paraList);
    Module& getModuleByName(std::string_view modName);

private:
    std::vector<Module*> modList;
};