#include "core/module.hpp"
#include <iostream>
#include <string_view>

void showText(std::string_view text){

}

extern "C"{
    Module& getModuleStruct(){
        using std::cout; using std::cin;
        static class Ui : public Module
        {
            void onInit(){
                cout << "uimodule init." << '\n';
            }
            void onDeload(){
                cout << "uimodule deload." << '\n';
            }
            std::string_view getName(){
                return "ui";
            }
            std::any invokeDyn(std::vector<std::any> paraList){
                return nullptr;
            }
        } moduleStruct;
        return moduleStruct;
    }
}