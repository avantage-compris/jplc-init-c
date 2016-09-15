// NLI_MAX: Maximum number of lines that can be imported from a CSV file
#define NLI_MAX 3000
// NCO_MAX: Maximum number of columns that can be imported from a CSV file
#define NCO_MAX 200

typedef int bool;
#define true 1
#define false 0

/**
 *	import a CSV file into an 2D array of doubles
 *
 *	@param filename the name of the CSV file to import, e.g. "test/csv/UKOutput.csv"
 *	@param flig the number of header rows in the CSV file, e.g. 1
 *  @param nli the number of data lines in the CSV file, e.g. 3000
 *  @param nco the number of data columns in the CSV file, e.g. 15
 *  @param tba the 2D array of doubles to fill with values
 *  @param mida the 2D array of booleans to fill with "Missing Data" flags
 *	@return 0 if success
 */
int impcsv
(
	char *filename, int flig, int *nli, int *nco,
	double tba[][NCO_MAX], bool mida[][NCO_MAX]
);

/**
 *	export an 2D array of doubles into a CSV file
 *
 *	@param filename the name of the CSV file to export, e.g. "target/output.csv"
 *  @param nli the number of data lines in the CSV file, e.g. 3000
 *  @param nco the number of data columns in the CSV file, e.g. 15
 *  @param tba the 2D array of doubles
 *  @param mida the 2D array of booleans that contain the "Missing Data" flags
 *	@return 0 if success
 */
int expcsv
(
	char *filename, int nli, int nco,
	double tba[][NCO_MAX], bool mida[][NCO_MAX]
);