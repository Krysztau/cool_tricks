## escape characters:
##	\n	newline (LF = line feed, Mac OS, Unix)
##	\r	carriage return (CR, Mac OS before X	 \r\n is for Windows
##	\t	tab
##	\b	backspace
##	\a	alert (bell)
##	\f	form feed
##	\v	vertical tab
##	\\	backslash \
##	\'	ASCII apostrophe '
##	\"	ASCII quotation mark "
##	\`	ASCII grave accent (backtick) `
##	\nnn	character with given octal code (1, 2 or 3 digits)
##	\xnn	character with given hex code (1 or 2 hex digits)
##	\unnnn	Unicode character with given code (1--4 hex digits)
##	\Unnnnnnnn	Unicode character with given code (1--8 hex digits)




var_OldStrings <- c("WHEN prev_month.PACKAGE_NAME = 'WEST AFRICAN ENGLISH TV + MOVIES' THEN 'TV and Movies Pack'\r\n",
		    "WHEN prev_month.PACKAGE_NAME = 'WEST AFRICAN ENGLISH MOVIES' THEN 'Movies Pack'\r\n"
		    )    ##values to be replaced
var_NewStrings <- c("WHEN prev_month.PACKAGE_NAME = 'WEST AFRICAN ENGLISH TV + MOVIES' THEN 'TV and Movies Pack'\r\nWHEN prev_month.PACKAGE_NAME = 'NOLLYWOOD TV + MOVIES' THEN 'TV and Movies Pack'\r\n",
		    "WHEN prev_month.PACKAGE_NAME = 'WEST AFRICAN ENGLISH MOVIES' THEN 'Movies Pack'\r\n"
		    )    ##new values


files <- c("1st_to_2nd_current_month_minus1-by_device", "1st_to_2nd_current_month_minus2-by_device"
, "1st_to_2nd_current_month_minus3-by_device", "1st_to_2nd_current_month_minus4-by_device"
, "1st_to_2nd_current_month_minus5-by_device", "1st_to_2nd_current_month_minus6-by_device"
, "2nd_to_3rd_current_month_minus1-by_device", "2nd_to_3rd_current_month_minus2-by_device"
, "2nd_to_3rd_current_month_minus3-by_device", "2nd_to_3rd_current_month_minus4-by_device"
, "2nd_to_3rd_current_month_minus5-by_device", "2nd_to_3rd_current_month_minus6-by_device")



for (j in files) {
	



##load text into R
var_file <- readChar(j,nchars=600000)

##replace substrings
for(i in 1: length(var_OldStrings))
{
	var_file <- gsub(var_OldStrings[i], var_NewStrings[i], var_file, fixed=TRUE)
}
##save to .txt
##    !!!WARNING!!! 
##  No backup file is created!!!
writeChar(var_file, j)
##writeLines(var_file, j)	This is an old line. I didn't test it with writeChar() function
}
