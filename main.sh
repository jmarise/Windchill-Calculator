#!/bin/bash

# Call getopt to validate the provided input. 
option=$(getopt -o chqv --long airtemp:,cout,cin,file:,help,quiet,version,velocity:  -- "$@")


usage="
Wind-Chill Calculator

Usage: windchill --airtemp=<temp> --velocity=<speed> [-c | --cout] [--cin] [--file=<filename>] [-h | --help] [-q | --quiet] [-v | --version]

Arguments
--airtemp=<temp>    The outside air temperature (in Fahrenheit by default)
--velocity=<speed>  The wind speed
-c | --cout         Display the wind-chill value in Celsius rather than Fahrenheit (Fahrenheit output is default)
--cin               The --airtemp value is in Celsius rather than Fahrenheit
--file=<filename>   Write all output to the specified file rather than the command line
-h | --help         Display this message
-q | --quiet        Do not display anything except the answer in the output
-v | --version      Display the version information
"
versions="
Wind-Chill Calculator

Version: 1.0
Author: Jarod Brown
Date: October 19, 2019
Copyright (C) 2018 by Jarod Brown Enterprises, Inc."

mainPrint(){
  windchill=$(awk "BEGIN {print 35.74 + 0.6215 * $airFahren - (35.75 * ($airVelocity^0.16)) + (0.4275 * $airFahren) * ($airVelocity^0.16); exit}")
	printf "Wind-Chill Calculator \n"
	printf "Outside Air Temperature (F): %s \n" "$airFahren"
	printf "Wind Speed: %s\n" "$airVelocity"
	printf "Wind-Chill (F): %.3f\n" "$windchill"

  if [ "$file" = true ] ;  then
        echo "Wind-Chill Calculator" > $filename
        echo "Outside Air Temperature (F): $airFahren" >> $filename
        echo "Wind Speed: $airVelocity" >> $filename
        echo "Wind-Chill (F): $windchill" >> $filename
  fi
}

cinPrint(){
  changeDegree=$(awk "BEGIN {print $airFahren * 9 / 5 + 32; exit}")
  windchill=$(awk "BEGIN {print 35.74 + 0.6215 * $changeDegree - (35.75 * ($airVelocity^0.16)) + (0.4275 * $changeDegree) * ($airVelocity^0.16); exit}")
	printf "Wind-Chill Calculator\n"
	printf "Outside Air Temperature (C): %s \n" "$airFahren"
	printf "Wind Speed: %s \n" "$airVelocity"
	printf "Wind-Chill (F): %.3f \n" "$windchill"

   if [ "$file" = true ] ;  then
        echo "Wind-Chill Calculator" > $filename
        echo "Outside Air Temperature (C): $airFahren" >> $filename
        echo "Wind Speed: $airVelocity" >> $filename
        echo "Wind-Chill (F): $windchill" >> $filename
  fi
}

coutPrint(){
  windchill=$(awk "BEGIN {print 35.74 + 0.6215 * $airFahren - (35.75 * ($airVelocity^0.16)) + (0.4275 * $airFahren) * ($airVelocity^0.16); exit}")
  changeDegree=$(awk "BEGIN {print ($windchill - 32) * 5 / 9; exit}")

	printf "Wind-Chill Calculator \n"
	printf "Outside Air Temperature (F): %s \n" "$airFahren"
	printf "Wind Speed: %s \n" "$airVelocity"
  printf "Wind-Chill (C): %.3f \n" "$changeDegree"

   if [ "$file" = true ] ;  then
        echo "Wind-Chill Calculator" > $filename
        echo "Outside Air Temperature (F): $airFahren" >> $filename
        echo "Wind Speed: $airVelocity" >> $filename
        echo "Wind-Chill (C): $changeDegree" >> $filename
  fi
}

quietPrint(){
  windchill=$(awk "BEGIN {print 35.74 + 0.6215 * $airFahren - (35.75 * ($airVelocity^0.16)) + (0.4275 * $airFahren) * ($airVelocity^0.16); exit}")

  printf "%.3f\n" "$windchill"

  if [ "$file" = true ] ;  then
         printf "%.3f\n" "$windchill" > $filename
        
  fi
}


help=false
version=false
cout=false
cin=false
quiet=false
file=false
airtemp=false
velocity=false


eval set -- "$option"

while (( "$#" )); do
    case "$1" in
    --airtemp)

        if [ -z "$2" ]
          then 
          exit 3

        elif [ $2 -gt 41 ] || [ $2 -lt -58 ]
        then

        exit 4 
        else
        airFahren="$2"
        airtemp=true
        fi 
        shift 2
          ;;

    -c|--cout)
      var=$((var+1))

      if [ $var -gt 1 ]
      then
        exit 2
      else
        
        cout=true
        coutPrint
        fi 
        shift 2
        
        ;;

    --cin)
        
        cinPrint
        cin=true
        shift 2
        
        ;;

    --file)
      file=true
      if [ -z "$2" ]
          then 
          exit 3
      else
      filename="$2"
      $(touch $filename)
      fi
      shift 2
      
			  ;;
    -h|--help)
        help=true
        if [ "$cin" = true ] || [ "$cout" = true ] || [ "$quiet" = true ] || [ "$Version" = true ] || [ "$file" = true ] || [ "$airtemp" = true ] || [ "$velocity" = true ];  
        then

        exit 2
        else
        echo "$usage"
        fi
        
        shift 2
        ;;
    -q|--quiet)
        quiet=true
        quietPrint
        shift 2
        
        ;;
    -v|--version)
        version=true
        if [ "$cin" = true ] || [ "$cout" = true ] || [ "$quiet" = true ] || [ "$help" = true ] || [ "$file" = true ] || [ "$airtemp" = true ] || [ "$velocity" = true ];  
        then

        exit 2
        else
        echo "$versions"
        fi
        shift 2
        ;;

    --velocity)
       if [ -z "$2" ]
          then 
          exit 3

      elif [ $2 -gt 50 ] || [ $2 -lt 2 ]
        then

        exit 4 
        else
        velocity=true       
      airVelocity="$2"
      fi 
      shift 2
		
			;;
    --)
        shift
        break
        ;;
     *)
        break
        ;;

    
    esac
    #shift
    



    
done

if [ "$cin" = false ] && [ "$cout" = false ] && [ "$quiet" = false ] && [ "$help" = false ] && [ "$version" = false ];  then
  mainPrint
fi
[ $? -eq 0 ] || { 
    echo "Incorrect options provided"
    exit 1
}
exit 0;