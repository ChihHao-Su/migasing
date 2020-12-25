#pragma once
#include <string>
#include <string_view>
#include <vector>
#include "IreflectEle.hpp"
#include "cls.hpp"
#include "funcTraits.hpp"
#include "isCallable.hpp"

class IFunc : public IReflectEle
{
    virtual std::vector<ICls*> getParamClass() = 0;
};

/*
template <FUNC F>
IFunc& genIFuncImplByType(){
    class Func : public IFunc
    {
    public:
        using FUNC_TAIT = sqlite::utility::function_traits<F>;
        std::vector<ICls*> getParamClass(){
            return std::apply([](auto&&... args){
               return {genIClsImplByType<args> ...}; 
            }, FUNC_TAIT::argumentList);
        }
    } func;
    return func;
}*/