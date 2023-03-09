# Extract Two Movement Speeds

MoveApps

Github repository: *github.com/movestore/Flight-Speed-Estimation*

## Description
Fits multimodal to GPS ground speed distribution and determines the peaks to filter for flight locations (above minimum). A table of track-specific parameters is provided, including average flight speed. This App works only with (instantaneous) GPS ground speed!

## Documentation
This App uses the locmodes function from the multimodes package to fit a bimodal to the ground speed distribution of each track/animal. For each track a histogramme with the fitted function is provided. Mode1 (estimated non-flight speed), antimode (minimum between both behaviours) and mode2 (estimated flight speed) are visible by dotted lines in the plot and provided in a .csv table. In the table also average and standard deviation of the three parameters are provided.

If selected, only the locations with ground speed above the antimode are passed on, else the complete data set.

Note that this App works properly only if the two movement modes (no flight and flight) properly separate by ground speed. If there are e.g. intermediate behaviours, clear separations might be difficult and results inaccurate.

### Input data
moveStack in Movebank format

### Output data
moveStack in Movebank format

### Artefacts
`Modes_Histogrammes.pdf`: for each track/animal a histogramme with the fitted distribution overlaid, also including mode1, antimode and mode2.

`groudspeed_modes.csv`: table of fitted model parameters by individual and averages/standard deviations added.

### Settings 
**Output data specification. (`retdata`):** selected if want to output/pass on the full data set (default) or only the flight locations (ground speed above antimode).

### Null or error handling:
**Setting `retdata`:** can only have two viable options

**Data:** If there are no flight data in your input data set, the results might be very unmeaningful and lead to an empty return data set or an error.

