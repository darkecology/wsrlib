#define USE_RSL_VARS
#include <stdio.h>
#include <stdlib.h>
#include "rsl.h"

/**********************************************************************/
/*                                                                    */
/*                    RSL_sweep_to_cart_double                        */
/*                                                                    */
/*  Originally RSL_sweep_to_cart by:                                  */
/*      John Merritt                                                  */
/*      Space Applications Corporation                                */
/*      April 7, 1994                                                 */
/*                                                                    */
/*  Modifed by                                                        */
/*      Dan Sheldon                                                   */
/*      Oregon State University                                       */
/*      August 17, 2010                                               */
/**********************************************************************/
int RSL_sweep_to_cart_double(Sweep *s, int xdim, int ydim, float range, double *data)
{
    /* Range specifies the maximum range to load that points into the image. */

    int x, y;
    float azim, r;
    float val;
    int the_index;
    Ray *ray;
    float beam_width;
    float slantr, h;

    float *cart_image = NULL;

    if (s == NULL) return 0;
    if (xdim != ydim || ydim < 0 || xdim < 0) {
	fprintf(stderr, "(xdim=%d) != (ydim=%d) or either negative.\n", xdim, ydim);
	return 0;
    }
  
    beam_width = s->h.beam_width/2.0 * 1.2;
    if (beam_width == 0) beam_width = 1.2;  /* Sane image generation. */

    /* Traverse in column-major order (MATLAB!) */
    for (x=-xdim/2; x<xdim/2; x++) {
	for (y=ydim/2; y>-ydim/2; y--) {
	    
	    RSL_find_rng_azm(&r, &azim, x, y);

	    if (ydim < xdim) r *= range/(.5*ydim);
	    else r *= range/(.5*xdim);
	    if (r > range) val = BADVAL;

	    else {
		ray = RSL_get_closest_ray_from_sweep(s, azim, beam_width);
		RSL_get_slantr_and_h(r, s->h.elev, &slantr, &h);
		val = RSL_get_value_from_ray(ray, slantr);
	    }
	    *data = val;
	    data++;
	}
    }
    return 1;
}
