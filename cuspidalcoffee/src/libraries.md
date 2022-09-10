# Libraries

A collection of libraries written in order to facilitate mathematical computations.

## `frontals.lib` (Singular)

Compute invariants of frontal hypersurfaces.
[Download it here!][frontals.lib]

**Note:** Requires
[presmatrix.lib](https://sites.google.com/site/aldicio/publicacoes/presentation-matrix-algorithm).

### Procedures

* `invariants(map f)`
	* Number of swallowtails, cuspidal double points, triple points and folded
	Whitney umbrellas in the frontal disentanglement of `f`.
	* Cuspidal edge and double point sets of `f`, along with their Milnor numbers.
	* Frontal Milnor number of `f`.
        
* `is_frontal(map f)`
	* Check if f is frontal, using
	[a procedure by G. Ishikawa](https://arxiv.org/abs/1808.09594).
    
* `wfinvariants(poly g, z)`
	* Number of swallowtails, cuspidal double points and triple points in the
	discriminant of the map `G(x,y,z)=(x, y, g(x,y,z))`, using
	[a Theorem by W.L. Marar, J. Montaldi and M.A.S. Ruas](https://www.researchgate.net/publication/2821582_Multiplicities_of_Zero-Schemes_in_Quasihomogeneous_Corank-1_Singularities).

---

You can use [cURL](https://curl.se/) to download these libraries!
Simply type `curl <link> --output <libname>` on your terminal of choice. 
