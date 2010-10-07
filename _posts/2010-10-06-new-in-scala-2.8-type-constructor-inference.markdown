---
layout: default
layout-variant: article # justifies
title: What's new in Scala 2.8':' type constructor inference
categories: research
excerpt: Brush up your knowledge of type constructor polymorphism and learn about type constructor inference. These helped reduce code duplication and carve out a cleaner hierarchy for the new collection libraries. You'll better understand part of what makes the new collections tick and maybe your own code can benefit from them as well.
---

#Type Constructor Polymorphism
Scala has let you abstract over types that take type parameters, such as <code>List</code>, since type constructor polymorphism was introduced in version 2.6.
However, type constructor inference wasn't officially supported until 2.8. Even though our current approach to type constructor inference is fairly limited, it keeps the type constructors that are used in the collection library behind the scenes. It should be noted that Scala 2.8's refined algorithm for implicit search is essential in capturing in the top of the collections hierarchy what varies below it. This article first introduces type constructor polymorphism, illustrates why it is useful and points out some common pitfalls.


##Motivation
For lack of a fuzzier name, types that abstract over types that abstract over types are called "higher-kinded types", which simply means that generic types, type constructors, or polymorphic types (different names for the same beast) have the same "rights" as their monomorphic cousins, types without type parameters. The value-level analogue of a higher-kinded type is a function that abstracts over another function, such as `List[T]`'s method `def map[U](f: T => U): List[U]`. Such a method is a value that abstracts over a value that abstracts over a value. (More precisely, a method is automatically converted to a function, which is a value. A method itself is not a value.) Of course, a value that abstracts over a value is simply a function. In this terminology, a type constructor is a function from a type to a type, and a higher-kinded type is a type function that takes a type function as an argument. These are all examples of higher-order polymorphism, which is useful on values as well as types, and the latter kind can be understood by analogy to the former.

All this may seem unnecessarily complicated at first. Nevertheless, it is simply a product of uniformity and abstraction. Instead of limiting generic types and methods to first-order mechanisms, Scala's higher-order approach is more uniform in that types can be abstracted over, whether they take type parameters or not. In the same way, functions may take arguments that are again functions, which is clearly useful. In Java, though, making a type generic (i.e., introducing a type parameter) excludes it from being abstracted over (i.e., you can't define a type parameter that itself takes type parameters, nor can you apply a type parameter to type arguments). When it comes to abstracting over values, Java's (anonymous) classes are a relatively heavyweight way of passing a method-valued argument (such as a lightweight GUI event handler or a strategy to transform data) to a method.

When reading on, it may help to think about the value-level counterpart to understand higher-order type-level abstractions, which may seem somewhat baffling at first. In the following, we will sometimes replace "type" by "type constructor" in existing terminology to emphasise we are talking about the higher-order variant, without intending to exclude type constructors in other occurrences of "type". We will use "proper type" or "monomorphic type" when referring only to types without type parameters.


##Example
Concretely, consider the following class definition:

{% highlight scala %}
class List[X]
{% endhighlight %}

The generic class `List` corresponds to a type function `List`, which takes a type and returns the type of the lists that contain elements of that given type.

To abstract over type constructors such as `List`, we introduce the type constructor parameter `CC`, which is declared to take one type parameter, `x`.
The name of the type parameter is not relevant in this declaration, since it is never used.

{% highlight scala %}
class Traversable[CC[x], T] {
  def filter(p: T => Boolean): CC[T]
  def retain(p: T => Boolean): CC[T] = filter(!p(_))
}
{% endhighlight %}

In the body of `Traversable`, `CC` is in scope, just like its other type parameter, `T`. However, `x`'s scope is restricted to the declaration of `CC`.
Referring to `x` outside of the `CC`'s declaration would be like the implementation of `map` above referring to the argument of its argument `f`.
Indeed, `map`'s signature does not even name the argument of the function `f`.

The syntax for type constructor parameters lets you name higher-order type parameters because they are required in common use cases. In the actual collection library, `Traversable` shields the user from type constructor polymorphism, but the class that is actually used for code-reuse, [`GenericTraversableTemplate`](http://lampsvn.epfl.ch/trac/scala/browser/scala/tags/R_2_8_0_final/src/library/scala/collection/generic/GenericTraversableTemplate.scala), restricts `CC` to type constructors that, when applied to a type argument (call it `X`), are a subclass of `Traversable[X]`. The syntax for this declaration is: `CC[X] <: Traversable[X]`. More details can be found in [Generics of a Higher Kind](https://lirias.kuleuven.be/bitstream/123456789/186940/4/tcpoly.pdf).

The result type of `filter` applies `CC` to a type argument `T`.
It would be an error to specify `CC` as the type of `filter`'s result, as only proper types, which do not expect any (further) type arguments, have values.
This is related to the fact that a generic class must be applied to all its type arguments before it can be instantiated (the type arguments may be inferred, of course).

So, this abstraction lets us capture exactly what varies (and not more), so that we don't have to repeat the bits that stay the same in concrete variations of the abstraction. Whenever the type that varies takes type parameters, you need type constructor polymorphism. In our collections example, the following subclasses exploit the regularity we discussed above and specifies only what varies for `List` and `Set`:

{% highlight scala %}
class List[T] extends Traversable[List, T]
class Set[T] extends Traversable[Set, T]
{% endhighlight %}

Without the `CC` abstraction, result type consistency can only be achieved by manually changing filter's result type and copy/pasting the implementation of retain (whose result type could be inferred in subclasses, but the code is still scattered all over the hierarchy, luring in the bit rot vultures). Note that self types do not solve this problem in general, as they are too rigid for methods like `map`. As it turns out, type constructor polymorphism is still too regular for the full collection library. They exhibit a more subtle kind of regularity, which is captured by ad-hoc polymorphism. In Scala, this is provided by implicits. All this is discussed in detail in [Fighting Bit Rot with Types](http://lampwww.epfl.ch/~odersky/papers/fsttcs09.html) and [Type Classes as Objects and Implicits](http://infoscience.epfl.ch/record/150280/files/TypeClasses.pdf).

##Type Constructor Inference
Scala uses local type inference to determine type arguments that were not specified explicitly by the programmer.
For each expression that requires type arguments, the compiler collects the constraints that are required for the expression to type check. This is done by replacing the unknown type parameters by type variables and tracking the subtyping constraints that are required for this expression to type check.
If there is a most general solution to these constraints, it yields the required type arguments.

A type argument list is either supplied or omitted completely -- Scala does not support partial type application or partial type inference. 
This means that, as soon as type inference fails for one of the type arguments, the whole list must be supplied by the programmer.
With the introduction of Scala 2.8's revamped collection library, type constructors began to appear in (the implicits required by) ordinary Scala code, so that failure to infer argument lists that contain type constructors became a more pressing issue. 

Thus, type inference has been extended to infer type constructor arguments. Technically, this means that type inference variables can now be constrained to taking a certain number of type arguments, and every type application of a type constructor variable to arguments tracks its own constraints.

You can see the result of type inference by passing the `-Xprint:typer` option to `scalac`, which prints the program after type checking (and inference).

As an example, consider the following interaction with the Scala REPL:

{% highlight scala %}
scala> def foo[CC[x], El](xs: CC[El]): CC[El] = null.asInstanceOf[CC[El]]
foo: [CC[x],El](xs: CC[El])CC[El]

scala> foo(List(1,2,3))
res0: List[Int] = null
{% endhighlight %}

The inferred type for `res0` shows that `foo`'s type arguments have been inferred as `[List, Int]`, so that `CC[El]` becomes `List[Int]`. Of course, `List` is the type constructor argument that could not be inferred by older versions of `scalac`. Note that the type for `foo` is a type that cannot be expressed in Scala programs. The type `[CC[x],El](xs: CC[El])CC[El]` is is used internally to represent a type function that takes two types -- abstracted over by `CC` and `El` -- and returns the type of a method with one argument list `(xs: CC[El])` and result type `CC[El]`

##Common Pitfalls
Often, only the number of higher-order type parameters is important. In that case, you can save some creative energy to come up with different names for them and use an underscore instead.
Thus, we could have written `class Traversable[CC[_], T]` instead, above. However, perhaps surprisingly, `CC[_] <: Traversable[_]` is **not** equivalent to `CC[X] <: Traversable[X]`. The former expands to `CC[X] <: Traversable[T] forSome {type T}`, where `T` is existentially bound and thus unrelated to `X`.

##What others have been doing
People have been doing some pretty interesting things with type constructor polymorphism and type-level computation in general.

* [Type-safe incremental initialisation](http://jim-mcbeath.blogspot.com/2009/09/type-safe-builder-in-scala-part-3.html)
* [Type-level computation](http://apocalisp.wordpress.com/2010/06/08/type-level-programming-in-scala/)
* [Type-level encoding of the SKI calculus](http://michid.wordpress.com/2010/01/29/scala-type-level-encoding-of-the-ski-calculus/igh)