#pragma once
#include <string_view>
#include <typeinfo>
#include "IreflectEle.hpp"

class ICls : public IReflectEle
{
public:
};

template <typename T>
ICls& genIClsImplByType(){
    class Cls : public ICls
    {
    public:
        std::type_info cppTypeInfo = typeid(T);
        std::string_view getName() override{
            return cppTypeInfo.name();
        }
    } cls;
    return cls;
}