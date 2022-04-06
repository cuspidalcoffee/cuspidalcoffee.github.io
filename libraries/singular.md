# Singular libraries
## `frontals.lib`
Compute invariants of frontal hypersurfaces. [Download it here!][frontals_singular]
**Note**: Requires [`presmatrix.lib`][presmatrix].

### Procedures:
* `invariants(map f)`
    * Number of swallowtails, cusp-folds, triple points and folded Whitney umbrellas in the frontal disentanglement of `f`.
	* Cuspidal edge and double point sets of `f`, along with their Milnor numbers.
    * Frontal Milnor number of `f`.
* `is_frontal(map f)`
    * Check if `f` is frontal, using a procedure described by [G. Ishikawa][frontals_survey].
* `wfinvariants(g, z)`
    * Number of swallowtails, cusp-folds and triple points in the discriminant of the map `G(x,y,z)=(x,y,g(x,y,z))`, using a Theorem by [W.L. Marar, J. Montaldi and M.A.S. Ruas][zeroschemes].

---
**Tip**:
You can use [curl](https://curl.se/) to download these libraries.
Simply type `curl <link> --output <libname>` on your terminal of choice.

<!-- Code -->
[frontals_singular]: https://raw.githubusercontent.com/cuspidalcoffee/cuspidalcoffee.github.io/main/libraries/frontals.lib
[presmatrix]: https://sites.google.com/site/aldicio/publicacoes/presentation-matrix-algorithm

<!-- References -->
[frontals_survey]: https://arxiv.org/abs/1808.09594
[zeroschemes]: https://www.researchgate.net/publication/2821582_Multiplicities_of_Zero-Schemes_in_Quasihomogeneous_Corank-1_Singularities
