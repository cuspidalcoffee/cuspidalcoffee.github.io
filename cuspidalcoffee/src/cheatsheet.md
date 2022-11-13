# Julia cheatsheet

[Useful references](#refs) / [Miscellaneous](#misc) / [Writing functions](#functions) 
/ [Array manipulation](#array) / [References](#bib)

### <a id="refs">Useful references</a>
* [Style Guide: Recommended practices from the developer team](https://docs.julialang.org/en/v1/manual/style-guide/#Style-Guide)
* [Variables and naming conventions](https://docs.julialang.org/en/v1/manual/variables/#man-variables)

### <a id="misc">Miscellaneous</a>
Open notebook:
```
]using IJulia
notebook()
```

Packages:
```
]add Module 	# install modules
]up 			# update modules
]using Module 	# enable modules
```

Creating packages:
```
]generate ModuleName 	# Initialise

;cd path/to/module/folder
]activate . 			# Enable module
```

### <a id="functions">Writing functions</a>
Function syntax:
```
	# Named
julia> function f(x,y)
           x + y
       end
f (generic function with 1 method)

	# Anonymous ("lambda")
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

	# Short-circuiting
x == y && println("x is equal to y") || println("x is not equal to y")

	# Ternary operator
x == y ? println("x is equal to y") : println("x is not equal to y")
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

### <a id="array">Array manipulation</a>
Declaration:
```
julia> 1:8 			# UnitRange
julia> 1, 4, 6		# Tuple
julia> [1 2; 3 4]	# Array
```

Measuring:
```
julia> length([1 3; 6 9])
4

julia> size([1 3; 6 9])
(2, 2)

julia> size([1 3])
(1, 2)
```

Broadcasting ("maps"):
```
julia> div.([5 10],5)
1×2 Matrix{Int64}:
 1  2
```

### <a id="bib">References</a>
* [Julia documentation](https://docs.julialang.org/en/v1/)
