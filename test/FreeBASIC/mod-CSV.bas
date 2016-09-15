declare sub ImpCSV(file_name as string, flig as integer, tba() as double, tdat() as string, thda() as string, mida() as integer)
declare sub Repcomma(itxt as string, ouptxt as string)

Sub ImpCSV(file_name as string, flig as integer, tba() as double, tdat() as string, thda() as string, mida() as integer)
'import CSV file to an array
'inputs filename, flig
'ouputs tba, tdat, thda, mida

dim as string s

'count lines
dim as integer nli
nli=0
open file_name for input as #1
	do until eof(1)
		nli = nli+1
		line input #1, s
	loop
close #1

'count columns
dim as integer nco
nco = 1
do while instr(s, ",") > 0 
		nco = nco + 1
		s = right(s, len(s)-instr(s, ","))
loop

redim as double tba(1 to nli-flig+1, 1 to nco-1)
redim as integer mida(1 to nli-flig+1, 1 to nco-1)
redim as string tdat(1 to nli-flig+1)
redim as string thda(1 to flig-1, 1 to nco)

dim as integer i, j, i0, j0
open file_name for input as #1

for i0 = 1 to nli
	for j0 = 1 to nco
		
		input #1, s
		
		if i0 < flig then  
			thda(i0,j0) = s
		else
			i = i0-flig+1
			j = j0-1
			if j0 = 1 then
				tdat(i) = s
			else
				tba(i,j) = Cdbl(s)
				mida(i,j) = 0
				if tba(i,j) = 0.0 and Asc(Left(Trim(s),1)) <> 48 then 
					mida(i,j) = 1	'missing data
				end if
			end if
		end if
		
	next j0
next i0

close #1

End Sub


Sub Repcomma(itxt as string, ouptxt as string)
'replaces comma in strings for CSV

dim s as string
dim c as integer

ouptxt = itxt
For c = 1 to Len(itxt)
	If Mid(ouptxt, c, 1) = "," then
		s = Left(ouptxt, c-1) + "-" + Right(ouptxt, Len(itxt) - c)
		ouptxt = s
	end if
Next c

End Sub
