#pragma once

// Note that std::is_function says that pointers to functions
// and references to functions aren't functions, so we'll make our 
// own is_function_t that pulls off any pointer/reference first.

template<typename T>
using remove_ref_t = typename std::remove_reference<T>::type;

template<typename T>
using remove_refptr_t = typename std::remove_pointer<remove_ref_t<T>>::type;

template<typename T>
using is_function_t = typename std::is_function<remove_refptr_t<T>>::type;

// We can't use std::conditional because it (apparently) must determine
// the types of both arms of the condition, so we do it directly.

// Non-objects are callable only if they are functions.

template<bool isObject, typename T>
struct is_callable_impl : public is_function_t<T> {};

// Objects are callable if they have an operator().  We use a method check
// to find out.

template<typename T>
struct is_callable_impl<true, T> {
private:
    struct Fallback { void operator()(); };
    struct Derived : T, Fallback { };

    template<typename U, U> struct Check;

    template<typename>
    static std::true_type test(...);

    template<typename C>
    static std::false_type test(Check<void (Fallback::*)(), &C::operator()>*);

public:
    typedef decltype(test<Derived>(nullptr)) type;
};


// Now we have our final version of is_callable_t.  Again, we have to take
// care with references because std::is_class says "No" if we give it a
// reference to a class.

template<typename T>
using is_callable_t = 
    typename is_callable_impl<std::is_class<remove_ref_t<T>>::value,
                              remove_ref_t<T> >::type;

//template <typename T>
//concept FUNC = is_callable_t<T>;