﻿* Encoding: UTF-8.

***** Descriptive Statistics *****.
EXAMINE VARIABLES=DV5
  /PLOT NONE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

EXAMINE VARIABLES=DV5 BY IV2
  /PLOT NONE
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

***** T Tests (One Sample) *****.
T-TEST
  /TESTVAL=5
  /MISSING=ANALYSIS
  /VARIABLES=DV5
  /CRITERIA=CI(.95).

***** T Tests (Independent Samples) *****.
T-TEST GROUPS=IV1('Friend' 'Stranger')
  /MISSING=ANALYSIS
  /VARIABLES=DV5
  /CRITERIA=CI(.95).

***** T Tests (Paired Samples) *****.
T-TEST PAIRS=DV3_T1 WITH DV3_T2 (PAIRED)
  /CRITERIA=CI(.9500)
  /MISSING=ANALYSIS.

***** ANOVA (Main Effects & Interaction Effects) *****.
GLM DV3_T1 DV3_T2
  /WSFACTOR=Within 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=Within.

UNIANOVA DV5 BY IV1 IV2
  /METHOD=SSTYPE(3)
  /INTERCEPT=INCLUDE
  /CRITERIA=ALPHA(0.05)
  /DESIGN=IV1 IV2 IV1*IV2.

GLM DV3_T1 DV3_T2 BY IV1 IV2
  /WSFACTOR=Within 2 Polynomial 
  /METHOD=SSTYPE(3)
  /CRITERIA=ALPHA(.05)
  /WSDESIGN=Within 
  /DESIGN=IV1 IV2 IV1*IV2.

***** ANOVA (Planned Contrasts) *****.
autorecode variables = IV2
 /into IV2recode.

ONEWAY DV5 BY IV2recode
  /CONTRAST=-1 1 0 
  /MISSING ANALYSIS.

ONEWAY DV5 BY IV2recode
  /CONTRAST=-1 0.5 0.5
  /MISSING ANALYSIS.

***** ANOVA (Simple Main Effects) *****.
DATASET ACTIVATE DataSet1.
UNIANOVA DV5 BY IV1 IV2
  /INTERCEPT=INCLUDE
  /EMMEANS=TABLES(IV1*IV2)  COMPARE(IV1)
  /CRITERIA=ALPHA(0.05)
  /DESIGN=IV1 IV2 IV1*IV2.

***** Linear Regression *****.
COMPUTE DV5xDV6 = DV5 * DV6.
REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT DV7
  /METHOD=ENTER DV5 DV6 DV5xDV6.

***** Correlation Tests *****.
CORRELATIONS
  /VARIABLES=DV3_T1 DV3_T2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

***** Chi-Square Tests *****.
autorecode variables = DV2
 /into DV2recode.
NPAR TESTS
  /CHISQUARE=DV2recode
  /EXPECTED=EQUAL
  /MISSING ANALYSIS.

CROSSTABS
  /TABLES=DV2 BY IV2
  /FORMAT=AVALUE TABLES
  /STATISTICS=CHISQ 
  /CELLS=COUNT
  /COUNT ROUND CELL.

***** Levene's Test for Equality of Variances *****.
DATASET ACTIVATE DataSet1.
AUTORECODE VARIABLES=IV2 
  /INTO IV2_Cat
  /PRINT.

ONEWAY DV5 BY IV2_Cat
  /STATISTICS HOMOGENEITY 
  /MISSING ANALYSIS.