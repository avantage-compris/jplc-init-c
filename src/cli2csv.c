#include <stdio.h>
#include "io.h"

int main(int argc, char **argv)
{
	if (argc < 2)
	{
		printf("*** ERROR. Usage: cli2csv.exe <filename.csv>\n");
		
		return 1;
	}
	
	char *filename; // CSV input filename, e.g. "test/csv/UKOutput.csv"
	
	filename = argv[1];
	
	printf("filename: %s\n", filename);
	
	int imp; // 0 if we succeeded in importing the CSV input file
	int nli; // the total number of lines in the CSV file, e.g. 30001
	int nco; // the total number of columns in the CSV file, e.g. 15
	double tba[NLI_MAX][NCO_MAX]; // values
	bool mida[NLI_MAX][NCO_MAX]; // Missing data flags (true/false)
	
	imp = impcsv(filename, 1, &nli, &nco, tba, mida);

	if (imp)
		return imp; // failure
		
	tba[3][8] = 459182;
	
	expcsv("target/output.csv", nli, nco, tba, mida);
			
	return 0; // success
}