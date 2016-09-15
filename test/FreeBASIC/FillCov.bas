
#include "mod-CSV.bas"

declare sub MiDaFill(tba() as double, mida() as integer, tbfl() as double)
declare sub LdaM2Stp(lda0 as double, stp as integer, tba() as double, dfm2() as double)

Dim as double tt0
tt0 = Timer

'command line
print "command line: filename step [lda]"

Dim as string file_nm
file_nm = command(1)
 
'inputs
Dim as integer stp
'step of differences for time series
stp = CInt(command(2))

'optional input
Dim as double lda0
lda0 = CDbl(command(4))
if lda0 <= 0.0 or lda0 > 1.0 then lda0 = 1.0

print "param", file_nm, stp, lda0

'import data
dim as double tba(any, any)
dim as string tdat(any), thda(any, any)
dim as integer mida(any, any)

ImpCSV(file_nm, 2, tba(), tdat(), thda(), mida())

Dim as integer nblig, nbcol
nblig = UBound(tba, 1)
nbcol = UBound(tba, 2)

print "import", timer - tt0, nblig, nbcol

Dim as integer i, j

'output files tbfl, covm
ReDim as double covm(1 To nbcol, 1 To nbcol)

'forward filling
Dim as double tbfl(any, any)
MiDaFill(tba(), mida(), tbfl())

'calc moments on tbfl
Dim as double dfm2(any, any, any)
LdaM2Stp(lda0, stp, tbfl(), dfm2())

'covariance
For i = 1 To nbcol
	For j = 1 To nbcol
		covm(i, j) = dfm2(nblig, i, j)
	Next j
Next i

Erase dfm2

print "calc", timer - tt0

'output
Dim as string oup

'forward fill file
Open "OupFillFile.csv" For Output As #1
'headers
oup = "Date"
For j = 1 to nbcol
    oup = oup & "," & thda(1, j + 1) 
Next j
print #1, oup
For i = 1 To nblig
    oup = tdat(i)
	For j = 1 to nbcol
        oup = oup & "," & tbfl(i, j) 
    Next j
	print #1, oup	
Next i
Close #1

print "file", timer - tt0

'Output file
Open "OupFillCov.csv" For Output As #1
'headers
oup = tdat(nblig)
For j = 1 to nbcol
    oup = oup & "," & thda(1, j + 1) 
Next j
print #1, oup
For i = 1 To nbcol
    oup = thda(1, i + 1)
	For j = 1 to nbcol
        oup = oup & "," & covm(i, j) 
    Next j
	print #1, oup	
Next i
Close #1

print "end", timer - tt0

sleep 10000


Sub MiDaFill(tba() as double, mida() as integer, tbfl() as double)
'Missing data time series forward fill
'input tba, mida
'output tbfl

Dim as integer nblig, nbcol
Dim as integer i, j
nblig = UBound(mida, 1)
nbcol = UBound(mida, 2)

ReDim as double tbfl(1 to nblig, 1 to nbcol) 

Dim as integer i0, i1
For j = 1 To nbcol
	i1 = 1
	'initial missing data: backfill
	If mida(1, j) = 1 Then
		For i1 = 2 To nblig
			If mida(i1, j) = 0 Then
				For i = 1 To i1
					tbfl(i, j) = tba(i1, j)
				Next i
				Exit for
			End if
		Next i1
	End If
	'forward fill
	For i0 = i1 to nblig
		If mida(i0, j) = 1 Then
			tbfl(i0, j) = tba(i1, j)
		Else
			tbfl(i0, j) = tba(i0, j)
			i1 = i0
		End If
	Next i0
Next j

End Sub


Sub LdaM2Stp(lda0 as double, stp as integer, tba() as double, dfm2() as double)
'Second moments from differences on time series
'inputs lda0, tba, stp0
'outputs dfm1, dfm2
'lda0=1 equal weights

dim as integer nblig, nbcol, i, j, k
dim as double lda, temp

nblig = UBound(tba, 1)
nbcol = UBound(tba, 2)

redim as double dfm2(1 To nblig, 1 To nbcol, 1 To nbcol)

'exponentially weighted moving averages
'cross terms based on stp
lda = 0.0
For k = 1 + stp To nblig   'start at 1 + stp
    For j = 1 To nbcol
        For i = 1 To j
            temp = (tba(k, i) - tba(k - stp, i)) * (tba(k, j) - tba(k - stp, j))
            dfm2(k, i, j) = lda * dfm2(k - 1, i, j) + (1.0 - lda) * temp
            dfm2(k, j, i) = dfm2(k, i, j)
        Next i
    Next j
    'lda cap
    lda = 1.0 / (2.0 - lda)
    If lda > lda0 Then lda = lda0
Next k

End Sub

