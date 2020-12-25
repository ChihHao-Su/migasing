#include "core/system.hpp"
#include "def.h"
#ifdef WIN32
    #include <windows.h>
#endif

void System::loadModule(std::string_view plugPath){
    #ifdef WIN32
        HMODULE hmodule = LoadLibrary(plugPath.data());
        if(!hmodule){
            throw std::exception("LOAD DLL FAILED!");
        }
        Module::TgetModuleStructFunc func = reinterpret_cast<Module::TgetModuleStructFunc>(GetProcAddress(hmodule, "getModuleStruct"));
        if(!func){
            throw std::exception("NOT MODULE DLL!");
        }
        regModule(func());

    #else
        throw std::exception("NOT IMPLED!");
    #endif
}
void System::removeModule(std::string_view modName){
    auto it = std::find_if(RANGEOF(modList), [modName](auto mod){return mod->getName() == modName;});
    modList.erase(it);
}
void System::regModule(Module& mod){
    modList.push_back(&mod);
    mod.onInit();
}
Module& System::getModuleByName(std::string_view modName){
    auto it = std::find_if(RANGEOF(modList), [modName](auto mod){return mod->getName() == modName;});
    return **it;
}