#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "io.h"

void splitstr(char *line, double *tba_l, bool *mida_l, int *nco);

int impcsv
(
	char *filename, int flig, int *nli, int *nco,
	double tba[][NCO_MAX], bool mida[][NCO_MAX]
)
{
	int i;
	
	FILE *f;
    char *line = NULL; // the line
    size_t len = 0;
    ssize_t read; // length of the line just read, or -1 if no line is there

	printf("Reading CSV file: %s...\n", filename);
	
    f = fopen(filename, "r");
    
    if (f == NULL)
    {
    	printf("*** ERROR. Cannot open file: %s\n", filename);
    	return 1; // failure
    }
    
    *nli = 0;
    
	for (i = 0; ; ++i)
	{
		read = getline(&line, &len, f);
		
		if (read == -1)
			break;
		
		if (i < flig)
			continue;
		
		if (*nli >= NLI_MAX)
			break;
		
		splitstr(line, tba[*nli], mida[*nli], nco);

		++*nli;
	}
	
	printf("Lines read: %d\n", *nli);
	printf("Columns read: %d\n", *nco);

    fclose(f);
    
    if (line)
        free(line);

	return 0; // success
}

void splitstr(char *line, double *tba_l, bool *mida_l, int *nco) {

	int offset = 0;	
	char *end;
	int i;
	
	*nco = 0;
	
    for (i = 0; ; ++i) 
	{
		end = strpbrk(line, ",");
    
		if (end != NULL)
			*end = 0; // replace the comma with an end of line!

        double d = atof(line);
		
		// Skip the first column
		if (i > 0 && *nco < NCO_MAX)
    	{    	 	
     		tba_l[*nco] = d;
     	
     		mida_l[*nco] = false;
     		
     		if (d == 0.0 && line[0] != 48)
     			mida_l[*nco] = true;

	     	++*nco;
	    }
    
		if (end == NULL)
			break;
		else
			line = end + 1;
    }
} 

int expcsv
(
	char *filename, int nli, int nco,
	double tba[][NCO_MAX], bool mida[][NCO_MAX]
)
{
	FILE *f;

	printf("Writing CSV file: %s...\n", filename);
	
    f = fopen(filename, "w");
    
    if (f == NULL)
    {
    	printf("*** ERROR. Cannot create file: %s\n", filename);
    	return 1; // failure
    }
    
    int i, j;
    
	for (j = 0; j < nli; ++j)
	{
		for (i = 0; i < nco; ++i)
		{
			if (i > 0)
				fprintf(f, ",");
			
			if (mida[j][i])
				fprintf(f, "N/A");
			else
				fprintf(f, "%f", tba[j][i]);
		}
		
		fprintf(f, "\n");	
	}

    fclose(f);

	return 0; // success
}
