# Julia cheatsheet

### Useful references
* [Style Guide: Recommended practices from the developer team](https://docs.julialang.org/en/v1/manual/style-guide/#Style-Guide)
* [Variables and naming conventions](https://docs.julialang.org/en/v1/manual/variables/#man-variables)

## Writing functions

Function syntax:
```
julia> function f(x,y)
           x + y
       end
f (generic function with 1 method)

julia> x -> x^2 + 2x - 1
#1 (generic function with 1 method)
```

If-else statements:
```
if x < y
    println("x is less than y")
elseif x > y
    println("x is greater than y")
else
    println("x is equal to y")
end
```

Loops:
```
julia> for i = 1:5
           println(i)
       end

julia> while i <= 5
           println(i)
           global i += 1
       end
```

## References
* [Julia documentation](https://docs.julialang.org/en/v1/)
* [AbstractAlgebra documentation]()
* [Oscar documentation]()
