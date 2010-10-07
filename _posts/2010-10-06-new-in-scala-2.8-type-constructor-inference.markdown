---
layout: default
title: What's new in Scala 2.8':' type constructor inference
categories: unpublished
highlight: 'yes'
excerpt: Brush up your knowledge of type constructor polymorphism and learn about type constructor inference. These helped reduce code duplication and carve out a cleaner hierarchy for the new collection libraries. You'll better understand what makes the new collections tick and maybe your own code can benefit from them as well.
---
  
<!-- %% 17 september -->

#Type Constructor Polymorphism
Scala has let you abstract over types that take type parameters, such as <code>List</code>, since type constructor polymorphism was introduced in version 2.6.
However, type constructor inference wasn't officially supported until 2.8. Even though our current approach to type constructor inference is fairly limited, it keeps the type constructors that are used in the collection library behind the scenes. It should be noted that Scala 2.8's refined algorithm for implicit search, which is discussed in a separate article, is essential in capturing in the top of the collections hierarchy what varies below it. This article first introduces type constructor polymorphism, illustrates why it is useful and points out some common pitfalls. TODO: structure of second part -- type inference and lead to implicits

<!-- % what is type constructor polymorphism and what is it good for? -->

#Motivation
For lack of a fuzzier name, types that abstract over types that abstract over types are called "higher-kinded types", which simply means that generic types, type constructors, or polymorphic types (different names for the same beast) have the same "rights" as their monomorphic cousins, types without type parameters. The value-level analogue of a higher-kinded type is a function that abstracts over another function, such as `List[T]`'s method `def map[U](f: T => U): List[U]`. Such a method is\footnote{More precisely, a method is automatically converted to a function, which is a value. A method itself is not a value.} a value that abstracts over a value that abstracts over a value. Of course, a value that abstracts over a value is simply a function. In this terminology, a type constructor is a function from a type to a type, and a higher-kinded type is a type function that takes a type function as an argument. These are all examples of higher-order polymorphism, which is useful on values as well as types, and the latter kind can be understood by analogy to the former.

All this may seem unnecessarily complicated at first. Nevertheless, it is simply a product of uniformity and abstraction. Instead of limiting generic types and methods to first-order mechanisms, Scala's higher-order approach is more uniform in that types can be abstracted over, whether they take type parameters or not. In the same way, functions may take arguments that are again functions, which is clearly useful. In Java, though, making a type generic (i.e., introducing a type parameter) excludes it from being abstracted over (i.e., you can't define a type parameter that itself takes type parameters, nor can you apply a type parameter to type arguments). When it comes to abstracting over values, Java's (anonymous) classes are a relatively heavyweight way of passing a method-valued argument (such as a lightweight GUI event handler or a strategy to transform data) to a method.

When reading on, it may help to think about the value-level counterpart to understand higher-order type-level abstractions, which may seem somewhat baffling at first. In the following, we will sometimes replace "type" by "type constructor" in existing terminology to emphasise we are talking about the higher-order variant, without intending to exclude type constructors in other occurrences of "type". We will use "proper type" or "monorphic type" when referring only to types without type parameters.


#Example
<!-- % TODO: everything below: -->
Concretely, consider the following class definition:

    class List[X]

The generic class `List` corresponds to a type function `List`, which takes a type and returns the type of the lists that contain elements of that given type.

To abstract over type constructors such as `List`, we introduce the type constructor parameter `CC`, which is declared to take one type parameter, `x`.
The name of the type parameter is not relevant in this declaration, since it is never used.

    class Traversable[CC[x], T] {
      def filter(p: T => Boolean): CC[T]
      def retain(p: T => Boolean): CC[T] = filter(!p(_))
    }

In the body of `Traversable`, `CC` is in scope, just like its other type parameter, `T`; `x`'s scope is restricted to the declaration of `CC`.
The result type of `filter` applies `CC` to a type argument `T`.
It would be an error to specify `CC` as the type of `filter`'s result, only proper types, which do not expect any (further) type arguments, have values.
This is related to the fact that a generic class must be applied to all its type arguments before it can be instantiated (the type arguments may be inferred, of course).


    class List[T] extends Traversable[List, T]
    class Set[T] extends Traversable[Set, T]



Without the `CC` abstraction, result type consistency can only be achieved by manually changing filter's result type and copy/pasting the implementation of retain (whose result type could be inferred in subclasses, but the code is still scattered all over the hierarchy, luring in the bit rot vultures).

For the usual kind of regularity, type constructor polymorphism (higher-order parametric polymorphism) works well. The full collection library exhibits a more subtle kind of regularity, which requires ad-hoc polymorphism.

<!-- % advanced topics -->
Type Inference

<!-- % use in collection library, implicit search supplies the ad-hoc polymorphism, while type constructor polymorphism aids in scrapping boilerplate that involves generic types -->

<!-- %% inference:  -->
Since Scala does not support partial type application or partial type inference, as soon as a type constructor was expected by a polymorphic method or class, the full list of type arguments had to be supplied explicitly.
With the introduction of Scala 2.8's revamped collection library, type constructors began to appear in ordinary Scala code, so that failure to infer argument lists that contain type constructors became a more pressing issue. 

<!-- % syntax of types, scope of higher-order type parameters, conceptual syntax of kinds
% kind inference
% kind conformance

% common pitfalls
% CC[_] <: Traversable[_] -->

