/*
 * Read a file using RSL and spit out some basic info
 *
 */

#define USE_RSL_VARS
#include "rsl.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ABS(x) (x > 0 ? x : -x)

void usage(char **argv)
{
    fprintf(stderr, "Usage: %s <filename> <station>\n", argv[0]);
    exit(1);
}

int main(int argc, char **argv)
{
    if (argc != 3) usage(argv);
    
    char *infile = argv[1];
    char *station = argv[2];

    Radar *radar;

    //RSL_select_fields("all", NULL);
    //RSL_read_these_sweeps("0", NULL);

    radar = RSL_wsr88d_to_radar(infile, station);
    //radar = RSL_anyformat_to_radar(infile, station);
    if (radar == NULL) 
    {
	fprintf(stderr, "Failed to read radar file");
	exit(2);
    }

    Volume *dz;
    if (radar->h.nvolumes > DZ_INDEX && radar->v[DZ_INDEX]) 
    {
	dz = radar->v[DZ_INDEX];
    }
    else
    {
	fprintf(stderr, "Error: no volumes\n");
	exit(3);
    }

    Sweep *sweep = RSL_get_first_sweep_of_volume(dz);
    
    Ray *ray;
    if (sweep->h.nrays > 0)
    {
	ray = sweep->ray[0];
    }
    else
    {
	fprintf(stderr, "Error: no rays\n");
	exit(4);
    }

    printf("      Station: %s\n", radar->h.radar_name);
    printf("     Location: %s, %s\n", radar->h.city, radar->h.state);
    printf("     Latitude: %+dd %dm %ds\n", radar->h.latd, radar->h.latm, radar->h.lats);
    printf("    Longitude: %+dd %dm %ds\n", radar->h.lond, ABS(radar->h.lonm), ABS(radar->h.lons));
    printf("       Height: %d\n", radar->h.height);
    printf("         Date: %04d-%02d-%02d\n", radar->h.year, radar->h.month, radar->h.day);
    printf("    Scan time: %02d:%02d:%02d\n", radar->h.hour, radar->h.minute, (int) radar->h.sec);
    printf("          vcp: %d\n", radar->h.vcp);
    printf("       spulse: %d\n", radar->h.spulse);
    printf("       lpulse: %d\n", radar->h.lpulse);
    printf("DZ beam width: %.2f\n", sweep->h.beam_width);
    printf(" DZ gate size: %d\n", ray->h.gate_size);
    printf("       DZ prf: %d\n", ray->h.prf);

    RSL_free_radar(radar);
    exit(0);
  
}
